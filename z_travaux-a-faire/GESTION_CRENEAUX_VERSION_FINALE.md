# 📅 GESTION DES CRÉNEAUX - OPTION A (VERSION FINALE)

## 🎯 PRINCIPE FONDAMENTAL

> **Le statut de l'équipement NE CHANGE JAMAIS automatiquement.**
> 
> La disponibilité est **TOUJOURS** calculée via les conflits de réservation.

---

## ⚠️ PROBLÈMES RÉSOLUS

### Problème 1 : Réservation future bloque l'équipement

**Avant ❌ :**
```
4 mars : Jean réserve pour le 11 mars (dans 1 semaine)
→ Statut équipement : reserved
→ Personne ne peut réserver du 4 au 11 mars !
```

**Après ✅ :**
```
4 mars : Jean réserve pour le 11 mars (dans 1 semaine)
→ Statut équipement : available (inchangé)
→ Tout le monde peut réserver du 4 au 10 mars
→ Le 11 mars, le créneau est bloqué par les conflits
```

### Problème 2 : Full_day bloque toute la journée

**Avant ❌ :**
```
Jean réserve full_day (9h-17h)
→ Statut : reserved
→ L'équipement reste reserved même après la fin de la journée
```

**Après ✅ :**
```
Jean réserve full_day (9h-17h)
→ Statut : available (inchangé)
→ Le créneau est bloqué par les conflits
→ Après 17h, l'équipement est disponible pour le lendemain
```

---

## 📊 FONCTIONNEMENT DÉTAILLÉ

### 1. Réservation d'équipement

```dart
// bookEquipmentAtomically()

Étapes :
1. ✅ Vérifier que l'équipement existe
2. ✅ Vérifier qu'il n'est PAS 'maintenance', 'damaged' ou 'reserved' (manuel)
3. ✅ Vérifier les conflits de créneau pour la date demandée
4. ❌ AUCUN CHANGEMENT DE STATUT
5. ✅ Créer la réservation
```

### 2. Disponibilité par créneau

| Créneau demandé | Vérification des conflits |
|----------------|--------------------------|
| `morning` (9h-12h) | Conflit avec `morning` et `full_day` |
| `afternoon` (14h-17h) | Conflit avec `afternoon` et `full_day` |
| `full_day` (9h-17h) | Conflit avec `morning`, `afternoon` et `full_day` |

**Exemple concret :**
```
Date : 11 mars 2026
Équipement : Kite F-One 12m²

Réservations existantes :
├─ 9h-12h (morning) : Jean
└─ 14h-17h (afternoon) : Marie

Nouvelle demande :
└─ Jean veut réserver pour 14h-17h (afternoon)
   → Conflit détecté avec la réservation de Marie
   → ❌ Réservation refusée
```

### 3. Libération d'équipement

```dart
// releaseEquipment()

Étapes :
1. ✅ Lire la réservation
2. ✅ Mettre à jour le statut de la réservation (cancelled/completed)
3. ❌ AUCUN CHANGEMENT DE STATUT DE L'ÉQUIPEMENT
```

---

## 🔑 STATUTS DE L'ÉQUIPEMENT

| Statut | Signification | Changé par | Impact sur réservations |
|--------|--------------|------------|------------------------|
| `available` | Équipement disponible | Système (défaut) | ✅ Réservations autorisées |
| `reserved` | Réservation manuelle | **Admin uniquement** | ❌ Bloque toutes réservations |
| `maintenance` | En maintenance | Admin ou incident | ❌ Bloque toutes réservations |
| `damaged` | Endommagé | Admin ou incident | ❌ Bloque toutes réservations |

### Quand utiliser le statut `reserved` manuellement ?

L'admin peut définir manuellement le statut `reserved` pour :
- 📅 **Réserver pour un événement spécial** (ex: compétition le 15 mars)
- 🔒 **Bloquer temporairement** (ex: en attente de réparation mineure)
- 🎯 **Réserver pour un cours spécifique** (ex: matériel réservé pour le stage IKO)

---

## 📝 EXEMPLES CONCRETS

### Exemple 1 : Réservation future (dans 1 semaine)

