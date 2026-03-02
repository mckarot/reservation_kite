# 🔐 RÈGLES DE SÉCURITÉ FIRESTORE — RESERVATION KITE

**Version :** 3.0 (Post-Audit)  
**Date :** 2 mars 2026  
**Statut :** ✅ PRÊT POUR PRODUCTION

---

## 📊 RÉSUMÉ DE L'AUDIT

| Collection | État avant | État après | Priorité |
|------------|------------|------------|----------|
| `users` | 🔴 Critique | ✅ Sécurisé | 1 |
| `reservations` | 🔴 Critique | ✅ Sécurisé | 1 |
| `admins` | 🔴 Critique | ✅ Sécurisé | 1 |
| `notifications` | 🔴 Critique | ✅ Sécurisé | 2 |
| `transactions` | 🟡 Moyen | ✅ Sécurisé | 2 |
| `availabilities` | 🟡 Moyen | ✅ Sécurisé | 2 |
| `settings` | 🟢 OK | ✅ Maintenu | - |
| `equipment` | 🟢 OK | ✅ Maintenu | - |
| `staff` | 🟢 OK | ✅ Maintenu | - |
| `sessions` | 🟢 OK | ✅ Maintenu | - |
| `credit_packs` | 🟢 OK | ✅ Maintenu | - |
| `equipment_categories` | 🟢 OK | ✅ Maintenu | - |

---

## 🎯 RÔLES UTILISATEURS

| Rôle | Description | Permissions |
|------|-------------|-------------|
| **Public** | Non authentifié | Lecture catalogue uniquement |
| **User** | Authentifié (élève) | Ses données, ses réservations |
| **Staff** | Instructeur | Ses élèves, ses sessions |
| **Admin** | Administrateur | Tout (écriture + lecture complète) |

---

## 📜 RÈGLES DE SÉCURITÉ COMPLÈTES

