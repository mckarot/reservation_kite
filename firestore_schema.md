# SCHÉMA FIRESTORE — RESERVATION KITE (v2)

## COLLECTION: settings
- **Description**: Configuration globale de l'école.
- **Chemin**: `/settings/school_config`
- **Champs**:
    - `opening_hours`: map `{ morning: { start: string, end: string }, afternoon: { start: string, end: string } }`
    - `days_off`: list<string> (ex: ["Tuesday morning"])
    - `max_students_per_instructor`: int (default: 4)
    - `weather_latitude`: number? (Latitude du spot de kite, ex: 45.123456)
    - `weather_longitude`: number? (Longitude du spot de kite, ex: -1.654321)
    - `weather_location_name`: string? (Nom du spot pour affichage, ex: "Plage Principale")
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

## COLLECTION: equipment_categories
- **Description**: Catégories d'équipement personnalisables par l'admin.
- **Chemin**: `/equipment_categories/{categoryId}`
- **Champs**:
    - `name`: string (required, unique, dans la langue de l'admin)
    - `order`: int (pour le tri, commence à 1)
    - `isActive`: boolean (default: true)
    - `equipmentIds`: list<string> (liste des IDs d'équipements liés)
    - `created_at`: serverTimestamp

## COLLECTION: equipment
- **Description**: Matériel de l'école (ailes, planches) utilisé pour les cours. **Chaque équipement est une entité physique unique**.
- **Chemin**: `/equipment/{equipmentId}`
- **Champs**:
    - `category_id`: string (FK -> equipment_categories/{id})
    - `brand`: string
    - `model`: string
    - `size`: string (ex: "12", "9", "10.5")
    - `serial_number`: string? (Numéro de série unique pour identification physique, ex: "FO-2024-001")
    - `status`: string ['available', 'maintenance', 'damaged', 'reserved']
    - `notes`: string
    - `purchase_date`: timestamp? (Date d'achat pour suivi usure)
    - `last_maintenance_date`: timestamp? (Dernière maintenance)
    - `maintenance_history`: list<map> [{ date: timestamp, type: string, notes: string, cost: number }]
    - `total_bookings`: int (Nombre total de réservations pour statistiques)
    - `updated_at`: serverTimestamp

## COLLECTION: equipment_bookings
- **Description**: Réservations de matériel effectuées par les élèves. **Une réservation = un équipement physique unique**.
- **Chemin**: `/equipment_bookings/{bookingId}`
- **Champs**:
    - `user_id`: string (FK -> users.uid)
    - `user_name`: string
    - `user_email`: string
    - `equipment_id`: string (FK -> equipment.id) - **L'équipement physique spécifique réservé**
    - `equipment_type`: string (ex: 'kite', 'foil') - **Copie pour requêtes rapides**
    - `equipment_brand`: string - **Copie pour affichage**
    - `equipment_model`: string - **Copie pour affichage**
    - `equipment_size`: string - **Copie pour affichage**
    - `date_string`: string (format 'yyyy-MM-dd')
    - `date_timestamp`: timestamp
    - `slot`: string ['morning', 'afternoon', 'full_day']
    - `status`: string ['confirmed', 'cancelled', 'completed']
    - `created_at`: serverTimestamp
    - `updated_at`: serverTimestamp
    - `created_by`: string
    - `session_id`: string?
    - `notes`: string?

## COLLECTION: equipment_assignments
- **Description**: Assignations d'équipements spécifiques aux élèves pour les séances de cours (par admin/moniteur).
- **Chemin**: `/equipment_assignments/{assignmentId}`
- **Champs**:
    - `session_id`: string (FK -> sessions/{sessionId})
    - `student_id`: string (FK -> users.uid)
    - `student_name`: string (Nom de l'élève, dénormalisé)
    - `student_email`: string (Email de l'élève, dénormalisé)
    - `equipment_id`: string (FK -> equipment/{equipmentId})
    - `equipment_type`: string (Type d'équipement, ex: 'kite', 'foil')
    - `equipment_brand`: string (Marque)
    - `equipment_model`: string (Modèle)
    - `equipment_size`: string (Taille)
    - `date_string`: string (Format 'yyyy-MM-dd')
    - `date_timestamp`: timestamp (Pour requêtes de plage)
    - `slot`: string ('morning', 'afternoon')
    - `status`: string ['pending', 'confirmed', 'cancelled', 'completed']
    - `created_at`: serverTimestamp
    - `updated_at`: serverTimestamp
    - `created_by`: string (UID de la personne qui a fait l'assignment - admin/moniteur)
    - `notes`: string? (Notes optionnelles)

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
