# SOURCE DE VÉRITÉ : SCHÉMA FIRESTORE

> [!IMPORTANT]
> Ce document est synchronisé avec le projet Firebase `reservation-kite`.
> **Dernière mise à jour :** 5 mars 2026
> **Scan effectué via :** MCP Firebase Server

---

## 📊 VUE D'ENSEMBLE

| Collection | Documents | Statut | Description |
|------------|-----------|--------|-------------|
| `admins` | 2 | ✅ Active | Administrateurs |
| `credit_packs` | 3 | ✅ Active | Forfaits de crédits |
| `equipment_categories` | 6 | ✅ Active | Catégories d'équipements |
| `equipment_items` | 2 | ✅ Active | Équipements individuels |
| `equipment_rentals` | 2 | ✅ Active | Locations d'équipements |
| `notifications` | ~15 | ✅ Active | Notifications utilisateurs |
| `reservations` | ~10 | ✅ Active | Réservations de cours |
| `settings` | 2 | ✅ Active | Configuration |
| `staff` | 1 | ✅ Active | Moniteurs |
| `users` | 4 | ✅ Active | Utilisateurs |

---

## COLLECTIONS ACTIVES (Production)

### COLLECTION: admins
- **Description**: Utilisateurs disposant de droits d'administration globaux.
- **Chemin**: `/admins/{uid}`
- **Documents**: 2
- **Champs**:
  - `uid`: string (required) - Identifiant unique (ID Firebase Auth)
  - `email`: string (required) - Email de l'admin
  - `createdAt`: timestamp (required) - Date de création
  - `createdBy`: string (required) - UID de l'admin créateur (ou "firebase_init_script")

**Exemple**:
```json
{
  "uid": "gjC27XhSqsYUJn8UhZ57cA1l7xf1",
  "email": "yoyo@mail.com",
  "createdAt": "2026-03-02T21:35:49.181Z",
  "createdBy": "nzLE2fxgLYO2AtrkUMJVC2cJYej1"
}
```

---

### COLLECTION: users
- **Description**: Profils utilisateurs synchronisés avec Firebase Auth.
- **Chemin**: `/users/{uid}`
- **Documents**: 4
- **Champs**:
  - `id`: string (required) - Identifiant unique (UID Firebase Auth)
  - `display_name`: string (required) - Nom affiché
  - `email`: string (required) - Email unique
  - `role`: string (required) - ['student', 'admin', 'instructor'] (default: 'student')
  - `photo_url`: string? (nullable) - URL photo de profil
  - `wallet_balance`: int (default: 0) - Solde du portefeuille en crédits
  - `total_credits_purchased`: int (default: 0) - Total des crédits achetés
  - `weight`: int? (nullable) - Poids de l'utilisateur (kg)
  - `progress`: map? (nullable) - Progression IKO
    - `iko_level`: string - Niveau actuel
    - `checklist`: array<string> - Compétences validées
    - `notes`: array<map> - Notes des moniteurs
      - `date`: timestamp
      - `content`: string
      - `instructor_id`: string
  - `created_at`: timestamp (required) - Date de création
  - `last_seen`: timestamp (required) - Dernière connexion
  - `updatedAt`: timestamp? (nullable) - Date de dernière mise à jour

**Exemple**:
```json
{
  "id": "VwvI02M408dloJQAYHwkODjfHBy2",
  "display_name": "mat",
  "email": "mat@mail.com",
  "role": "student",
  "wallet_balance": 22,
  "total_credits_purchased": 30,
  "progress": {
    "iko_level": "Niveau 2 - Intermédiaire",
    "checklist": ["Préparation & Sécurité", "Pilotage zone neutre", "Décollage / Atterrissage"],
    "notes": [
      {"content": "super", "date": "2026-02-25T14:03:28.033078", "instructor_id": "yDlL3wne16f3bWHSsIPEDkHwRQk2"}
    ]
  },
  "created_at": "2026-02-25T16:54:27.306Z",
  "last_seen": "2026-03-06T01:19:24.986Z"
}
```

---