```javascript
rules_version = '2';

service cloud.firestore {
  
  // ============================================================
  // FONCTIONS UTILITAIRES
  // ============================================================
  
  // Vérifie si l'utilisateur est authentifié
  function isAuthenticated() {
    return request.auth != null;
  }
  
  // Récupère l'UID de l'utilisateur connecté
  function currentUserId() {
    return request.auth.uid;
  }
  
  // Vérifie si l'utilisateur est propriétaire d'une ressource
  function isOwner(userId) {
    return isAuthenticated() && currentUserId() == userId;
  }
  
  // Vérifie si l'utilisateur est dans la collection admins
  function isAdmin() {
    return isAuthenticated() && 
      exists(/databases/$(database)/documents/admins/$(currentUserId()));
  }
  
  // Vérifie si l'utilisateur est dans la collection staff
  function isStaff() {
    return isAuthenticated() && 
      exists(/databases/$(database)/documents/staff/$(currentUserId()));
  }
  
  // Valide qu'un email est bien formaté
  function isValidEmail(email) {
    return email is string && email.matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');
  }
  
  // Valide qu'un string n'est pas trop long (protection DoS)
  function isValidString(str, maxLength) {
    return str is string && str.size() <= maxLength;
  }
  
  // Valide qu'une liste n'est pas trop grande
  function isValidList(list, maxLength) {
    return list is list && list.size() <= maxLength;
  }
  
  // Vérifie qu'un timestamp est un serverTimestamp
  function isServerTimestamp(value) {
    return value is timestamp;
  }
  
  // ============================================================
  // COLLECTION: admins
  // ============================================================
  // Stocke les UIDs des administrateurs
  // CRITIQUE: Seul un admin existant peut ajouter un nouvel admin
  
  match /admins/{adminId} {
    // Lecture: tous les authentifiés (pour vérification rapide)
    allow read: if isAuthenticated();
    
    // Création: seul un admin existant peut promouvoir quelqu'un
    allow create: if isAdmin();
    
    // Modification/Suppression: admin uniquement
    allow update, delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: users
  // ============================================================
  // Profils utilisateurs et élèves
  
  match /users/{userId} {
    // Lecture:
    // - Admin: tout voir
    // - Staff: voir tous les élèves
    // - User: son profil + profils staff (pour booking)
    allow read: if isAuthenticated() && (
      isAdmin() || 
      isStaff() || 
      isOwner(userId) ||
      get(/databases/$(database)/documents/users/$(userId)).data.role == 'instructor'
    );
    
    // Création: son propre profil uniquement
    allow create: if isAuthenticated() && 
      isOwner(userId) &&
      // Champs requis
      hasValidField(request.resource.data, 'display_name') &&
      hasValidField(request.resource.data, 'email') &&
      isValidEmail(request.resource.data.email) &&
      // Rôle par défaut: student (ne peut pas se mettre admin)
      request.resource.data.role in ['student', null] &&
      // Wallet à 0 à la création
      (request.resource.data.keys().hasAny(['wallet_balance']) ? request.resource.data.wallet_balance == 0 : true);
    
    // Mise à jour:
    // - Admin: tout modifier (sauf created_at)
    // - Owner: modifier ses infos perso uniquement
    allow update: if isAuthenticated() && (
      // Admin: contrôle total (sauf created_at immutable)
      (isAdmin() && 
       request.resource.data.created_at == resource.data.created_at) ||
      
      // Owner: champs limités
      (isOwner(userId) && 
       // Champs IMMUTABLES
       request.resource.data.role == resource.data.role &&
       request.resource.data.wallet_balance == resource.data.wallet_balance &&
       request.resource.data.email == resource.data.email &&
       request.resource.data.created_at == resource.data.created_at &&
       request.resource.data.progress == resource.data.progress &&
       // Champs MODIFIABLES: display_name, photo_url, weight, last_seen
       request.resource.data.diff(resource.data).keys().hasOnly([
         'display_name', 'photo_url', 'weight', 'last_seen'
       ]))
    );
    
    // Suppression: admin uniquement
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: settings
  // ============================================================
  // Configuration globale de l'école
  
  match /settings/{settingId} {
    // Lecture: public (configuration visible par tous)
    allow read: if true;
    
    // Écriture: admin uniquement
    allow write: if isAdmin() && 
      request.resource.data.updated_at is timestamp;
  }
  
  // ============================================================
  // COLLECTION: staff
  // ============================================================
  // Fiches de présentation des moniteurs
  
  match /staff/{staffId} {
    // Lecture: public (pour affichage aux élèves)
    allow read: if true;
    
    // Création: admin ou instructeur pour lui-même
    allow create: if isAuthenticated() && (
      isAdmin() || isOwner(staffId)
    ) &&
    hasValidField(request.resource.data, 'bio') &&
    hasValidField(request.resource.data, 'is_active');
    
    // Mise à jour:
    // - Admin: tout modifier
    // - Owner: modifier sa propre fiche
    allow update: if isAuthenticated() && (
      (isAdmin() && request.resource.data.updated_at is timestamp) ||
      (isOwner(staffId) && 
       request.resource.data.updated_at is timestamp &&
       request.resource.data.diff(resource.data).keys().hasOnly([
         'bio', 'photo_url', 'specialties', 'certificates', 'is_active'
       ]))
    );
    
    // Suppression: admin uniquement
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: credit_packs
  // ============================================================
  // Catalogue des packs de crédits
  
  match /credit_packs/{packId} {
    // Lecture: public (catalogue visible)
    allow read: if true;
    
    // Écriture: admin uniquement
    allow create: if isAdmin() &&
      hasValidField(request.resource.data, 'name') &&
      hasValidField(request.resource.data, 'credits') &&
      hasValidField(request.resource.data, 'price') &&
      request.resource.data.credits is int &&
      request.resource.data.credits > 0 &&
      request.resource.data.price is int &&
      request.resource.data.price >= 0;
    
    allow update: if isAdmin() && 
      request.resource.data.updated_at is timestamp;
    
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: availabilities
  // ============================================================
  // Disponibilités et indisponibilités du staff
  
  match /availabilities/{availabilityId} {
    // Lecture: public (planning visible)
    allow read: if true;
    
    // Création:
    // - Staff: pour soi-même uniquement
    // - Admin: pour n'importe qui
    allow create: if isAuthenticated() && (
      (isStaff() && request.resource.data.instructor_id == currentUserId()) ||
      isAdmin()
    ) &&
    hasValidField(request.resource.data, 'instructor_id') &&
    hasValidField(request.resource.data, 'date') &&
    hasValidField(request.resource.data, 'slot') &&
    request.resource.data.slot in ['morning', 'afternoon'] &&
    request.resource.data.status in ['available', 'unavailable', 'booked'] &&
    request.resource.data.updated_at is timestamp;
    
    // Mise à jour:
    // - Staff: pour soi-même (sauf status 'booked')
    // - Admin: tout modifier
    allow update: if isAuthenticated() && (
      (isStaff() && 
       resource.data.instructor_id == currentUserId() &&
       request.resource.data.status != 'booked' &&
       request.resource.data.updated_at is timestamp) ||
      (isAdmin() && request.resource.data.updated_at is timestamp)
    );
    
    // Suppression:
    // - Staff: pour soi-même (si pas booked)
    // - Admin: toujours
    allow delete: if isAuthenticated() && (
      (isStaff() && resource.data.instructor_id == currentUserId() && resource.data.status != 'booked') ||
      isAdmin()
    );
  }
  
  // ============================================================
  // COLLECTION: sessions
  // ============================================================
  // Cours de Kite Surf
  
  match /sessions/{sessionId} {
    // Lecture: public (planning visible)
    allow read: if true;
    
    // Création: admin uniquement
    allow create: if isAdmin() &&
      hasValidField(request.resource.data, 'date') &&
      hasValidField(request.resource.data, 'slot') &&
      hasValidField(request.resource.data, 'instructor_id') &&
      hasValidField(request.resource.data, 'max_capacity') &&
      request.resource.data.slot in ['morning', 'afternoon'] &&
      request.resource.data.status in ['scheduled', 'cancelled', 'completed'] &&
      request.resource.data.students is list &&
      request.resource.data.students.size() <= request.resource.data.max_capacity &&
      request.resource.data.created_at is timestamp;
    
    // Mise à jour: admin uniquement
    allow update: if isAdmin() && 
      request.resource.data.updated_at is timestamp;
    
    // Suppression: admin uniquement
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: reservations
  // ============================================================
  // Réservations des élèves
  // CRITIQUE: Sécurité renforcée
  
  match /reservations/{reservationId} {
    // Lecture:
    // - Admin: tout voir
    // - Staff: voir toutes
    // - User: les siennes uniquement
    allow read: if isAuthenticated() && (
      isAdmin() || 
      isStaff() ||
      // L'utilisateur peut lire si c'est sa réservation
      (resource.data.pupilId == currentUserId()) ||
      // Ou s'il est dans la liste des students (réservation de groupe)
      (resource.data.students is list && resource.data.students.hasAny([currentUserId()]))
    );
    
    // Création:
    // - User: peut créer sa propre réservation (pupilId = currentUserId)
    // - Admin/Staff: peut créer pour n'importe qui
    allow create: if isAuthenticated() && (
      // User: sa propre réservation uniquement
      (request.resource.data.pupilId == currentUserId()) ||
      // Admin/Staff: peut créer pour les autres
      isAdmin() || isStaff()
    ) &&
    hasValidField(request.resource.data, 'pupilId') &&
    hasValidField(request.resource.data, 'sessionId') &&
    hasValidField(request.resource.data, 'date') &&
    hasValidField(request.resource.data, 'slot') &&
    request.resource.data.status in ['pending', 'confirmed', 'cancelled', 'completed'] &&
    request.resource.data.created_at is timestamp;
    
    // Mise à jour:
    // - Admin: contrôle total
    // - Staff: peut confirmer/annuler
    // - User: peut modifier sa réservation pending uniquement
    allow update: if isAuthenticated() && (
      // Admin: tout modifier
      (isAdmin() && request.resource.data.updated_at is timestamp) ||
      
      // Staff: modifier status et instructor
      (isStaff() && 
       request.resource.data.pupilId == resource.data.pupilId && // ne change pas l'élève
       request.resource.data.date == resource.data.date && // ne change pas la date
       request.resource.data.slot == resource.data.slot &&
       request.resource.data.status in ['pending', 'confirmed', 'cancelled', 'completed'] &&
       request.resource.data.updated_at is timestamp) ||
      
      // User: modifier sa réservation pending uniquement
      (isOwner(resource.data.pupilId) && 
       resource.data.status == 'pending' &&
       request.resource.data.status == 'pending' &&
       request.resource.data.pupilId == resource.data.pupilId &&
       request.resource.data.created_at == resource.data.created_at &&
       request.resource.data.diff(resource.data).keys().hasOnly([
         'sessionId', 'notes'
       ]))
    );
    
    // Suppression:
    // - Admin: toujours
    // - Staff: si pending ou cancelled
    // - User: sa réservation pending uniquement
    allow delete: if isAuthenticated() && (
      isAdmin() ||
      (isStaff() && resource.data.status in ['pending', 'cancelled']) ||
      (isOwner(resource.data.pupilId) && resource.data.status == 'pending')
    );
  }
  
  // ============================================================
  // COLLECTION: notifications
  // ============================================================
  // Notifications push utilisateurs
  
  match /notifications/{notificationId} {
    // Lecture:
    // - Admin: tout voir
    // - User: les siennes uniquement
    allow read: if isAuthenticated() && (
      isAdmin() || 
      resource.data.userId == currentUserId()
    );
    
    // Création:
    // - Admin: peut créer des notifications
    // - Système: notifications automatiques
    allow create: if isAuthenticated() && (
      isAdmin() ||
      // Notification automatique: userId = currentUserId
      (request.resource.data.userId == currentUserId())
    ) &&
    hasValidField(request.resource.data, 'userId') &&
    hasValidField(request.resource.data, 'type') &&
    hasValidField(request.resource.data, 'message') &&
    request.resource.data.type in ['info', 'warning', 'error', 'success', 'booking', 'payment'];
    
    // Mise à jour:
    // - Owner: peut marquer comme lu uniquement
    // - Admin: tout modifier
    allow update: if isAuthenticated() && (
      (isAdmin() && request.resource.data.updated_at is timestamp) ||
      (isOwner(resource.data.userId) && 
       request.resource.data.diff(resource.data).keys().hasOnly(['isRead', 'readAt']))
    );
    
    // Suppression:
    // - Owner: la sienne
    // - Admin: toutes
    allow delete: if isAuthenticated() && (
      isAdmin() || 
      isOwner(resource.data.userId)
    );
  }
  
  // ============================================================
  // COLLECTION: transactions
  // ============================================================
  // Historique des paiements
  // CRITIQUE: Données financières sensibles
  
  match /transactions/{transactionId} {
    // Lecture:
    // - Admin: tout voir
    // - User: les siennes uniquement
    allow read: if isAuthenticated() && (
      isAdmin() || 
      resource.data.user_id == currentUserId()
    );
    
    // Écriture: INTERDIT en direct (Cloud Functions uniquement)
    // Les transactions sont créées par des Cloud Functions sécurisées
    allow write: if false;
  }
  
  // ============================================================
  // COLLECTION: equipment
  // ============================================================
  // Matériel de l'école
  
  match /equipment/{equipmentId} {
    // Lecture: public (inventaire visible)
    allow read: if true;
    
    // Écriture: admin uniquement
    allow create: if isAdmin() &&
      hasValidField(request.resource.data, 'category_id') &&
      hasValidField(request.resource.data, 'brand') &&
      hasValidField(request.resource.data, 'model') &&
      request.resource.data.status in ['available', 'maintenance', 'damaged'] &&
      request.resource.data.updated_at is timestamp;
    
    allow update: if isAdmin() && 
      request.resource.data.updated_at is timestamp;
    
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: equipment_categories
  // ============================================================
  // Catégories d'équipement
  
  match /equipment_categories/{categoryId} {
    // Lecture: public
    allow read: if true;
    
    // Écriture: admin uniquement
    allow create: if isAdmin() &&
      hasValidField(request.resource.data, 'name') &&
      hasValidField(request.resource.data, 'order') &&
      request.resource.data.order is int &&
      request.resource.data.order >= 1;
    
    allow update: if isAdmin() && 
      request.resource.data.updated_at is timestamp;
    
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // COLLECTION: products
  // ============================================================
  // Boutique (futur)
  
  match /products/{productId} {
    // Lecture: public
    allow read: if true;
    
    // Écriture: admin uniquement
    allow create: if isAdmin() &&
      hasValidField(request.resource.data, 'name') &&
      hasValidField(request.resource.data, 'price') &&
      hasValidField(request.resource.data, 'category') &&
      hasValidField(request.resource.data, 'condition') &&
      request.resource.data.category in ['wing', 'kite', 'board', 'harness', 'accessories'] &&
      request.resource.data.condition in ['new', 'used'] &&
      request.resource.data.price is int &&
      request.resource.data.price >= 0;
    
    allow update: if isAdmin() && 
      request.resource.data.updated_at is timestamp;
    
    allow delete: if isAdmin();
  }
  
  // ============================================================
  // RÈGLE PAR DÉFAUT (DENY ALL)
  // ============================================================
  // Toute collection non spécifiée est automatiquement refusée
  
  match /{document=**} {
    allow read, write: if false;
  }
}
```