```
📅 4 mars (aujourd'hui)
   Jean réserve une Kite 12m² pour le 11 mars (matin)

   → Statut Kite : available ✅
   → Autres élèves : Peuvent réserver pour le 4-10 mars ✅
   → Le 11 mars matin : Bloqué par conflit ❌

📅 5 mars
   Marie veut réserver la même Kite 12m² pour le 6 mars (matin)
   
   → Vérification : Pas de conflit le 6 mars
   → ✅ Réservation acceptée !

📅 11 mars (jour J)
   8h30 : Jean arrive pour son cours
   → Sa réservation est confirmée
   → Il récupère le matériel

   12h30 : Jean rend le matériel
   → La réservation est marquée 'completed'
   → Le matériel est disponible pour l'après-midi ✅
```

### Exemple 2 : Réservation journée complète

```
📅 15 mars
   Sophie réserve une Kite 12m² pour la journée (full_day)

   → Statut Kite : available ✅
   → Créneau 9h-17h : Bloqué par conflit ❌

   Même jour, 10h :
   Thomas veut réserver pour 14h-17h (afternoon)
   
   → Vérification : Conflit avec full_day de Sophie
   → ❌ Réservation refusée
```

### Exemple 3 : Double réservation (matin + après-midi)

```
📅 20 mars
   9h : Mathieu réserve pour le matin (morning)
   → ✅ Confirmé

   10h : Julie réserve pour l'après-midi (afternoon)
   → Vérification : Pas de conflit avec morning
   → ✅ Confirmé !

   Résultat :
   ├─ Matin (9h-12h) : Mathieu
   └─ Après-midi (14h-17h) : Julie
   → 1 équipement, 2 réservations dans la même journée ✅
```

### Exemple 4 : Admin bloque pour événement

```
📅 1er avril (admin anticipe)
   L'admin organise une compétition le 10 avril
   
   → Admin change le statut de 5 kites à `reserved`
   → Ajoute une note : "Compétition 10 avril"

   📅 2 avril
   Un élève veut réserver une des 5 kites pour le 10 avril
   
   → Vérification : Statut = reserved
   → ❌ Réservation refusée (comme souhaité)

   📅 10 avril (après l'événement)
   → Admin change le statut à `available`
   → Les kites sont de nouveau réservables ✅
```

---

## 🔧 MODIFICATIONS TECHNIQUES

### 1. `bookEquipmentAtomically` (firestore_equipment_repository.dart)

**Avant :**
```dart
if (isFullDay) {
  transaction.update(equipmentRef, {
    'status': 'reserved',  // ❌ Change le statut
  });
}
```

**Après :**
```dart
// 3. AUCUNE MISE À JOUR DU STATUT
// Le statut reste tel quel (available, reserved manuel, etc.)
// La disponibilité est gérée uniquement par les conflits de réservation

// 4. Création de la réservation
transaction.set(bookingRef, {
  ...bookingData,
  'equipment_id': equipmentId,
  'status': 'confirmed',
  'created_at': FieldValue.serverTimestamp(),
  'updated_at': FieldValue.serverTimestamp(),
});
```

### 2. `releaseEquipment` (firestore_equipment_repository.dart)

**Avant :**
```dart
// Vérifie les autres réservations
if (remainingBookings.isEmpty) {
  transaction.update(equipmentRef, {
    'status': 'available',  // ❌ Change le statut
  });
}
```

**Après :**
```dart
// 2. Mettre à jour le statut de la réservation
transaction.update(bookingRef, {
  'status': newBookingStatus,  // cancelled ou completed
  'updated_at': FieldValue.serverTimestamp(),
});

// 3. AUCUNE MISE À JOUR DU STATUT DE L'ÉQUIPEMENT
// Le statut reste tel quel
```

### 3. `_watchSizeAvailability` (equipment_booking_screen.dart)

**Déjà correct !** Utilise `countConflictingBookings` pour calculer la disponibilité.

```dart
if (eq.status == EquipmentStatus.maintenance || 
    eq.status == EquipmentStatus.damaged) {
  return false; // Toujours indisponible
}

final conflicts = countConflictingBookings(eqBookings, _selectedSlot);
return conflicts == 0; // Disponible si aucun conflit
```

---

## 🧪 SCÉNARIOS DE TEST

### Test 1 : Réservation future n'affecte pas le présent