### COLLECTION: reservations
- **Description**: Réservations de cours (planning).
- **Chemin**: `/reservations/{reservationId}`
- **Documents**: ~10
- **Champs**:
  - `id`: string (required) - Identifiant unique (UUID)
  - `client_name`: string (required) - Nom du client affiché
  - `pupil_id`: string (required) - FK → users.uid
  - `date`: timestamp (required) - Date du cours (ISO 8601)
  - `slot`: string (required) - ['morning', 'afternoon', 'fullDay']
  - `staff_id`: string? (nullable) - FK → staff.id (moniteur assigné)
  - `status`: string (required) - ['pending', 'confirmed', 'cancelled']
  - `notes`: string (default: '') - Notes de la réservation
  - `created_at`: timestamp (required) - Date de création
  - `equipment_assignment_required`: boolean (default: false) - **NOUVEAU** 
    - `true` = matériel doit être assigné par le moniteur avant de démarrer
    - `false` = matériel déjà assigné ou pas de matériel requis

**Exemple**:
```json
{
  "id": "46df81e8-658f-4022-9fc5-815a400f886f",
  "client_name": "mat",
  "pupil_id": "VwvI02M408dloJQAYHwkODjfHBy2",
  "date": "2026-03-07T00:00:00.000Z",
  "slot": "morning",
  "staff_id": "yDlL3wne16f3bWHSsIPEDkHwRQk2",
  "status": "cancelled",
  "notes": "",
  "created_at": "2026-03-05T13:24:54.039434Z",
  "equipment_assignment_required": false
}
```

---

### COLLECTION: staff
- **Description**: Effectif des moniteurs.
- **Chemin**: `/staff/{staffId}`
- **Documents**: 1
- **Champs**:
  - `id`: string (required) - Identifiant unique (UID Firebase Auth)
  - `name`: string (required) - Nom du moniteur
  - `bio`: string (required) - Biographie
  - `photo_url`: string (required) - URL de la photo
  - `is_active`: boolean (default: true) - Statut actif
  - `specialties`: array<string> (default: []) - Spécialités
  - `certificates`: array<string> (default: []) - Certifications
  - `updated_at`: timestamp (required) - Date de dernière mise à jour

**Exemple**:
```json
{
  "id": "yDlL3wne16f3bWHSsIPEDkHwRQk2",
  "name": "moniteur",
  "bio": "",
  "photo_url": "",
  "is_active": true,
  "specialties": [],
  "certificates": [],
  "updated_at": "2026-02-25T17:23:36.383Z"
}
```

---

### COLLECTION: credit_packs
- **Description**: Forfaits de crédits disponibles à l'achat.
- **Chemin**: `/credit_packs/{packId}`
- **Documents**: 3
- **Champs**:
  - `id`: string (required) - Identifiant unique (ex: `pack_1_unit`, `pack_5_units`, `pack_10_units`)
  - `name`: string (required) - Nom affiché du forfait
  - `credits`: int (required) - Nombre de crédits inclus
  - `price`: double (required) - Prix en euros
  - `is_active`: boolean (default: true) - Disponible à la vente

**Exemple**:
```json
{
  "id": "pack_10_units",
  "name": "Forfait 10 Séances",
  "credits": 10,
  "price": 400,
  "is_active": true
}
```

---

### COLLECTION: settings
- **Description**: Configurations globales de l'école et de l'application.
- **Chemin**: `/settings/{docId}`
- **Documents**: 2
- **Documents connus**:
  - `school_config` - Configuration de l'école
  - `theme_config` - Configuration du thème UI

#### Document: school_config
- **Champs**:
  - `hours`: map (required)
    - `morning`: map
      - `start`: string (ex: "08:00")
      - `end`: string (ex: "12:00")
    - `afternoon`: map
      - `start`: string (ex: "13:00")
      - `end`: string (ex: "18:00")
  - `daysOff`: array<string> (default: []) - Jours de fermeture
  - `maxStudentsPerInstructor`: int (default: 4) - Max élèves par moniteur
  - `weather_latitude`: double - Latitude pour météo
  - `weather_longitude`: double - Longitude pour météo
  - `updated_at`: timestamp (required)