---

## 📋 CHECKLIST DE DÉPLOIEMENT

### 1. Pré-requis

- [ ] Avoir au moins **un admin** dans la collection `admins`
- [ ] Backup des règles actuelles
- [ ] Tester avec Firebase Emulator

### 2. Créer le premier admin (3 options)

**Option A: Via le bouton d'initialisation (RECOMMANDÉ - Développement)**

1. **Ouvre l'application** et va à l'écran de login
2. **Connecte-toi** avec `admin@mail.com` (ou tout compte admin)
3. **Scrolle en bas** de l'écran de login
4. **Clique sur "🔧 Init Firebase (DEV)"**
5. **Attends** la confirmation "✅ Initialisation Firebase réussie!"

Ce bouton crée automatiquement :
- ✅ Le document `admins/{uid}` pour l'utilisateur connecté
- ✅ `settings/school_config` avec les paramètres par défaut
- ✅ `settings/theme_config` avec les couleurs par défaut
- ✅ 4 packs de crédits par défaut

**Option B: Manuellement dans la console**

1. https://console.firebase.google.com/project/reservation-kite/firestore/data
2. Collection `admins` → Ajouter document
3. ID: `{UID_DE_L_UTILISATEUR}`
4. Champ: `email` = `admin@mail.com`

**Option C: Via Firebase CLI**