```
1. Connecté : mat@mail.com (élève)
2. Écran : 🏄 Location Matériel
3. Date : +7 jours (clique 7 fois sur →)
4. Créneau : Matin
5. Réserver : Kite 12m²
6. ✅ Réservation confirmée

7. Revenir à aujourd'hui (clique sur "Aujourd'hui")
8. Même équipement : Kite 12m²
9. Créneau : Matin ou Après-midi
10. ✅ Réservation acceptée ! (l'équipement est disponible)
```

### Test 2 : Matin + Après-midi (même jour, même équipement)

```
1. Connecté : mat@mail.com
2. Date : Demain
3. Créneau : Matin
4. Réserver : Kite 12m²
5. ✅ Confirmé

6. Déconnecter → Connecter : autre@email.com
7. Date : Demain (même date)
8. Créneau : Après-midi
9. Équipement : Kite 12m² (même)
10. ✅ Confirmé ! (pas de conflit de créneau)
```

### Test 3 : Full_day bloque tout

```
1. Connecté : mat@mail.com
2. Date : Demain
3. Créneau : Journée
4. Réserver : Kite 12m²
5. ✅ Confirmé

6. Déconnecter → Connecter : autre@email.com
7. Date : Demain
8. Créneau : Matin
9. Équipement : Kite 12m²
10. ❌ Refusé (conflit avec full_day)
```

### Test 4 : Admin bloque manuellement

```
1. Connecté : admin@mail.com
2. Écran : 📦 Gestion Matériel
3. Équipement : Kite 12m²
4. Menu (⋮) → "Réserver" (statut → reserved)
5. ✅ Statut changé manuellement

6. Déconnecter → Connecter : mat@mail.com
7. Écran : 🏄 Location Matériel
8. Équipement : Kite 12m²
9. ❌ Indisponible (statut = reserved)
```

### Test 5 : Réservation dans le futur + libération

```
1. Connecté : mat@mail.com
2. Date : +7 jours
3. Créneau : Matin
4. Réserver : Kite 12m²
5. ✅ Confirmé

6. Admin : 📊 Réservations Matériel
7. Trouver la réservation du 11 mars
8. Bouton : "Annuler"
9. ✅ Réservation annulée (statut → cancelled)

10. Élève : Réserver pour le 11 mars (matin)
11. ✅ Confirmé ! (la réservation annulée ne bloque plus)
```

---

## 📚 FICHIERS MODIFIÉS

| Fichier | Fonction modifiée | Changement |
|---------|------------------|------------|
| `firestore_equipment_repository.dart` | `bookEquipmentAtomically` | Supprime changement de statut |
| `firestore_equipment_repository.dart` | `releaseEquipment` | Supprime changement de statut |
| `equipment_booking_screen.dart` | `_watchSizeAvailability` | Commentaire mis à jour |
| `GESTION_CRENEAUX_VERSION_FINALE.md` | **NOUVEAU** | Documentation complète |

---

## ✅ CHECKLIST FINALE

- [x] Supprimer le changement de statut dans `bookEquipmentAtomically`
- [x] Supprimer le changement de statut dans `releaseEquipment`
- [x] Mettre à jour les commentaires dans l'UI
- [x] Documenter le nouveau fonctionnement
- [ ] Tests manuels (à effectuer)
- [ ] Mettre à jour le firestore_schema.md si nécessaire
- [ ] Informer les utilisateurs du changement

---

## 🎯 BÉNÉFICES

| Avant | Après |
|-------|-------|
| Réservation future = équipement bloqué avant | Réservation future = équipement libre avant |
| Full_day = statut changed | Full_day = conflit seulement |
| 1 équipement = 1 réservation/jour | 1 équipement = 2 réservations/jour (matin+aprem) |
| Statut change automatiquement | Statut = manuel (admin contrôle) |
| Complexe à déboguer | Simple : conflits = seule logique |

---

## 📖 RÈGLE D'OR

> **Un équipement avec le statut `available` peut avoir 10 réservations pour 10 jours différents.**
> 
> Son statut reste `available` car c'est les **conflits de créneau** qui gèrent la disponibilité.

---

**Date de mise en place :** 4 mars 2026  
**Version :** 2.0.0 (Option A Raffinée)  
**Statut :** ✅ Implémenté - En attente de tests manuels