**Exemple**:
```json
{
  "hours": {
    "morning": {"start": "08:00", "end": "12:00"},
    "afternoon": {"start": "13:00", "end": "18:00"}
  },
  "daysOff": [],
  "maxStudentsPerInstructor": 4,
  "weather_latitude": 37.785834,
  "weather_longitude": -122.406417,
  "updated_at": "2026-02-25T17:46:21.677Z"
}
```

#### Document: theme_config
- **Champs**:
  - `primaryColor`: int (ARGB) - Couleur principale
  - `secondaryColor`: int (ARGB) - Couleur secondaire
  - `accentColor`: int (ARGB) - Couleur d'accentuation
  - `version`: int - Version du thème
  - `updatedAt`: timestamp (required)
  - `updatedBy`: string (required) - UID de l'utilisateur

**Exemple**:
```json
{
  "primaryColor": 4293284096,
  "secondaryColor": 4294940672,
  "accentColor": 4294961979,
  "version": 27,
  "updatedAt": "2026-03-02T21:59:56.041951Z",
  "updatedBy": "nzLE2fxgLYO2AtrkUMJVC2cJYej1"
}
```

---

### COLLECTION: notifications
- **Description**: Notifications système pour les utilisateurs.
- **Chemin**: `/notifications/{notificationId}`
- **Documents**: ~15
- **Champs**:
  - `id`: string (required) - Identifiant unique (UUID)
  - `user_id`: string (required) - FK → users.uid
  - `title`: string (required) - Titre de la notification
  - `message`: string (required) - Contenu du message
  - `type`: string (required) - ['success', 'alert', 'info']
  - `timestamp`: timestamp (required) - Date de la notification
  - `is_read`: boolean (default: false) - Statut de lecture

**Exemple**:
```json
{
  "id": "1deaad51-9ad6-4318-9b30-884fa889af1a",
  "user_id": "VwvI02M408dloJQAYHwkODjfHBy2",
  "title": "Cours Validé ! 🤙",
  "message": "Votre séance du 26/3 a été confirmée.",
  "type": "success",
  "timestamp": "2026-03-04T21:52:55.819979Z",
  "is_read": false
}
```

---

## COLLECTIONS EQUIPMENT (NOUVEAU - v2.2)

### COLLECTION: equipment_categories
- **Description**: Catégories d'équipements (kite, board, foil, etc.).
- **Chemin**: `/equipment_categories/{categoryId}`
- **Documents**: 6
- **Champs**:
  - `id`: string (required) - Identifiant unique (ex: `kite`, `board`, `foil`, `harness`, `wing`, `other`)
  - `name_fr`: string (required) - Nom en français
  - `name_en`: string (required) - Nom en anglais
  - `icon`: string (required) - Nom de l'icône Material Design
  - `color_hex`: int (required) - Couleur en format ARGB (ex: 4280391411)
  - `display_order`: int (required) - Ordre d'affichage
  - `is_active`: boolean (default: true) - Catégorie active
  - `created_at`: timestamp (required)
  - `updated_at`: timestamp (required)

**Exemple**:
```json
{
  "id": "kite",
  "name_fr": "Kites",
  "name_en": "Kites",
  "icon": "air",
  "color_hex": 4280391411,
  "display_order": 1,
  "is_active": true,
  "created_at": "2026-03-05T23:12:01.058Z",
  "updated_at": "2026-03-05T23:12:01.058Z"
}
```

**Catégories existantes**:
| ID | Nom FR | Nom EN | Icon | Ordre |
|----|--------|--------|------|-------|
| `kite` | Kites | Kites | `air` | 1 |
| `board` | Planches | Boards | `surfing` | 2 |
| `foil` | Foils | Foils | `waves` | 3 |
| `harness` | Harnais | Harnesses | `shield_outlined` | 4 |
| `wing` | Wings | Wings | `flight` | 5 |
| `other` | Autres | Other | `sports` | 6 |

---

