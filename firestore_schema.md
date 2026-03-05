# SCHÉMA FIRESTORE — RESERVATION KITE (v2)

## COLLECTION: settings
- **Description**: Configuration globale de l'école et du thème.
- **Chemin**: `/settings/{configDoc}`

### DOCUMENT: `school_config`
- **Champs**:
    - `opening_hours`: map `{ morning: { start: string, end: string }, afternoon: { start: string, end: string } }`
    - `days_off`: list<string> (ex: ["Tuesday morning"])
    - `max_students_per_instructor`: int (default: 4)
    - `weather_latitude`: number? (Latitude du spot de kite, ex: 45.123456)
    - `weather_longitude`: number? (Longitude du spot de kite, ex: -1.654321)
    - `weather_location_name`: string? (Nom du spot pour affichage, ex: "Plage Principale")
    - `updated_at`: serverTimestamp

### DOCUMENT: `theme_config`
- **Description**: Configuration du thème dynamique (couleurs de la marque).
- **Champs**:
    - `primaryColor`: int (Hex color code, ex: 0xFF1976D2)
    - `secondaryColor`: int
    - `accentColor`: int
    - `version`: int (Incrémenté à chaque changement pour la gestion du cache)
    - `updatedBy`: string (UID de l'admin)
    - `updatedAt`: serverTimestamp

## COLLECTION: credit_packs
- **Description**: Catalogue des packs de crédits disponibles à la vente.
- **Chemin**: `/credit_packs/{packId}`
- **Champs**:
    - `name`: string
    - `credits`: int
    - `price`: double
    - `is_active`: boolean (default: true)

## COLLECTION: users
- **Description**: Profils utilisateurs et élèves.
- **Chemin**: `/users/{uid}`
- **Champs**:
    - `display_name`: string (required)
    - `email`: string (required, unique)
    - `photo_url`: string?
    - `role`: string ['admin', 'instructor', 'student'] (default: 'student')
    - `weight`: int? (in kg, useful for gear selection)
    - `wallet_balance`: int (en centimes)
    - `total_credits_purchased`: int (Cumul historique des crédits achetés)
    - `progress`: map { 
        `iko_level`: string?,
        `checklist`: list<string> (ID des compétences validées),
        `notes`: list<map> [{ date: timestamp, content: string, instructor_id: string }]
      }
    - `created_at`: serverTimestamp (immutable)
    - `last_seen`: serverTimestamp

## COLLECTION: staff
- **Description**: Fiches de présentation des moniteurs.
- **Chemin**: `/staff/{uid}` (uid = users.uid)
- **Champs**:
    - `id`: string (UID)
    - `name`: string
    - `bio`: string
    - `photo_url`: string
    - `specialties`: list<string> (ex: ["Strapless", "Freestyle", "Foil"])
    - `certificates`: list<string> (Diplômes)
    - `isActive`: boolean
    - `updated_at`: serverTimestamp

## COLLECTION: availabilities
- **Description**: Slots de travail et indisponibilités du staff.
- **Chemin**: `/availabilities/{availabilityId}`
- **Champs**:
    - `instructor_id`: string (FK -> users.uid)
    - `date`: timestamp (required)
    - `slot`: string ['morning', 'afternoon', 'fullDay']
    - `status`: string ['pending', 'approved', 'rejected'] (Pour les demandes d'indisponibilité)
    - `reason`: string? (Motif de l'indisponibilité)
    - `created_at`: serverTimestamp
    - `updated_at`: serverTimestamp

## COLLECTION: sessions
- **Description**: Cours de Kite Surf (slots de temps réels).
- **Chemin**: `/sessions/{sessionId}`
- **Champs**:
    - `date`: timestamp (required)
    - `slot`: string ['morning', 'afternoon']
    - `instructor_id`: string (FK -> users.uid)
    - `studentIds`: list<string> (list of users.uid)
    - `max_capacity`: int (Nb moniteurs * Quota)
    - `status`: string ['scheduled', 'cancelled', 'completed']
    - `created_at`: serverTimestamp

## COLLECTION: products
- **Description**: Inventaire boutique (neuf et occasion).
- **Chemin**: `/products/{productId}`
- **Champs**:
    - `name`: string (required)
    - `description`: string
    - `price`: int (en centimes)
    - `category`: string ['wing', 'kite', 'board', 'harness', 'accessories']
    - `condition`: string ['new', 'used']
    - `stock_quantity`: int
    - `images`: list<string>
    - `created_at`: serverTimestamp

## COLLECTION: equipment_categories
- **Description**: Catégories d'équipement personnalisables par l'admin.
- **Chemin**: `/equipment_categories/{categoryId}`
- **Champs**:
    - `name`: string (required, unique)
    - `order`: int (pour le tri)
    - `isActive`: boolean (default: true)
    - `equipmentIds`: list<string>
    - `created_at`: serverTimestamp

## COLLECTION: equipment
- **Description**: Matériel de l'école (ailes, planches).
- **Chemin**: `/equipment/{equipmentId}`
- **Champs**:
    - `category_id`: string (FK -> equipment_categories/{id})
    - `brand`: string
    - `model`: string
    - `size`: string (ex: "12", "9")
    - `serial_number`: string?
    - `status`: string ['available', 'maintenance', 'damaged', 'reserved']
    - `total_quantity`: int (Défaut: 1, permet de gérer du stock identique)
    - `notes`: string
    - `purchase_date`: timestamp?
    - `last_maintenance_date`: timestamp?
    - `maintenance_history`: list<map> [{ date: timestamp, type: string, notes: string, cost: number }]
    - `total_bookings`: int
    - `migrated_from`: string? (Information de provenance si migration)
    - `migration_date`: timestamp?
    - `updated_at`: serverTimestamp

## COLLECTION: equipment_bookings
- **Description**: Réservations de matériel (unifié : élève, staff et assignations).
- **Chemin**: `/equipment_bookings/{bookingId}`
- **Champs**:
    - `user_id`: string (FK -> users.uid)
    - `user_name`: string
    - `user_email`: string
    - `equipment_id`: string (FK -> equipment.id)
    - `equipment_type`: string
    - `equipment_brand`: string
    - `equipment_model`: string
    - `equipment_size`: string
    - `date_string`: string (format 'yyyy-MM-dd')
    - `date_timestamp`: timestamp
    - `slot`: string ['morning', 'afternoon', 'full_day']
    - `type`: string ['student', 'assignment', 'staff'] (Identifie l'origine de la réservation)
    - `status`: string ['confirmed', 'cancelled', 'completed']
    - `assigned_by`: string? (UID de l'admin/moniteur si type='assignment')
    - `session_id`: string?
    - `notes`: string?
    - `created_at`: serverTimestamp
    - `updated_at`: serverTimestamp
    - `created_by`: string

## COLLECTION: transactions
- **Description**: Historique des paiements manuels et achats.
- **Chemin**: `/transactions/{transactionId}`
- **Champs**:
    - `user_id`: string (FK -> users.uid)
    - `amount`: int (en centimes)
    - `type`: string ['credit_purchase', 'lesson_payment', 'boutique_purchase']
    - `payment_method`: string ['cash', 'card', 'transfer']
    - `metadata`: map
    - `created_at`: serverTimestamp
