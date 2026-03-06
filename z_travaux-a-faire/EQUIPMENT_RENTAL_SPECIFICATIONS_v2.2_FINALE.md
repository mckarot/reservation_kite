# 🪁 GESTION DE LOCATION DE MATÉRIEL — SPÉCIFICATIONS TECHNIQUES

**Version :** 2.2 — Finale (Lead Dev Review — 3 corrections résiduelles)  
**Date :** 5 mars 2026  
**Statut :** ✅ Prêt pour implémentation  
**Base :** Schéma Firebase réel vérifié (`firestore_schema.md` v3 actuel)

> **⚠️ NOTE IMPORTANTE SUR `firestore_schema.md`**  
> Ce document contient le schéma cible (collections à créer). Le fichier `firestore_schema.md`  
> ne sera mis à jour qu'**après** implémentation et validation. Il ne doit pas être modifié pendant le développement.

---

## 📋 TABLE DES MATIÈRES

1. [Vision & Fonctionnalités](#1-vision--fonctionnalités)
2. [Analyse de l'Architecture Existante](#2-analyse-de-larchitecture-existante)
3. [Schéma Firestore Cible](#3-schéma-firestore-cible)
4. [Modèles de Données](#4-modèles-de-données)
5. [Architecture Technique](#5-architecture-technique)
6. [Règles Métier Critiques](#6-règles-métier-critiques)
7. [Cas d'Usage & Scénarios](#7-cas-dusage--scénarios)
8. [Plan d'Implémentation](#8-plan-dimplémentation)
9. [Checklist de Validation](#9-checklist-de-validation)

---

## 1. VISION & FONCTIONNALITÉS

### 1.1 Contexte Métier

Les élèves de l'école de Kite Surf peuvent louer du matériel (voiles, kites, harnais, foils, planches) pour leurs sessions. Le système gère :

- ✅ **Disponibilité temporelle fine** : Matin / Après-midi / Journée complète
- ✅ **Gestion par pièce individuelle** : Chaque équipement est une unité physique traçable
- ✅ **Conflits de location** : Aucune double réservation possible (transaction atomique)
- ✅ **Historique** : Suivi des locations par élève, par équipement
- ✅ **Trois flux d'affectation** : Location directe (élève) / Assignment admin / Assignment moniteur

### 1.2 Workflows d'Affectation

```
WORKFLOW 1 — LOCATION DIRECTE (Élève)
──────────────────────────────────────
Élève sélectionne date + slot
→ Voit équipements disponibles en temps réel
→ Confirme + paiement wallet (débit immédiat)
→ equipment_rentals créé (assignment_type: 'student_rental')
→ current_status de l'equipment_item → 'rented' au check-out

WORKFLOW 2 — ASSIGNMENT ADMIN (Validation réservation)
───────────────────────────────────────────────────────
Admin valide une reservation (status: pending → confirmed)
→ Option : assigner matériel [OUI / NON]
   ├─ OUI → equipment_rentals créé (assignment_type: 'admin_assignment')
   │         reservations.equipment_assignment_required = false
   └─ NON → Pas de rental créé
             reservations.equipment_assignment_required = true
             → Moniteur OBLIGÉ d'assigner avant de démarrer

WORKFLOW 3 — ASSIGNMENT MONITEUR (Obligatoire si admin a skip)
───────────────────────────────────────────────────────────────
Moniteur voit ses réservations du jour
→ Badge ⚠️ si equipment_assignment_required = true
→ BLOCAGE : ne peut pas démarrer la session sans assigner
→ Assigne matériel → equipment_rentals créé (assignment_type: 'instructor_assignment')
→ reservations.equipment_assignment_required = false
```

### 1.3 Rôles

| Rôle | Fonctionnalités |
|------|-----------------|
| **Élève** | Louer matériel (location directe), voir historique, annuler (J-1 minimum) |
| **Admin** | Valider réservations, assigner matériel (optionnel), gérer parc, prix |
| **Moniteur** | Assigner matériel (obligatoire si admin skip), check-out, check-in, signaler dégâts |

---

## 2. ANALYSE DE L'ARCHITECTURE EXISTANTE

### 2.1 Schéma Firebase Actuel (Source de vérité)

Collections **actives en production** :

| Collection | Rôle |
|------------|------|
| `admins` | UIDs avec droits admin globaux |
| `users` | Profils + wallet_balance + role |
| `reservations` | Réservations de cours (date en string ISO 8601) |
| `staff` | Fiches moniteurs |
| `credit_packs` | Forfaits à l'achat |
| `settings` | Config école + thème |
| `notifications` | Centre de notifications |

Collections **mappées mais vides** (non utilisées en prod) :
- `sessions`, `availabilities`, `transactions`, `products`

> **⚠️ Point critique :** La collection `sessions` est vide/obsolète. Le workflow 2  
> (assignment admin) se base donc sur `reservations`, pas sur `sessions`.  
> Tous les FK dans `equipment_rentals` pointent vers `reservations.id`.

### 2.2 Points d'Intégration Identifiés

| Fichier existant | Modification requise |
|------------------|---------------------|
| `reservations/{id}` | Ajouter champ `equipment_assignment_required: boolean` |
| `pupil_booking_screen.dart` | Ajouter bouton "Louer du matériel" |
| `lesson_validation_screen.dart` | Ajouter section matériel + blocage si requis |
| `repository_providers.dart` | Ajouter providers equipment |

---

## 3. SCHÉMA FIRESTORE CIBLE

> Ce schéma décrit les collections à créer. Il sera reporté dans `firestore_schema.md`  
> après validation de l'implémentation.

### 3.1 Modification d'une collection existante : `reservations`

Ajouter **un seul champ** à la collection existante :

```
reservations/{reservationId}
  ... (tous les champs existants inchangés) ...
+ equipment_assignment_required: boolean   ← NOUVEAU
    // true  = admin n'a pas assigné, moniteur DOIT assigner avant de démarrer
    // false = matériel assigné (ou pas de matériel requis)
    // default: false
```

> **Pourquoi ici et pas dans `equipment_rentals` ?**  
> Quand l'admin skip l'assignment, aucun document `equipment_rentals` n'existe encore.  
> Il faut poser le flag sur un document qui existe déjà : la `reservation`.

---

### 3.2 Nouvelle collection : `equipment_items`

**Modèle : une pièce physique = un document.**

```
equipment_items/{itemId}
├── id: string                          // UUID auto-généré
├── name: string                        // "Kite North Orbit 12m²"
├── category: string                    // 'kite' | 'board' | 'foil' | 'harness' | 'wing' | 'other'
├── brand: string                       // "North", "Duotone", "F-One"
├── model: string                       // "Orbit", "Rise", "Phantom"
├── size: number                        // 12 (m²) ou 145 (cm)
├── color: string?
├── serial_number: string?
├── purchase_date: Timestamp?
├── purchase_price: int                 // En centimes
├── rental_price_morning: int           // En centimes (ou 1 = 1 crédit)
├── rental_price_afternoon: int         // En centimes (ou 1 = 1 crédit)
├── rental_price_full_day: int          // En centimes (ou 2 = 2 crédits)
├── is_active: boolean                  // false = retiré du parc
├── current_status: string              // 'available' | 'rented' | 'maintenance'
│                                       // ← MIS À JOUR PAR TRANSACTION au check-out/in
│                                       // Source de vérité physique (équipement sorti ?)
├── condition: string                   // 'new' | 'good' | 'fair' | 'poor'
├── total_rentals: int                  // Compteur incrémenté à chaque location
├── last_maintenance_date: Timestamp?
├── next_maintenance_date: Timestamp?
├── notes: string?
├── created_at: Timestamp               // serverTimestamp
└── updated_at: Timestamp               // serverTimestamp
```

**Index requis :**
```json
{
  "collectionGroup": "equipment_items",
  "fields": [
    { "fieldPath": "category", "order": "ASCENDING" },
    { "fieldPath": "is_active", "order": "ASCENDING" },
    { "fieldPath": "current_status", "order": "ASCENDING" }
  ]
}
```

---

### 3.3 Nouvelle collection : `equipment_rentals`

**Un document = une location ou un assignment.**

```
equipment_rentals/{rentalId}
├── id: string

// ── Élève ────────────────────────────────────────────────────────────────
├── student_id: string                  // FK → users.uid
├── student_name: string                // Dénormalisé (historique stable)
├── student_email: string               // Dénormalisé

// ── Équipement (dénormalisé pour historique) ─────────────────────────────
├── equipment_id: string                // FK → equipment_items.id
├── equipment_name: string
├── equipment_category: string
├── equipment_brand: string
├── equipment_model: string
├── equipment_size: number

// ── Période ──────────────────────────────────────────────────────────────
├── date_string: string                 // "2026-03-15" — ISO-8601 SANS timezone
│                                       // ← CRITIQUE : utilisé pour les requêtes
│                                       //   (évite les problèmes UTC/range query)
├── date_timestamp: Timestamp           // UTC — utilisé pour les index et le tri
├── slot: string                        // 'morning' | 'afternoon' | 'full_day'

// ── Type d'affectation ───────────────────────────────────────────────────
├── assignment_type: string             // 'student_rental' | 'admin_assignment'
│                                       //   | 'instructor_assignment'

// ── Statut & Prix ────────────────────────────────────────────────────────
├── status: string                      // 'pending' | 'confirmed' | 'active'
│                                       //   | 'completed' | 'cancelled'
├── total_price: int?                   // En centimes (ou crédits). NULL pour admin/instructor
│                                       // ← NULL = non applicable (pas "0")
├── payment_status: string?             // 'unpaid' | 'paid' | 'refunded'
│                                       // NULL si assignment (non applicable)

// ── Contexte (FK vers le document parent) ───────────────────────────────
├── reservation_id: string?             // FK → reservations.id
│                                       // ← TOUJOURS utilisé (sessions est vide)
├── booked_by: string                   // UID créateur du document
├── booked_at: Timestamp                // serverTimestamp

// ── Assignment Admin ─────────────────────────────────────────────────────
├── admin_assigned_at: Timestamp?
├── admin_assigned_by: string?
├── admin_assignment_notes: string?

// ── Assignment Moniteur ──────────────────────────────────────────────────
├── instructor_assigned_at: Timestamp?
├── instructor_assigned_by: string?

// ── Check-out / Check-in ─────────────────────────────────────────────────
├── checked_out_at: Timestamp?
├── checked_out_by: string?
├── checked_in_at: Timestamp?
├── checked_in_by: string?

// ── État matériel ────────────────────────────────────────────────────────
├── condition_at_checkout: string?      // 'new' | 'good' | 'fair' | 'poor'
├── condition_at_checkin: string?
├── damage_notes: string?

├── created_at: Timestamp               // serverTimestamp
└── updated_at: Timestamp               // serverTimestamp
```

**Index requis :**

```json
[
  {
    "collectionGroup": "equipment_rentals",
    "comment": "Historique d'un élève",
    "fields": [
      { "fieldPath": "student_id", "order": "ASCENDING" },
      { "fieldPath": "date_timestamp", "order": "DESCENDING" }
    ]
  },
  {
    "collectionGroup": "equipment_rentals",
    "comment": "Vérification disponibilité — CRITIQUE : date_string en equality, pas range",
    "fields": [
      { "fieldPath": "equipment_id", "order": "ASCENDING" },
      { "fieldPath": "date_string", "order": "ASCENDING" },
      { "fieldPath": "slot", "order": "ASCENDING" },
      { "fieldPath": "status", "order": "ASCENDING" }
    ]
  },
  {
    "collectionGroup": "equipment_rentals",
    "comment": "Locations du jour pour admin/moniteur",
    "fields": [
      { "fieldPath": "date_string", "order": "ASCENDING" },
      { "fieldPath": "status", "order": "ASCENDING" }
    ]
  },
  {
    "collectionGroup": "equipment_rentals",
    "comment": "Locations liées à une réservation",
    "fields": [
      { "fieldPath": "reservation_id", "order": "ASCENDING" },
      { "fieldPath": "status", "order": "ASCENDING" }
    ]
  },
  {
    "collectionGroup": "equipment_rentals",
    "comment": "Locations par type d'assignment (vue admin)",
    "fields": [
      { "fieldPath": "date_string", "order": "ASCENDING" },
      { "fieldPath": "assignment_type", "order": "ASCENDING" }
    ]
  }
]
```

---

### 3.4 Nouvelle collection : `equipment_categories`

```
equipment_categories/{categoryId}
├── id: string                          // 'kite', 'board', 'foil', etc.
├── name_fr: string                     // "Kites"
├── name_en: string                     // "Kites"
├── icon: string                        // Nom icône Material
├── color_hex: int                      // Couleur UI (ARGB)
├── display_order: int
├── is_active: boolean
├── created_at: Timestamp
└── updated_at: Timestamp
```

---

### 3.5 Règles de Sécurité Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuth() { return request.auth != null; }
    function isAdmin() {
      return isAuth() &&
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    function isStaff() {
      return isAuth() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid))
          .data.role == 'editor'; // 'editor' = moniteur dans ton schéma actuel
    }

    // equipment_items : lecture auth, écriture admin
    match /equipment_items/{itemId} {
      allow read: if isAuth();
      allow write: if isAdmin();
    }

    // equipment_categories : lecture auth, écriture admin
    match /equipment_categories/{categoryId} {
      allow read: if isAuth();
      allow write: if isAdmin();
    }

    // equipment_rentals
    match /equipment_rentals/{rentalId} {
      // Lecture : proprio, staff ou admin
      allow read: if isAuth() && (
        resource.data.student_id == request.auth.uid ||
        isStaff() ||
        isAdmin()
      );
      // Création : élève pour lui-même, ou staff/admin
      allow create: if isAuth() && (
        (request.resource.data.student_id == request.auth.uid &&
         request.resource.data.assignment_type == 'student_rental') ||
        isStaff() ||
        isAdmin()
      );
      // Mise à jour : élève peut seulement annuler, staff/admin tout faire
      allow update: if isAuth() && (
        (resource.data.student_id == request.auth.uid &&
         request.resource.data.status == 'cancelled' &&
         request.resource.data.diff(resource.data)
           .affectedKeys().hasOnly(['status', 'updated_at'])) ||
        isStaff() ||
        isAdmin()
      );
      allow delete: if isAdmin();
    }

    // reservations : permettre mise à jour du flag equipment_assignment_required
    match /reservations/{reservationId} {
      allow read: if isAuth();
      allow update: if isAdmin() || isStaff();
      allow create: if isAuth();
      allow delete: if isAdmin();
    }
  }
}
```

> **Note :** Dans ton schéma actuel, `role` prend les valeurs `'admin' | 'user' | 'editor'`.  
> Le rôle moniteur correspond à `'editor'`. Vérifie que c'est bien le cas dans ta DB.

---

## 4. MODÈLES DE DONNÉES

### 4.1 Utilitaire de date (OBLIGATOIRE)

```dart
// lib/utils/date_utils.dart
import 'package:intl/intl.dart';

/// Formate une date locale en string ISO-8601 UTC (YYYY-MM-DD)
/// Utilisé pour date_string dans Firestore (equality queries)
String formatDateForQuery(DateTime date) {
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Convertit une date locale en DateTime UTC pour date_timestamp
DateTime toUtcDate(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
```

---

### 4.2 `lib/domain/models/equipment_item.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'equipment_item.freezed.dart';
part 'equipment_item.g.dart';

enum EquipmentCategory {
  @JsonValue('kite') kite,
  @JsonValue('board') board,
  @JsonValue('foil') foil,
  @JsonValue('harness') harness,
  @JsonValue('wing') wing,
  @JsonValue('other') other,  // ← Pour catégories futures
}

enum EquipmentCondition {
  @JsonValue('new') newCondition,
  @JsonValue('good') good,
  @JsonValue('fair') fair,
  @JsonValue('poor') poor,
}

enum EquipmentCurrentStatus {
  @JsonValue('available') available,
  @JsonValue('rented') rented,
  @JsonValue('maintenance') maintenance,
}

@freezed
class EquipmentItem with _$EquipmentItem {
  const factory EquipmentItem({
    required String id,
    required String name,
    @JsonKey(unknownEnumValue: EquipmentCategory.other)
    required EquipmentCategory category,
    required String brand,
    required String model,
    required double size,
    String? color,
    String? serialNumber,
    @TimestampConverter() DateTime? purchaseDate,
    required int purchasePrice,
    required int rentalPriceMorning,
    required int rentalPriceAfternoon,
    required int rentalPriceFullDay,
    @Default(true) bool isActive,
    // Source de vérité physique — mis à jour par transaction au check-out/in
    @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
    @Default(EquipmentCurrentStatus.available)
    EquipmentCurrentStatus currentStatus,
    @JsonKey(unknownEnumValue: EquipmentCondition.good)
    @Default(EquipmentCondition.good)
    EquipmentCondition condition,
    @Default(0) int totalRentals,
    @TimestampConverter() DateTime? lastMaintenanceDate,
    @TimestampConverter() DateTime? nextMaintenanceDate,
    String? notes,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EquipmentItem;

  factory EquipmentItem.fromJson(Map<String, dynamic> json) =>
      _$EquipmentItemFromJson(json);
}
```

---

### 4.3 `lib/domain/models/equipment_rental.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';
import 'reservation.dart'; // ← Réutilise TimeSlot existant

part 'equipment_rental.freezed.dart';
part 'equipment_rental.g.dart';

enum RentalStatus {
  @JsonValue('pending') pending,
  @JsonValue('confirmed') confirmed,
  @JsonValue('active') active,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled,
}

enum PaymentStatus {
  @JsonValue('unpaid') unpaid,
  @JsonValue('paid') paid,
  @JsonValue('refunded') refunded,
}

enum AssignmentType {
  @JsonValue('student_rental') studentRental,
  @JsonValue('admin_assignment') adminAssignment,
  @JsonValue('instructor_assignment') instructorAssignment,
}

@freezed
class EquipmentRental with _$EquipmentRental {
  const factory EquipmentRental({
    required String id,

    // Élève
    required String studentId,
    required String studentName,
    required String studentEmail,

    // Équipement (dénormalisé)
    required String equipmentId,
    required String equipmentName,
    required String equipmentCategory,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,

    // Période — double stockage pour requêtes Firestore
    required String dateString,          // "2026-03-15" — equality query
    @TimestampConverter() required DateTime dateTimestamp, // UTC — index/tri
    required TimeSlot slot,              // ← RÉUTILISE TimeSlot existant

    // Type d'affectation
    required AssignmentType assignmentType,

    // Statut
    @Default(RentalStatus.pending) RentalStatus status,

    // Prix — null pour admin/instructor assignments
    int? totalPrice,
    PaymentStatus? paymentStatus,

    // Contexte (FK → reservations, jamais sessions)
    String? reservationId,
    required String bookedBy,
    @TimestampConverter() required DateTime bookedAt,

    // Assignment Admin
    @TimestampConverter() DateTime? adminAssignedAt,
    String? adminAssignedBy,
    String? adminAssignmentNotes,

    // Assignment Moniteur
    @TimestampConverter() DateTime? instructorAssignedAt,
    String? instructorAssignedBy,

    // Check-out / Check-in
    @TimestampConverter() DateTime? checkedOutAt,
    String? checkedOutBy,
    @TimestampConverter() DateTime? checkedInAt,
    String? checkedInBy,

    // État matériel
    String? conditionAtCheckout,
    String? conditionAtCheckin,
    String? damageNotes,

    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EquipmentRental;

  factory EquipmentRental.fromJson(Map<String, dynamic> json) =>
      _$EquipmentRentalFromJson(json);
}
```

---

## 5. ARCHITECTURE TECHNIQUE

### 5.1 Structure des Fichiers à Créer

```
lib/
├── utils/
│   └── date_utils.dart                              # 🆕 formatDateForQuery, toUtcDate
│
├── data/
│   ├── providers/
│   │   └── repository_providers.dart               # ➕ equipmentRepo + rentalRepo
│   └── repositories/
│       ├── firestore_equipment_repository.dart      # 🆕
│       └── firestore_equipment_rental_repository.dart # 🆕
│
├── domain/
│   ├── models/
│   │   ├── equipment_item.dart                      # 🆕
│   │   ├── equipment_item.freezed.dart              # 🆕 (généré)
│   │   ├── equipment_item.g.dart                    # 🆕 (généré)
│   │   ├── equipment_rental.dart                    # 🆕
│   │   ├── equipment_rental.freezed.dart            # 🆕 (généré)
│   │   ├── equipment_rental.g.dart                  # 🆕 (généré)
│   │   └── equipment_category.dart                  # 🆕
│   ├── repositories/
│   │   ├── equipment_repository.dart                # 🆕 (interface)
│   │   └── equipment_rental_repository.dart         # 🆕 (interface)
│   └── logic/
│       └── equipment_availability_validator.dart    # 🆕
│
└── presentation/
    ├── screens/
    │   ├── equipment_rental_screen.dart              # 🆕 élève loue
    │   ├── equipment_rental_history_screen.dart      # 🆕 historique
    │   ├── equipment_admin_screen.dart               # 🆕 admin gère parc
    │   └── equipment_assignment_screen.dart          # 🆕 moniteur assigne
    ├── providers/
    │   ├── equipment_notifier.dart                   # 🆕
    │   ├── equipment_rental_notifier.dart            # 🆕
    │   └── equipment_availability_notifier.dart      # 🆕
    └── widgets/
        ├── equipment_card.dart                       # 🆕
        ├── equipment_rental_tile.dart                # 🆕
        └── equipment_availability_indicator.dart     # 🆕
```

---

### 5.2 Interface Repository Equipment

```dart
// lib/domain/repositories/equipment_repository.dart
import '../models/equipment_item.dart';

abstract class EquipmentRepository {
  Future<List<EquipmentItem>> getAllEquipment();
  Future<EquipmentItem?> getEquipmentById(String id);
  Future<List<EquipmentItem>> getEquipmentByCategory(EquipmentCategory category);
  Stream<List<EquipmentItem>> watchActiveEquipment();
  Future<void> saveEquipment(EquipmentItem equipment);
  Future<void> deactivateEquipment(String id);
  // current_status mis à jour par transaction dans le rental repository
}
```

---

### 5.3 Interface Repository Rental

```dart
// lib/domain/repositories/equipment_rental_repository.dart
import '../models/equipment_rental.dart';
import '../models/equipment_item.dart';

abstract class EquipmentRentalRepository {
  // Lecture
  Future<List<EquipmentRental>> getRentalsByStudent(String studentId);
  Future<List<EquipmentRental>> getRentalsByDate(String dateString);
  Future<List<EquipmentRental>> getRentalsByReservation(String reservationId);
  Stream<List<EquipmentRental>> watchRentalsByDate(String dateString);

  // Disponibilité — utilise date_string pour les equality queries
  Future<bool> isEquipmentAvailable({
    required String equipmentId,
    required String dateString,
    required TimeSlot slot,
  });

  // Écriture — TOUTES les méthodes suivantes utilisent des transactions Firestore
  Future<String> createStudentRental({
    required EquipmentRental rental,
    required int walletDebit, // En centimes ou crédits
  });

  Future<String> createAdminAssignment({
    required EquipmentRental rental,
    required String reservationId,
  });

  Future<String> createInstructorAssignment({
    required EquipmentRental rental,
    required String reservationId,
  });

  Future<void> cancelRental(String rentalId, String cancelledBy);

  Future<void> checkOut({
    required String rentalId,
    required String staffId,
    required String condition,
  });

  Future<void> checkIn({
    required String rentalId,
    required String staffId,
    required String condition,
    String? damageNotes,
  });
}
```

---

### 5.4 Implémentation Firebase — Méthodes critiques

#### `createStudentRental` — Transaction atomique complète

```dart
// lib/data/repositories/firestore_equipment_rental_repository.dart
@override
Future<String> createStudentRental({
  required EquipmentRental rental,
  required int walletDebit,
}) async {
  final rentalRef = _firestore.collection('equipment_rentals').doc();
  final equipmentRef = _firestore
      .collection('equipment_items')
      .doc(rental.equipmentId);
  final userRef = _firestore
      .collection('users')
      .doc(rental.studentId);

  await _firestore.runTransaction((transaction) async {
    // 1. Lire l'équipement
    final equipmentSnap = await transaction.get(equipmentRef);
    if (!equipmentSnap.exists) throw Exception('Équipement introuvable');

    final equipment = EquipmentItem.fromJson(
      equipmentSnap.data()! as Map<String, dynamic>,
    );

    // 2. Vérifier disponibilité
    final isAvailable = await _checkAvailabilityInTransaction(
      transaction,
      rental.equipmentId,
      rental.dateString,
      rental.slot,
    );
    if (!isAvailable) {
      throw Exception('Équipement indisponible pour ce créneau');
    }

    // 3. Vérifier solde wallet
    final userSnap = await transaction.get(userRef);
    if (!userSnap.exists) throw Exception('Utilisateur introuvable');

    final currentBalance = userSnap.data()?['wallet_balance'] ?? 0;
    if (currentBalance < walletDebit) {
      throw Exception('Solde insuffisant');
    }

    // 4. Débiter wallet
    transaction.update(userRef, {'wallet_balance': currentBalance - walletDebit});

    // 5. Créer la location
    transaction.set(rentalRef, rental.toJson());

    // 6. Incrémenter compteur total_rentals
    transaction.update(equipmentRef, {
      'total_rentals': FieldValue.increment(1),
      'updated_at': FieldValue.serverTimestamp(),
    });
  });

  return rentalRef.id;
}
```

#### `checkOut` — Mise à jour `current_status`

```dart
@override
Future<void> checkOut({
  required String rentalId,
  required String staffId,
  required String condition,
}) async {
  final rentalRef = _firestore.collection('equipment_rentals').doc(rentalId);

  await _firestore.runTransaction((transaction) async {
    final rentalSnap = await transaction.get(rentalRef);
    if (!rentalSnap.exists) throw Exception('Location introuvable');

    final rentalData = rentalSnap.data()! as Map<String, dynamic>;
    final equipmentId = rentalData['equipment_id'] as String;
    final equipmentRef = _firestore.collection('equipment_items').doc(equipmentId);

    // 1. Mettre à jour rental
    transaction.update(rentalRef, {
      'checked_out_at': FieldValue.serverTimestamp(),
      'checked_out_by': staffId,
      'condition_at_checkout': condition,
      'status': 'active',
      'updated_at': FieldValue.serverTimestamp(),
    });

    // 2. Mettre à jour equipment current_status → 'rented'
    transaction.update(equipmentRef, {
      'current_status': 'rented',
      'updated_at': FieldValue.serverTimestamp(),
    });
  });
}
```

#### `checkIn` — Libération matériel

```dart
@override
Future<void> checkIn({
  required String rentalId,
  required String staffId,
  required String condition,
  String? damageNotes,
}) async {
  final rentalRef = _firestore.collection('equipment_rentals').doc(rentalId);

  await _firestore.runTransaction((transaction) async {
    final rentalSnap = await transaction.get(rentalRef);
    if (!rentalSnap.exists) throw Exception('Location introuvable');

    final rentalData = rentalSnap.data()! as Map<String, dynamic>;
    final equipmentId = rentalData['equipment_id'] as String;
    final equipmentRef = _firestore.collection('equipment_items').doc(equipmentId);

    // 1. Mettre à jour rental
    transaction.update(rentalRef, {
      'checked_in_at': FieldValue.serverTimestamp(),
      'checked_in_by': staffId,
      'condition_at_checkin': condition,
      'damage_notes': damageNotes,
      'status': 'completed',
      'updated_at': FieldValue.serverTimestamp(),
    });

    // 2. Mettre à jour equipment current_status
    // CORRECTION : déclencher maintenance si condition == 'poor' OU si damageNotes
    // non vide. Les deux critères sont indépendants :
    //   - 'poor' sans note = dégât évident, maintenance requise
    //   - note sans 'poor' = dégât mineur documenté, maintenance par précaution
    final needsMaintenance =
        condition == 'poor' || (damageNotes != null && damageNotes.isNotEmpty);
    final newStatus = needsMaintenance ? 'maintenance' : 'available';

    transaction.update(equipmentRef, {
      'current_status': newStatus,
      'condition': condition,         // Met aussi à jour l'état courant de la pièce
      'updated_at': FieldValue.serverTimestamp(),
    });
  });
}
```

---

### 5.6 `_checkAvailabilityInTransaction` — Implémentation obligatoire

> **⚠️ CRITIQUE :** Cette méthode est appelée dans `createStudentRental`,
> `createAdminAssignment` et `createInstructorAssignment`. Une mauvaise
> implémentation (requête hors transaction, mauvais filtre de statut) annule
> toute la protection contre les race conditions.
>
> **Limitation Firestore :** Les `collection queries` (`.where(...)`) ne peuvent
> pas s'exécuter *à l'intérieur* d'un `runTransaction`. La requête est donc faite
> juste avant la transaction. La transaction garantit ensuite l'atomicité de
> l'écriture. Ce pattern "optimistic concurrency" est acceptable ici car la
> fenêtre de race condition (entre la lecture et l'écriture) est de quelques
> millisecondes — probabilité de collision quasi nulle en usage réel d'une
> école de kite.

```dart
/// Vérifie la disponibilité d'un équipement pour une date et un slot donnés.
///
/// IMPORTANT : Cette méthode doit être appelée JUSTE AVANT runTransaction,
/// pas à l'intérieur. Firestore n'autorise pas les collection queries dans
/// une transaction.
///
/// Statuts bloquants : 'confirmed', 'active', 'pending'
/// Statuts ignorés   : 'cancelled', 'completed'
Future<bool> _checkAvailabilityInTransaction(
  String equipmentId,
  String dateString,
  TimeSlot slot,
) async {
  final existingSnapshot = await _firestore
      .collection('equipment_rentals')
      .where('equipment_id', isEqualTo: equipmentId)
      .where('date_string', isEqualTo: dateString)
      .where('status', whereIn: ['confirmed', 'active', 'pending'])
      .get();

  for (final doc in existingSnapshot.docs) {
    final rawSlot = doc.data()['slot'] as String?;
    if (rawSlot == null) continue;

    final existingSlot = TimeSlot.values.firstWhere(
      (s) => s.name == rawSlot,
      orElse: () => TimeSlot.morning, // Fallback sécurisé
    );

    if (EquipmentAvailabilityValidator.hasSlotConflict(slot, existingSlot)) {
      return false; // Conflit détecté
    }
  }
  return true; // Disponible
}
```

**Usage correct dans `createStudentRental` :**

```dart
// ✅ Appel AVANT runTransaction
final isAvailable = await _checkAvailabilityInTransaction(
  rental.equipmentId,
  rental.dateString,
  rental.slot,
);
if (!isAvailable) throw Exception('Équipement indisponible pour ce créneau');

// La transaction vérifie + écrit atomiquement
await _firestore.runTransaction((transaction) async {
  // ... vérif wallet + écriture rental ...
});
```

---

### 5.7 `cancelRental` — Implémentation avec remboursement conditionnel

```dart
/// Annule une location.
///
/// RÈGLES MÉTIER :
///   - student_rental annulé > 24h avant → remboursement wallet
///   - student_rental annulé < 24h avant → pas de remboursement (exception levée)
///   - admin_assignment / instructor_assignment → annulation libre, pas de remboursement
///   - status 'active' (déjà check-out) → annulation impossible
@override
Future<void> cancelRental(String rentalId, String cancelledBy) async {
  final rentalRef = _firestore.collection('equipment_rentals').doc(rentalId);

  await _firestore.runTransaction((transaction) async {
    final rentalSnap = await transaction.get(rentalRef);
    if (!rentalSnap.exists) throw Exception('Location introuvable');

    final data = rentalSnap.data()! as Map<String, dynamic>;
    final currentStatus = data['status'] as String;
    final assignmentType = data['assignment_type'] as String;

    // 1. Bloquer si déjà check-out ou terminé
    if (currentStatus == 'active') {
      throw Exception('Impossible d\'annuler : le matériel a déjà été remis');
    }
    if (currentStatus == 'completed' || currentStatus == 'cancelled') {
      throw Exception('Location déjà terminée ou annulée');
    }

    // 2. Vérifier la règle des 24h pour student_rental uniquement
    bool shouldRefund = false;
    if (assignmentType == 'student_rental') {
      final rawDate = data['date_timestamp'] as Timestamp;
      final rentalDate = rawDate.toDate();
      final hoursUntilRental = rentalDate.difference(DateTime.now()).inHours;

      if (hoursUntilRental < 24) {
        throw Exception(
          'Annulation impossible : moins de 24h avant la session. '
          'Contactez l\'école pour toute demande exceptionnelle.',
        );
      }
      shouldRefund = true;
    }

    // 3. Annuler la location
    transaction.update(rentalRef, {
      'status': 'cancelled',
      'updated_at': FieldValue.serverTimestamp(),
    });

    // 4. Remboursement wallet si applicable
    if (shouldRefund) {
      final totalPrice = data['total_price'] as int?;
      if (totalPrice != null && totalPrice > 0) {
        final studentId = data['student_id'] as String;
        final userRef = _firestore.collection('users').doc(studentId);
        transaction.update(userRef, {
          'wallet_balance': FieldValue.increment(totalPrice),
        });
      }
    }
  });
}
```

---

### 5.8 Validator — Disponibilité équipement

```dart
// lib/domain/logic/equipment_availability_validator.dart
import '../models/equipment_rental.dart';

class EquipmentAvailabilityValidator {
  /// Matrice de conflit entre slots
  ///
  /// | Demandé    | Existant   | Conflit ? |
  /// |------------|------------|-----------|
  /// | Matin      | Matin      | ✅ OUI    |
  /// | Matin      | Après-midi | ❌ NON    |
  /// | Matin      | Journée    | ✅ OUI    |
  /// | Après-midi | Matin      | ❌ NON    |
  /// | Après-midi | Après-midi | ✅ OUI    |
  /// | Après-midi | Journée    | ✅ OUI    |
  /// | Journée    | Matin      | ✅ OUI    |
  /// | Journée    | Après-midi | ✅ OUI    |
  /// | Journée    | Journée    | ✅ OUI    |
  static bool hasSlotConflict(TimeSlot requestedSlot, TimeSlot existingSlot) {
    // Journée complète est toujours en conflit
    if (requestedSlot == TimeSlot.fullDay || existingSlot == TimeSlot.fullDay) {
      return true;
    }

    // Matin et Après-midi ne sont pas en conflit entre eux
    return requestedSlot == existingSlot;
  }

  /// Vérifie la disponibilité d'un équipement
  static bool isEquipmentAvailable({
    required List<EquipmentRental> existingRentals,
    required String dateString,
    required TimeSlot slot,
  }) {
    for (final rental in existingRentals) {
      // Même date ?
      if (rental.dateString != dateString) {
        continue;
      }

      // Statut annulé = pas un conflit
      if (rental.status == RentalStatus.cancelled) {
        continue;
      }

      // Conflit de slot ?
      if (hasSlotConflict(slot, rental.slot)) {
        return false; // Indisponible
      }
    }

    return true; // Disponible
  }
}
```

---

## 6. RÈGLES MÉTIER CRITIQUES

### 6.1 Gestion des Conflits

```dart
// ✅ RÈGLE : Un équipement ne peut pas être loué 2 fois sur le même créneau
// ✅ EXCEPTION : Matin + Après-midi = OK (différents créneaux)

┌─────────────────────────────────────────────────────────────┐
│  SCÉNARIO                  │  RÉSULTAT      │  JUSTIFICATION │
├─────────────────────────────────────────────────────────────┤
│  A loue Matin              │  ✅ OK         │  Premier       │
│  B loue Matin (même jour)  │  ❌ REFUSÉ     │  Conflit       │
│  B loue Après-midi         │  ✅ OK         │  Pas conflit   │
│  C loue Journée complète   │  ❌ REFUSÉ     │  Conflit A+B   │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Workflows d'Assignment (CRITIQUE)

```
┌─────────────────────────────────────────────────────────────────────┐
│  WORKFLOW 1 : LOCATION DIRECTE (Élève)                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Élève → Sélectionne matériel → Vérif disponibilité → Paiement     │
│                                                                     │
│  assignment_type: 'student_rental'                                  │
│  total_price: > 0 (payé via wallet)                                 │
│  payment_status: 'paid' (après débit)                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│  WORKFLOW 2 : ADMIN ASSIGNE (Validation réservation)                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Admin → Valide réservation → [Option] Assigne matériel             │
│                                                                     │
│  assignment_type: 'admin_assignment'                                │
│  total_price: null (non applicable — inclus dans cours)             │
│  payment_status: null (non applicable)                              │
│  reservations.equipment_assignment_required = false (si assigné)    │
│                                                                     │
│  ⚠️  Si admin N'assigne PAS :                                       │
│      → reservations.equipment_assignment_required = true            │
│      → Moniteur DOIT assigner avant début séance                    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│  WORKFLOW 3 : MONITEUR ASSIGNE (Obligatoire si admin skip)          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Moniteur → Voit réservation confirmée → Matériel requis ?          │
│             ├─ OUI → Assigner matériel (obligatoire)                │
│             └─ NON → Session sans matériel (ok si élève a le sien)  │
│                                                                     │
│  assignment_type: 'instructor_assignment'                           │
│  total_price: null (non applicable — inclus dans cours)             │
│  payment_status: null (non applicable)                              │
│  reservations.equipment_assignment_required = false (après assign)  │
│                                                                     │
│  ⚠️  BLOCAGE : Si equipment_assignment_required = true              │
│      → Session ne peut pas démarrer sans matériel assigné           │
│      → Alert moniteur : "Matériel obligatoire non assigné"          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.3 Règles de Décrémentation du Stock

| Type d'assignment | Décrémente stock | Période d'indisponibilité |
|-------------------|------------------|---------------------------|
| `student_rental` | ✅ Oui | Créneau spécifique (Matin/Après-midi/Journée) |
| `admin_assignment` | ✅ Oui | Toute la durée de la session |
| `instructor_assignment` | ✅ Oui | Toute la durée de la session |

**Important :**
- Location directe (`student_rental`) → Indisponible **uniquement pour le créneau réservé**
- Assignment cours (`admin_assignment` / `instructor_assignment`) → Indisponible **pour toute la session**

### 6.4 Transactions Firestore (OBLIGATOIRES)

**Toutes les écritures utilisent des transactions atomiques :**

| Opération | Transaction sur |
|-----------|-----------------|
| `createStudentRental` | equipment_items + equipment_rentals + users (wallet) |
| `createAdminAssignment` | equipment_items + equipment_rentals + reservations |
| `createInstructorAssignment` | equipment_items + equipment_rentals + reservations |
| `checkOut` | equipment_items + equipment_rentals |
| `checkIn` | equipment_items + equipment_rentals |

---

## 7. CAS D'USAGE & SCÉNARIOS

### 7.1 Scénario 1 : Élève loue du matériel (Location Directe)

```
1. Élève accède à "Réserver un cours" (pupil_booking_screen.dart)
2. Sélectionne date + slot (Matin/Après-midi/Journée)
3. Clique sur "Louer du matériel" ➕
4. Voir liste équipements disponibles (filtrés par catégorie)
5. Sélectionne équipement(s)
6. Voit prix total + disponibilité
7. Confirme la location
8. Paiement via wallet (débit immédiat)
9. Reçu généré + notification

Type : student_rental
Prix : > 0 (payé par élève)
Payment status : paid
```

**Points d'attention :**
- ✅ Vérifier disponibilité en temps réel
- ✅ Vérifier solde wallet avant confirmation
- ✅ Transaction Firestore atomique
- ✅ Notification moniteur (matériel à préparer)

---

### 7.2 Scénario 2 : Admin valide une réservation avec assignment matériel

```
1. Admin accède à "Réservations en attente"
2. Sélectionne une réservation pending
3. Voit détails : élève, date, slot, notes
4. Clique sur "Valider la séance"
5. Option : "Assigner du matériel" [OUI/NON]
   ├─ SI OUI → Sélectionne équipement disponible
   └─ SI NON → Laisse vide (moniteur assignera)
6. Confirme validation

Type : admin_assignment (si assigné)
Prix : null (inclus dans cours)
Payment status : null
equipment_assignment_required : false (si assigné) OU true (si skip)
```

**Points d'attention :**
- ✅ Vérifier disponibilité matériel avant assignment
- ✅ Si admin n'assigne pas → flag equipment_assignment_required = true
- ✅ Notification moniteur : "Session validée - Matériel à assigner"

---

### 7.3 Scénario 3 : Moniteur assigne matériel (Obligatoire)

```
1. Moniteur accède à "Sessions du jour"
2. Voit session confirmée avec indicateur : "Matériel requis ⚠️"
3. Clique sur "Assigner matériel"
4. Voir liste équipements disponibles pour ce slot
5. Sélectionne équipement(s)
6. Confirme assignment

Type : instructor_assignment
Prix : null (inclus dans cours)
Payment status : null
equipment_assignment_required : false (après assignment)
```

**Points d'attention :**
- ✅ BLOCAGE : Si equipment_assignment_required = true → Session bloquée
- ✅ Alert : "Vous devez assigner du matériel avant de démarrer"
- ✅ Matériel décrémente pour toute la session

---

### 7.4 Scénario 4 : Moniteur valide la remise du matériel (Check-out)

```
1. Moniteur accède à "Sessions en cours"
2. Sélectionne session avec matériel assigné
3. Voit liste des locations associées
4. Clique sur "Remettre le matériel" (check-out)
5. Vérifie état du matériel avec l'élève
6. Note état initial (optionnel mais recommandé)
7. Confirme la remise

checked_out_at: DateTime.now()
checked_out_by: UID moniteur
condition_at_checkout: 'good' (par exemple)
equipment_item.current_status: 'rented'
```

**Points d'attention :**
- ✅ Timestamp check-out obligatoire
- ✅ Photo du matériel (optionnel mais recommandé)
- ✅ Notification élève (matériel prêt)

---

### 7.5 Scénario 5 : Moniteur valide le retour du matériel (Check-in)

```
1. Moniteur récupère le matériel après session
2. Inspecte l'état avec l'élève
3. Clique sur "Retour matériel" (check-in)
4. Sélectionne état final
5. Si dégâts → ajoute notes + photo
6. Confirme le retour
7. Équipement redevient disponible

checked_in_at: DateTime.now()
checked_in_by: UID moniteur
condition_at_checkin: 'good' ou 'fair' ou 'poor'
damage_notes: "Petite égratignure sur le bord" (si nécessaire)
equipment_item.current_status: 'available' ou 'maintenance'
```

**Points d'attention :**
- ✅ Comparer état check-out vs check-in
- ✅ Si dégâts → notification admin
- ✅ Bloquer équipement si maintenance requise
- ✅ Matériel redevient disponible pour prochains créneaux

---

### 7.6 Scénario 6 : Admin gère le parc matériel

```
1. Admin accède à "Gestion Matériel"
2. Voit liste complète des équipements
3. Peut :
   - ➕ Ajouter nouvel équipement
   - ✏️ Modifier infos (prix, description)
   - 🗑️ Désactiver équipement (maintenance)
   - 📊 Voir statistiques d'utilisation
4. Configure catégories disponibles
```

---

## 8. PLAN D'IMPLÉMENTATION

### Phase 0 : Migrations & Setup (AVANT Phase 1)

> **⚠️ IMPORTANT :** Ces tâches doivent être faites AVANT de déployer la fonctionnalité en production.

#### 0.1 Migration des réservations existantes

**Problème :** Les documents `reservations` existants n'ont pas le champ `equipment_assignment_required`.

**Solution :** Script de migration + Bouton Admin pour l'exécuter.

**Fichiers à créer :**
```
lib/
├── data/
│   └── repositories/
│       └── firestore_equipment_migration_repository.dart  # 🆕
├── domain/
│   └── repositories/
│       └── equipment_migration_repository.dart            # 🆕
└── presentation/
    └── screens/
        └── admin_migration_screen.dart                    # 🆕
```

**Fonctions de migration :**
```dart
// 1. Migration : Ajoute equipment_assignment_required = false à toutes les réservations
Future<MigrationResult> migrateReservationsAddEquipmentFlag() async {
  // Lit toutes les réservations
  // Ajoute le champ manquant sur chaque document
  // Retourne : {success: int, failed: int, errors: List<String>}
}

// 2. Init : Crée les catégories par défaut
Future<MigrationResult> initEquipmentCategories() async {
  // Crée : kite, board, foil, harness, wing
  // Retourne : {success: int, failed: int, errors: List<String>}
}
```

**UI Admin — Boutons de migration :**
```dart
// admin_migration_screen.dart
// Écran accessible uniquement aux admins
// 2 boutons avec feedback visuel :

[ Bouton 1 : "Migration Réservations" ]
  → Ajoute equipment_assignment_required à toutes les réservations existantes
  → Affiche : "X réservations migrées avec succès"
  → Warning : "Cette action est irréversible"

[ Bouton 2 : "Initialiser Catégories Équipement" ]
  → Crée les 5 catégories par défaut
  → Affiche : "5 catégories créées"
```

**Quand lancer les migrations ?**
- ✅ **Après** avoir déployé le code (models + repositories)
- ✅ **Avant** d'activer la fonctionnalité pour les utilisateurs
- ✅ **Une seule fois** — idempotent (peut être relancé sans risque)

**Instructions pour l'utilisateur :**
1. Ouvrir l'application
2. Se connecter en tant qu'admin
3. Aller dans "Admin" → "Migrations & Tools"
4. Cliquer sur "Migration Réservations"
5. Attendre la confirmation
6. Cliquer sur "Initialiser Catégories Équipement"
7. ✅ Prêt !

---

### Phase 1 : Modèles de Données (Jour 1)

- [ ] Créer `lib/utils/date_utils.dart`
- [ ] Créer `lib/domain/models/equipment_item.dart`
- [ ] Créer `lib/domain/models/equipment_rental.dart` (avec `TimeSlot` existant)
- [ ] Créer `lib/domain/models/equipment_category.dart`
- [ ] Lancer `build_runner` pour générer `.freezed.dart` et `.g.dart`

### Phase 2 : Repository Layer (Jour 2)

- [ ] Créer `lib/domain/repositories/equipment_repository.dart`
- [ ] Créer `lib/domain/repositories/equipment_rental_repository.dart`
- [ ] Créer `lib/data/repositories/firestore_equipment_repository.dart`
- [ ] Créer `lib/data/repositories/firestore_equipment_rental_repository.dart`
- [ ] Ajouter providers dans `repository_providers.dart`

### Phase 3 : Logique Métier (Jour 3)

- [ ] Créer `lib/domain/logic/equipment_availability_validator.dart`
- [ ] Implémenter tests unitaires validator
- [ ] Implémenter transactions Firestore (check-out/in)

### Phase 4 : State Management (Jour 4)

- [ ] Créer `lib/presentation/providers/equipment_notifier.dart`
- [ ] Créer `lib/presentation/providers/equipment_rental_notifier.dart`
- [ ] Créer `lib/presentation/providers/equipment_availability_notifier.dart`

### Phase 5 : UI Élève - Location Directe (Jour 5-6)

- [ ] Créer `lib/presentation/screens/equipment_rental_screen.dart`
- [ ] Créer `lib/presentation/screens/equipment_rental_history_screen.dart`
- [ ] Créer widgets : `equipment_card.dart`, `equipment_rental_tile.dart`
- [ ] Intégrer dans `pupil_booking_screen.dart` (bouton "Louer matériel")
- [ ] **Type : `student_rental`**

### Phase 6 : UI Admin - Validation avec Assignment (Jour 7)

- [ ] Modifier écran validation réservations (admin)
- [ ] Ajouter option "Assigner matériel" [OUI/NON]
- [ ] Si OUI → Sélection équipement disponible
- [ ] Si NON → `reservations.equipment_assignment_required = true`
- [ ] **Type : `admin_assignment`**

### Phase 7 : UI Moniteur - Assignment Obligatoire (Jour 8-9)

- [ ] Créer `lib/presentation/screens/equipment_assignment_screen.dart`
- [ ] Intégrer dans `lesson_validation_screen.dart`
- [ ] **Alert si `equipment_assignment_required = true`**
- [ ] BLOCAGE : Session ne démarre pas sans matériel
- [ ] Check-out/Check-in avec état matériel
- [ ] **Type : `instructor_assignment`**

### Phase 8 : Tests & Validation (Jour 10-11)

- [ ] Tests unitaires repositories
- [ ] Tests d'intégration flux complet (3 workflows)
- [ ] Tests de performance (jank, mémoire)
- [ ] Validation règles de sécurité Firestore
- [ ] Review code + refactor si nécessaire

---

## 9. CHECKLIST DE VALIDATION

### 9.0 Migrations (PRÉ-REQUIS — Phase 0)

| Migration | Statut | Notes |
|-----------|--------|-------|
| **Bouton "Migration Réservations"** | ☐ À faire | Ajoute `equipment_assignment_required` à toutes les réservations |
| **Bouton "Initialiser Catégories"** | ☐ À faire | Crée les 5 catégories par défaut |
| **Test migration en local** | ☐ À faire | Vérifier que c'est idempotent |
| **Backup Firestore** | ☐ Optionnel | **Recommandé en prod, optionnel en phase de test** |

> **💡 CONTEXTE : Phase de test**  
> Si tu es en phase de test avec peu de données dans ta base :
> - ✅ **Backup NON requis** — Tu peux recréer la base facilement
> - ✅ **Migration sans risque** — Peu de données à perdre
> - ⚠️ **En production** : Toujours faire un backup avant !

---

### 9.1 Performance (Obligatoire)

- [ ] `const` constructors sur tous les widgets statiques
- [ ] `ValueKey(id)` sur les listes dynamiques
- [ ] `RepaintBoundary` autour des animations
- [ ] `select()` pour rebuilds ciblés dans Riverpod
- [ ] `if (!context.mounted)` après chaque `await`
- [ ] Aucun `print()` en production
- [ ] Imports triés (dart: → flutter: → packages → app)

### 9.2 Sécurité (Non-négociable)

- [ ] Transactions Firestore pour écritures critiques
- [ ] Règles Firestore validées avec `firebase_validate_security_rules`
- [ ] App Check activé et fonctionnel
- [ ] Pas de données sensibles dans les logs
- [ ] Validation côté serveur des prix et disponibilités

### 9.3 Qualité de Code

- [ ] `flutter analyze` sans erreurs
- [ ] Tests unitaires > 80% coverage
- [ ] Documentation des fonctions publiques
- [ ] Noms de variables explicites (pas de `data`, `temp`, etc.)
- [ ] Fonctions < 40 lignes
- [ ] Widgets extraits si > 100 lignes

### 9.4 Spécifique aux Workflows

| Workflow | Checklist |
|----------|-----------|
| **Location Directe** | [ ] Paiement wallet, [ ] Décrémentation créneau, [ ] Reçu |
| **Admin Assignment** | [ ] Option assigner OUI/NON, [ ] Flag `equipment_assignment_required` |
| **Moniteur Assignment** | [ ] Alert si requis, [ ] BLOCAGE si non assigné, [ ] Check-out/in |

### 9.5 Documentation

- [ ] `firestore_schema.md` mis à jour avec nouvelles collections
- [ ] Commentaires sur règles métier complexes
- [ ] README.md section matériel ajoutée
- [ ] Guide d'utilisation admin/moniteur

---

## 📊 MÉTRIQUES DE SUCCÈS

| Métrique | Cible | Mesure |
|----------|-------|--------|
| **Performance** | 120 FPS constant | Flutter DevTools |
| **Précision** | 0 conflit non détecté | Tests automatisés |
| **Sécurité** | 0 faille Firestore | Audit règles |
| **UX Location Directe** | < 3 clics pour louer | Test utilisateur |
| **UX Admin Assignment** | Option OUI/NON claire | Test utilisateur |
| **UX Moniteur Assignment** | 100% des sessions avec matériel assigné | Analytics |
| **Code Quality** | 0 erreur `flutter analyze` | CI/CD |

---

## 🔗 LIENS UTILES

- **Documentation Freezed** : https://pub.dev/packages/freezed
- **Riverpod Generator** : https://riverpod.dev/docs/introduction/getting_started
- **Firestore Indexes** : https://firebase.google.com/docs/firestore/query-data/indexing
- **Flutter Performance** : https://docs.flutter.dev/perf/rendering-performance

---

## 📝 RÉSUMÉ DES WORKFLOWS

```
┌─────────────────────────────────────────────────────────────────────┐
│  WORKFLOW COMPLET : GESTION MATÉRIEL                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. LOCATION DIRECTE (Élève)                                        │
│     └─ student_rental → Paiement wallet → Créneau spécifique       │
│                                                                     │
│  2. ASSIGNMENT ADMIN (Validation réservation)                       │
│     ├─ admin_assignment → Matériel assigné → OK                     │
│     └─ [SKIP] → equipment_assignment_required = true → ALERT        │
│                                                                     │
│  3. ASSIGNMENT MONITEUR (Obligatoire si admin skip)                 │
│     └─ instructor_assignment → BLOCAGE si non fait                  │
│                                                                     │
│  4. CHECK-OUT (Remise matériel)                                     │
│     └─ Timestamp + État initial + current_status → 'rented'         │
│                                                                     │
│  5. CHECK-IN (Retour matériel)                                      │
│     └─ Timestamp + État final + current_status → 'available'        │
│                                                                     │
│  6. DISPONIBILITÉ                                                   │
│     └─ Matériel redevient disponible après check-in                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Points Critiques à Retenir :**

1. **3 types d'assignment** : `student_rental`, `admin_assignment`, `instructor_assignment`
2. **Flag bloquant** : `reservations.equipment_assignment_required = true` → Session bloquée
3. **Double stockage date** : `date_string` (equality) + `date_timestamp` (index)
4. **État physique** : `equipment_items.current_status` mis à jour par transaction
5. **Prix nullable** : `total_price: int?` (null = non applicable pour assignments)
6. **Transactions Firestore** : Requises pour toutes les écritures critiques
7. **TimeSlot existant** : Réutilisé (pas de nouvel enum)
8. **`_checkAvailabilityInTransaction`** : Appelée AVANT `runTransaction` (limite Firestore)
9. **Trigger maintenance** : `condition == 'poor'` OU `damageNotes` non vide (les deux)
10. **`cancelRental`** : Remboursement wallet uniquement si `student_rental` et `> 24h`
11. **Migrations** : 2 boutons Admin pour migrer les données existantes (Phase 0)

---

## 📋 HISTORIQUE DES CORRECTIONS

| Version | Corrections |
|---------|-------------|
| v1.0 | Document original |
| v2.0 | FK session_id → reservation_id · date_string + index · instructor_assignment_required sur reservations · current_status · total_price null · TimeSlot réutilisé |
| v2.1 | Intégration corrections v2.0 dans le document |
| **v2.2** | **Trigger maintenance checkIn (condition 'poor' OR damageNotes) · `_checkAvailabilityInTransaction` documentée avec note limitation Firestore · `cancelRental` implémentée avec règle J-1 et remboursement wallet conditionnel · Phase 0 Migrations ajoutée (boutons Admin)** |

---

**Dernière mise à jour :** 5 mars 2026
**Prochaine revue :** Après validation de l'implémentation

---

## 📎 ANNEXE A : MIGRATIONS

### A.1 Structure des fichiers de migration

```dart
// lib/domain/repositories/equipment_migration_repository.dart
abstract class EquipmentMigrationRepository {
  /// Ajoute le champ equipment_assignment_required à toutes les réservations
  /// Retourne le nombre de documents migrés + erreurs
  Future<MigrationResult> migrateReservationsAddEquipmentFlag();

  /// Crée les catégories d'équipement par défaut
  /// Idempotent : ne crée pas si existe déjà
  Future<MigrationResult> initEquipmentCategories();
}

class MigrationResult {
  final int successCount;
  final int failedCount;
  final List<String> errors;

  const MigrationResult({
    required this.successCount,
    required this.failedCount,
    required this.errors,
  });

  bool get hasErrors => failedCount > 0;
}
```

### A.2 UI Admin — Exemple d'implémentation

```dart
// lib/presentation/screens/admin_migration_screen.dart
// Écran accessible UNIQUEMENT aux admins

class AdminMigrationScreen extends ConsumerStatefulWidget {
  const AdminMigrationScreen({super.key});

  @override
  ConsumerState<AdminMigrationScreen> createState() =>
      _AdminMigrationScreenState();
}

class _AdminMigrationScreenState extends ConsumerState<AdminMigrationScreen> {
  bool _isMigratingReservations = false;
  bool _isMigratingCategories = false;
  String? _migrationResult;

  Future<void> _migrateReservations() async {
    setState(() {
      _isMigratingReservations = true;
      _migrationResult = null;
    });

    try {
      final repository = ref.read(equipmentMigrationRepositoryProvider);
      final result = await repository.migrateReservationsAddEquipmentFlag();

      if (context.mounted) {
        setState(() {
          _migrationResult =
              '✅ ${result.successCount} réservations migrées avec succès'
              '${result.hasErrors ? '\n⚠️ ${result.failedCount} erreurs : ${result.errors.join(", ")}' : ''}';
        });
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _migrationResult = '❌ Erreur : ${e.toString()}';
        });
      }
    } finally {
      if (context.mounted) {
        setState(() => _isMigratingReservations = false);
      }
    }
  }

  Future<void> _initCategories() async {
    // Même pattern que _migrateReservations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Migrations & Tools')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Bouton Migration Réservations
            ElevatedButton(
              onPressed: _isMigratingReservations ? null : _migrateReservations,
              child: _isMigratingReservations
                  ? const CircularProgressIndicator()
                  : const Text('Migration Réservations'),
            ),
            const SizedBox(height: 16),

            // Bouton Initialiser Catégories
            ElevatedButton(
              onPressed: _isMigratingCategories ? null : _initCategories,
              child: _isMigratingCategories
                  ? const CircularProgressIndicator()
                  : const Text('Initialiser Catégories Équipement'),
            ),
            const SizedBox(height: 24),

            // Résultat
            if (_migrationResult != null)
              Text(
                _migrationResult!,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
```

### A.3 Instructions pour l'utilisateur

```markdown
## 🔄 Migrations — Guide d'utilisation

### Pré-requis
- ✅ Être connecté en tant qu'**admin**
- ✅ Avoir déployé le code (models + repositories)
- 💡 **Backup Firestore** : Optionnel en phase de test, requis en production

### Étapes

1. **Ouvrir l'application**
2. **Aller dans Admin** → "Migrations & Tools"
3. **Cliquer sur "Migration Réservations"**
   - ⏱️ Durée : ~5-10 secondes (selon nombre de réservations)
   - ✅ Message : "X réservations migrées avec succès"
4. **Cliquer sur "Initialiser Catégories Équipement"**
   - ⏱️ Durée : ~2-3 secondes
   - ✅ Message : "5 catégories créées"
5. **✅ Prêt !** La fonctionnalité matériel est opérationnelle

### En cas d'erreur

- **Erreur "Permission denied"** : Vérifiez que vous êtes admin
- **Erreur "Network error"** : Vérifiez la connexion internet
- **Erreur inconnue** : Consulter les logs Firebase Console

### 💡 Note : Backup Firestore

**En phase de test (ton cas) :**
- ❌ **Backup NON requis** — Base de données facile à recréer
- ✅ Tu peux lancer les migrations sans risque

**En production :**
- ⚠️ **TOUJOURS faire un backup avant**
- 📦 Commande : `gcloud firestore export gs://ton-bucket/backup-$(date +%Y-%m-%d)`
```