### COLLECTION: equipment_items
- **Description**: Équipements individuels (matériel louable).
- **Chemin**: `/equipment_items/{itemId}`
- **Documents**: 2
- **Champs**:
  - `id`: string (required) - Identifiant unique (ex: `equip_1772754449625_shrugs`)
  - `name`: string (required) - Nom de l'équipement
  - `category`: string (required) - FK → equipment_categories.id (ex: `kite`, `board`)
  - `brand`: string (required) - Marque
  - `model`: string (required) - Modèle
  - `size`: double (required) - Taille (m² pour les kites, cm pour les planches)
  - `color`: string? (nullable) - Couleur
  - `serial_number`: string? (nullable) - Numéro de série
  - `purchase_date`: timestamp? (nullable) - Date d'achat
  - `purchase_price`: int (required) - Prix d'achat en euros
  - `rental_price_morning`: int (required) - Prix location matin
  - `rental_price_afternoon`: int (required) - Prix location après-midi
  - `rental_price_full_day`: int (required) - Prix location journée
  - `is_active`: boolean (default: true) - Équipement actif
  - `current_status`: string (required) - ['available', 'rented', 'maintenance']
  - `condition`: string (required) - ['new', 'good', 'fair', 'poor']
  - `total_rentals`: int (default: 0) - Nombre total de locations
  - `last_maintenance_date`: timestamp? (nullable) - Dernière maintenance
  - `next_maintenance_date`: timestamp? (nullable) - Prochaine maintenance
  - `notes`: string? (nullable) - Notes internes
  - `created_at`: timestamp (required)
  - `updated_at`: timestamp (required)

**Exemple**:
```json
{
  "id": "equip_1772754449625_shrugs",
  "name": "shrugs",
  "category": "kite",
  "brand": "ah",
  "model": "add",
  "size": 12,
  "color": "qsdf",
  "serial_number": "qf",
  "purchase_price": 12,
  "rental_price_morning": 3,
  "rental_price_afternoon": 3,
  "rental_price_full_day": 3,
  "is_active": true,
  "current_status": "rented",
  "condition": "good",
  "total_rentals": 0,
  "purchase_date": null,
  "last_maintenance_date": null,
  "next_maintenance_date": null,
  "notes": null,
  "created_at": "2026-03-05T19:47:29.625599Z",
  "updated_at": "2026-03-06T00:28:52.904Z"
}
```

---

### COLLECTION: equipment_rentals
- **Description**: Locations d'équipements par les élèves.
- **Chemin**: `/equipment_rentals/{rentalId}`
- **Documents**: 2
- **Champs**:
  
  **Identification**:
  - `id`: string (required) - Identifiant unique
  - `assignment_type`: string (required) - ['student_rental', 'admin_assignment', 'instructor_assignment']
  - `status`: string (required) - ['pending', 'confirmed', 'active', 'completed', 'cancelled']
  
  **Élève**:
  - `student_id`: string (required) - FK → users.uid
  - `student_name`: string (required) - Nom de l'élève
  - `student_email`: string (required) - Email de l'élève
  
  **Équipement (dénormalisé)**:
  - `equipment_id`: string (required) - FK → equipment_items.id
  - `equipment_name`: string (required) - Nom de l'équipement
  - `equipment_category`: string (required) - Catégorie
  - `equipment_brand`: string (required) - Marque
  - `equipment_model`: string (required) - Modèle
  - `equipment_size`: double (required) - Taille
  
  **Période**:
  - `date_string`: string (required) - Date en format YYYY-MM-DD (pour égalité)
  - `date_timestamp`: timestamp (required) - Date en UTC (pour indexation)
  - `slot`: string (required) - ['morning', 'afternoon', 'full_day']
  
  **Prix**:
  - `total_price`: int? (nullable) - Prix total en euros (null pour admin/instructor assignments)
  - `payment_status`: string? (nullable) - ['unpaid', 'paid', 'refunded']
  
  **Contexte**:
  - `reservation_id`: string? (nullable) - FK → reservations.id (optionnel)
  - `booked_by`: string (required) - UID de la personne qui a réservé
  - `booked_at`: timestamp (required) - Date de réservation
  
  **Assignment Admin**:
  - `admin_assigned_at`: timestamp? (nullable)
  - `admin_assigned_by`: string? (nullable) - UID admin
  - `admin_assignment_notes`: string? (nullable)
  
  **Assignment Moniteur**:
  - `instructor_assigned_at`: timestamp? (nullable)
  - `instructor_assigned_by`: string? (nullable) - UID moniteur
  
  **Check-out / Check-in**:
  - `checked_out_at`: timestamp? (nullable)
  - `checked_out_by`: string? (nullable) - UID de la personne qui a fait le check-out
  - `checked_in_at`: timestamp? (nullable)
  - `checked_in_by`: string? (nullable) - UID de la personne qui a fait le check-in
  - `condition_at_checkout`: string? (nullable) - État au départ
  - `condition_at_checkin`: string? (nullable) - État au retour
  - `damage_notes`: string? (nullable) - Notes de dommages
  
  **Métadonnées**:
  - `created_at`: timestamp (required)
  - `updated_at`: timestamp (required)

