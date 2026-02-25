# SCHÉMA FIRESTORE — RESERVATION KITE (v2)

## COLLECTION: settings
- **Description**: Configuration globale de l'école.
- **Chemin**: `/settings/school_config`
- **Champs**:
    - `opening_hours`: map `{ morning: { start: string, end: string }, afternoon: { start: string, end: string } }`
    - `days_off`: list<string> (ex: ["Tuesday morning"])
    - `max_students_per_instructor`: int (default: 4)
    - `updated_at`: serverTimestamp

    - `updated_at`: serverTimestamp

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
    - `progress`: map { 
        `iko_level`: string,
        `checklist`: list<string> (ID des compétences validées),
        `notes`: list<map> [{ date: timestamp, content: string, instructor_id: string }]
      }
    - `created_at`: serverTimestamp (immutable)
    - `last_seen`: serverTimestamp

## COLLECTION: staff
- **Description**: Fiches de présentation des moniteurs.
- **Chemin**: `/staff/{uid}` (uid = users.uid)
- **Champs**:
    - `bio`: string
    - `photo_url`: string
    - `specialties`: list<string> (ex: ["Strapless", "Freestyle", "Foil"])
    - `certificates`: list<string> (Diplômes)
    - `is_active`: boolean
    - `updated_at`: serverTimestamp

## COLLECTION: availabilities
- **Description**: Slots de travail et indisponibilités du staff.
- **Chemin**: `/availabilities/{availabilityId}`
- **Champs**:
    - `instructor_id`: string (FK -> users.uid)
    - `date`: timestamp (required)
    - `slot`: string ['morning', 'afternoon']
    - `status`: string ['available', 'unavailable', 'booked']
    - `updated_at`: serverTimestamp

## COLLECTION: sessions
- **Description**: Cours de Kite Surf (slots de temps réels).
- **Chemin**: `/sessions/{sessionId}`
- **Champs**:
    - `date`: timestamp (required)
    - `slot`: string ['morning', 'afternoon']
    - `instructor_id`: string (FK -> users.uid)
    - `students`: list<string> (list of users.uid)
    - `max_capacity`: int (Nb moniteurs * Quota, calculé ou copié de settings)
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

## COLLECTION: equipment
- **Description**: Matériel de l'école (ailes, planches) utilisé pour les cours.
- **Chemin**: `/equipment/{equipmentId}`
- **Champs**:
    - `type`: string ['kite', 'board', 'harness', 'other']
    - `brand`: string
    - `model`: string
    - `size`: string
    - `status`: string ['available', 'maintenance', 'damaged']
    - `notes`: string
    - `updated_at`: serverTimestamp

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