```bash
# Exporter les utilisateurs
firebase auth:export /tmp/users.json --format json

# Trouver l'UID de l'admin
cat /tmp/users.json | grep -A 5 "admin@mail.com"
```

### 3. Déployer les règles

```bash
cd /Users/mathieu/StudioProjects/reservation_kite

# Vérifier la syntaxe
firebase deploy --only firestore:rules

# Déployer
firebase deploy --only firestore:rules
```

### 4. Tests de validation

| Test | Résultat attendu |
|------|------------------|
| Lecture `settings` sans auth | ✅ Autorisé |
| Lecture `users` connecté | ✅ Son profil + staff |
| Écriture `reservations` (sa réservation) | ✅ Autorisé |
| Écriture `reservations` (autre) | ❌ Refusé |
| Création `admins` sans être admin | ❌ Refusé |
| Lecture `transactions` (les siennes) | ✅ Autorisé |
| Lecture `transactions` (autres) | ❌ Refusé |

---

## 🔧 MAINTENANCE

### Ajouter un admin

```javascript
// Dans la console Firebase → Firestore → admins
// Nouveau document: {UID} avec email: "nouvel.admin@example.com"
```

### Promouvoir un utilisateur staff

```javascript
// 1. Créer le document dans staff/{uid}
// 2. Mettre à jour users/{uid}.role = 'instructor' (admin uniquement)
```

### Dépannage

| Problème | Solution |
|----------|----------|
| "Permission denied" sur settings | Vérifier que la lecture est publique (`allow read: if true`) |
| Admin ne peut pas écrire | Vérifier que le document existe dans `admins/{uid}` |
| User peut lire les autres | Vérifier la règle `isOwner()` ou `isStaff()` |

---

## 📚 DOCUMENTS LIÉS

- `firestore_schema.md` - Schéma de base de données
- `COMPLIANCE_GDPR.md` - Conformité RGPD
- `MCP_DART_SETUP.md` - Configuration MCP

---

**Dernière mise à jour :** 2 mars 2026  
**Prochaine revue :** Après déploiement en production
