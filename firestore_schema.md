# SOURCE DE VÉRITÉ : SCHÉMA FIRESTORE

> [!IMPORTANT]
> Ce document est synchronisé avec le projet Firebase `reservation-kite`.
> Les collections marquées comme "ACTIVE" sont présentes en base de données.
> Les collections marquées comme "MAPPED" existent dans le code mais sont vides/absentes en base.

---

## COLLECTIONS ACTIVES (Production)

### COLLECTION: admins
- **Description**: Utilisateurs disposant de droits d'administration globaux.
- **Chemin**: `/admins/{uid}`
- **Champs**:
    - `uid`: string (required)
    - `email`: string (required)
    - `createdAt`: timestamp (required)
    - `createdBy`: string (uid de l'admin créateur)

### COLLECTION: users
- **Description**: Profils utilisateurs synchronisés avec Firebase Auth.
- **Chemin**: `/users/{uid}`
- **Champs**:
    - `display_name`: string (required)
    - `email`: string (required, unique)
    - `photo_url`: string? (optional)
    - `wallet_balance`: int (en unités/crédits)
    - `role`: string ['admin', 'user', 'editor'] (default: 'user')
    - `progress`: map
        - `level`: string
        - `checklist`: array<string>
    - `created_at`: serverTimestamp (immutable)
    - `last_seen`: serverTimestamp

### COLLECTION: reservations
- **Description**: Réservations de cours (planning).
- **Chemin**: `/reservations/{reservationId}`
- **Champs**:
    - `id`: string (Identifiant unique)
    - `pupil_id`: string (FK -> users.uid)
    - `client_name`: string (Nom affiché)
    - `date`: string (ISO 8601 format: YYYY-MM-DDTHH:mm:ss.sss)
    - `slot`: string ['morning', 'afternoon']
    - `staff_id`: string? (FK -> staff.id, null si non assigné)
    - `status`: string ['pending', 'confirmed', 'cancelled']
    - `notes`: string
    - `created_at`: string (ISO 8601 format)

### COLLECTION: staff
- **Description**: Effectif des moniteurs.
- **Chemin**: `/staff/{staffId}`
- **Champs**:
    - `id`: string (Identifiant unique)
    - `name`: string (Nom du moniteur)
    - `bio`: string
    - `photo_url`: string
    - `is_active`: boolean
    - `specialties`: array<string>
    - `certificates`: array<string>
    - `updated_at`: timestamp

### COLLECTION: credit_packs
- **Description**: Forfaits de crédits disponibles à l'achat.
- **Chemin**: `/credit_packs/{packId}`
- **Champs**:
    - `name`: string
    - `credits`: int
    - `price`: double
    - `is_active`: boolean

### COLLECTION: settings
- **Description**: Configurations globales de l'école et de l'application.
- **Chemin**: `/settings/{docId}`
- **Documents**:
    - `school_config`:
        - `openingTime`: string (ex: "08:00")
        - `closingTime`: string (ex: "18:00")
        - `closedDays`: array<int> (0=dimanche)
        - `maxStudentsPerInstructor`: int
        - `weather_latitude`: double
        - `weather_longitude`: double
    - `theme_config`:
        - `primaryColor`: int (ARGB)
        - `accentColor`: int (ARGB)
        - `secondaryColor`: int (ARGB)
        - `version`: int
        - `updatedAt`: timestamp
        - `updatedBy`: string

### COLLECTION: notifications
- **Description**: Notifications système pour les utilisateurs.
- **Chemin**: `/notifications/{notificationId}`
- **Champs**:
    - `id`: string
    - `user_id`: string (FK -> users.uid)
    - `title`: string
    - `message`: string
    - `type`: string ['success', 'error', 'info', 'warning']
    - `is_read`: boolean
    - `timestamp`: string (ISO 8601 format)

---

## COLLECTIONS MAPPÉES (Vides ou obsolètes en DB)

> [!NOTE]
> Les collections suivantes sont définies dans les repositories du code (`lib/data/repositories`) mais ne contiennent aucune donnée ou sont absentes de la racine Firestore.

- `sessions`: Ancienne gestion des créneaux (remplacée par `reservations`).
- `availabilities`: Gestion des indisponibilités staff.
- `transactions`: Historique financier (wallet).
- `products`: Ancienne version des `credit_packs`.

---

## COLLECTIONS SUPPRIMÉES (Projets passés)

- `equipment`: Supprimé lors du refactoring du système de réservation (Unification).
- `equipment_assignments`: Supprimé.
- `equipment_bookings`: Supprimé.