**Exemple**:
```json
{
  "id": "0a4pfMTyAdb9EKl8JoLd",
  "assignment_type": "student_rental",
  "status": "pending",
  "student_id": "VwvI02M408dloJQAYHwkODjfHBy2",
  "student_name": "Utilisateur",
  "student_email": "mat@mail.com",
  "equipment_id": "equip_1772754449625_shrugs",
  "equipment_name": "shrugs",
  "equipment_category": "kite",
  "equipment_brand": "ah",
  "equipment_model": "add",
  "equipment_size": 12,
  "date_string": "2026-03-07",
  "date_timestamp": "2026-03-07T00:00:00.000Z",
  "slot": "morning",
  "total_price": 3,
  "payment_status": "unpaid",
  "reservation_id": null,
  "booked_by": "VwvI02M408dloJQAYHwkODjfHBy2",
  "booked_at": "2026-03-05T20:28:46.053879Z",
  "admin_assigned_at": null,
  "admin_assigned_by": null,
  "admin_assignment_notes": null,
  "instructor_assigned_at": null,
  "instructor_assigned_by": null,
  "checked_out_at": null,
  "checked_out_by": null,
  "checked_in_at": null,
  "checked_in_by": null,
  "condition_at_checkout": null,
  "condition_at_checkin": null,
  "damage_notes": null,
  "created_at": "2026-03-05T20:28:46.053879Z",
  "updated_at": "2026-03-05T20:28:46.053879Z"
}
```

---

## COLLECTIONS OBSOLÈTES / VIDES

> [!NOTE]
> Ces collections sont définies dans le code mais sont vides ou absentes en base de données.

| Collection | Statut | Raison |
|------------|--------|--------|
| `sessions` | ❌ Vide | Remplacée par `reservations` |
| `availabilities` | ❌ Vide | Gestion des indisponibilités staff (non implémentée) |
| `transactions` | ❌ Vide | Historique financier (non implémenté) |
| `products` | ❌ Vide | Ancienne version des `credit_packs` |

---

## RELATIONS ENTRE COLLECTIONS

```
users (uid) ─┬─> reservations (pupil_id)
             ├─> equipment_rentals (student_id)
             ├─> notifications (user_id)
             └─> admins (uid)

staff (id) ──> reservations (staff_id)

equipment_categories (id) ─> equipment_items (category)

equipment_items (id) ─> equipment_rentals (equipment_id)

reservations (id) ─> equipment_rentals (reservation_id) [optionnel]
```

---

## INDEX CONFIGURÉS

Voir `firestore.indexes.json` pour la liste complète des index composites.

---

## RÈGLES DE SÉCURITÉ

Voir `firestore.rules` pour les règles de sécurité actuelles.

> ⚠️ **ATTENTION** : Règles actuelles sont en mode développement (expiration 2026-03-27)

---

## HISTORIQUE DES VERSIONS

| Version | Date | Changements |
|---------|------|-------------|
| 2.2 | 2026-03-05 | Ajout collections equipment (categories, items, rentals) |
| 2.1 | 2026-03-05 | Ajout champ `equipment_assignment_required` dans reservations |
| 2.0 | 2026-02-25 | Schema initial après refactoring |

---

**Dernière mise à jour :** 5 mars 2026  
**Auditeur :** MCP Firebase Server  
**Projet :** reservation-kite  
**Statut :** 🟢 Développement (Non-production)
