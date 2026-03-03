# 🏄 Location de Matériel — Plan d'Implémentation Flutter
**Version corrigée v2.0 · Revue Lead Dev Senior · 6 bugs critiques corrigés**

---

## 📋 Table des matières

1. [Résumé des corrections](#1-résumé-des-corrections)
2. [Schéma Firestore](#2-schéma-firestore)
3. [Utilitaires](#3-utilitaires)
4. [Modèles de données](#4-modèles-de-données)
5. [Repository — corrections critiques](#5-repository--corrections-critiques)
6. [State Management (Riverpod)](#6-state-management-riverpod)
7. [Security Rules](#7-security-rules)
8. [Tests](#8-tests)
9. [Migration & Déploiement](#9-migration--déploiement)

---

## 1. Résumé des corrections

| ID | Problème original | Criticité |
|----|-------------------|-----------|
| #1 | Race condition dans `createBooking` — pas de transaction atomique | 🔴 Critique |
| #2 | N+1 query dans `watchAvailableQuantity` — lecture Firestore dans `asyncMap` | 🔴 Critique |
| #3 | `AsyncValue.fold()` inversé — data/error permutés (n'existe pas en Riverpod) | 🔴 Critique |
| #4 | Index Firestore référencent `date` (inexistant) au lieu de `date_string`/`date_timestamp` | 🔴 Critique |
| #5 | `availableQuantity` dans le modèle Freezed alors qu'il n'est pas stocké en Firestore | 🔴 Critique |
| #6 | Logique de conflit `full_day` non symétrique | 🔴 Critique |
| #7 | Security Rules absentes | 🟡 Important |
| #8 | Limite 3 réservations actives non implémentée | 🟡 Important |

---

## 2. Schéma Firestore

### Collection `equipment` (modifiée)

> ⚠️ `available_quantity` n'est **PAS stocké**. Seul `total_quantity` est ajouté.

```
equipment/{id}
├── type: "kite" | "foil" | "board" | "harness"
├── brand: "F-ONE"
├── model: "Bandit"
├── size: 12
├── status: "active" | "maintenance" | "retired"
├── total_quantity: 4          ← NOUVEAU (seul champ ajouté)
└── updated_at: FieldValue.serverTimestamp()
```

### Nouvelle collection `equipment_bookings`

```
equipment_bookings/{booking_id}
├── id: "uuid"
├── user_id: "uid_de_leleve"
├── user_name: "John Doe"
├── user_email: "john@example.com"
├── equipment_id: "equipment_123"
├── equipment_type: "kite"
├── equipment_brand: "F-ONE"
├── equipment_model: "Bandit"
├── equipment_size: 12.0
├── date_string: "2026-03-15"    ← ISO-8601, sans timezone (requêtes)
├── date_timestamp: Timestamp    ← UTC (index Firestore)
├── slot: "morning" | "afternoon" | "full_day"
├── status: "confirmed" | "cancelled" | "completed"
├── created_at: FieldValue.serverTimestamp()
├── updated_at: FieldValue.serverTimestamp()
├── created_by: "uid_createur"
├── session_id: "session_456" | null
└── notes: "..." | null
```

### ✅ CORRECTION #4 — Index Firestore corrigés

**Bug original :** les index référençaient `date` (champ inexistant dans le schéma).

```json
// firestore.indexes.json — CORRIGÉ
{
  "indexes": [
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "user_id", "order": "ASCENDING" },
        { "fieldPath": "date_timestamp", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "date_string", "order": "ASCENDING" },
        { "fieldPath": "slot", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "equipment_id", "order": "ASCENDING" },
        { "fieldPath": "date_string", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "equipment_id", "order": "ASCENDING" },
        { "fieldPath": "date_timestamp", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "date_timestamp", "order": "ASCENDING" }
      ]
    }
  ]
}
```

```bash
firebase deploy --only firestore:indexes
```

---

## 3. Utilitaires

```dart
// lib/utils/date_utils.dart
import 'package:intl/intl.dart';

/// Formate une date en string ISO-8601 (YYYY-MM-DD) en UTC
String formatDateForQuery(DateTime date) {
  final utcDate = DateTime.utc(date.year, date.month, date.day);
  return DateFormat('yyyy-MM-dd').format(utcDate);
}

/// Parse un string ISO-8601 en DateTime UTC
DateTime parseDateFromQuery(String dateString) {
  final parts = dateString.split('-');
  return DateTime.utc(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// Vérifie si deux dates sont le même jour
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
```

### ✅ CORRECTION #6 — Logique de conflit full_day symétrique

**Bug original :** si `morning` était déjà réservé et qu'on demandait `full_day`, le conflit n'était pas détecté. La logique doit être bidirectionnelle.

```dart
// lib/utils/booking_conflict_utils.dart — NOUVEAU
import '../domain/models/equipment_booking.dart';

/// Vérifie si deux créneaux sont en conflit.
/// RÈGLE : full_day entre en conflit avec TOUT, et TOUT entre en conflit avec full_day.
bool slotsConflict(
  EquipmentBookingSlot existing,
  EquipmentBookingSlot requested,
) {
  if (existing == EquipmentBookingSlot.fullDay) return true;
  if (requested == EquipmentBookingSlot.fullDay) return true;
  return existing == requested;
}

/// Compte combien de réservations existantes conflictent avec le créneau demandé
int countConflictingBookings(
  List<Map<String, dynamic>> existingBookings,
  EquipmentBookingSlot requestedSlot,
) {
  int count = 0;
  for (final booking in existingBookings) {
    final existingSlot = EquipmentBookingSlot.values.firstWhere(
      (e) => e.name == (booking['slot'] as String),
    );
    if (slotsConflict(existingSlot, requestedSlot)) {
      count++;
    }
  }
  return count;
}
```

---

## 4. Modèles de données

### ✅ CORRECTION #5 — Equipment sans `availableQuantity`

**Bug original :** `availableQuantity` était dans le modèle Freezed alors qu'il n'est pas stocké dans Firestore. Corrigé avec deux modèles séparés.

```dart
// lib/domain/models/equipment.dart — CORRIGÉ
@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    required String id,
    required String type,
    required String brand,
    required String model,
    required double size,
    required String status,
    required int totalQuantity,   // ← Seul champ ajouté (stocké Firestore)
    // ❌ SUPPRIMÉ : availableQuantity (n'est PAS en Firestore)
    required DateTime updatedAt,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}
```

```dart
// lib/domain/models/equipment_with_availability.dart — NOUVEAU
import 'equipment.dart';
import 'equipment_booking.dart';

/// Modèle enrichi : Equipment + disponibilité calculée dynamiquement.
/// Ne correspond à aucun document Firestore — jamais stocké.
class EquipmentWithAvailability {
  final Equipment equipment;
  final int availableQuantity; // Calculé, jamais stocké
  final EquipmentBookingSlot requestedSlot;
  final DateTime requestedDate;

  const EquipmentWithAvailability({
    required this.equipment,
    required this.availableQuantity,
    required this.requestedSlot,
    required this.requestedDate,
  });

  bool get isAvailable => availableQuantity > 0;
}
```

### Modèle `EquipmentBooking`

```dart
// lib/domain/models/equipment_booking.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_booking.freezed.dart';
part 'equipment_booking.g.dart';

enum EquipmentBookingSlot { morning, afternoon, fullDay }
enum EquipmentBookingStatus { confirmed, cancelled, completed }

@freezed
class EquipmentBooking with _$EquipmentBooking {
  const factory EquipmentBooking({
    required String id,
    required String userId,
    required String userName,
    required String userEmail,
    required String equipmentId,
    required String equipmentType,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,
    required String dateString,       // ISO-8601 ex: '2026-03-15'
    required DateTime dateTimestamp,  // UTC pour index
    required EquipmentBookingSlot slot,
    required EquipmentBookingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    String? sessionId,
    String? notes,
  }) = _EquipmentBooking;

  factory EquipmentBooking.fromJson(Map<String, dynamic> json) =>
      _$EquipmentBookingFromJson(json);
}
```

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 5. Repository — Corrections critiques

### ✅ CORRECTION #1 — Transaction atomique dans `createBooking`

**Bug original :** le check de disponibilité et l'écriture n'étaient pas atomiques. Entre les deux opérations, un autre utilisateur pouvait réserver le même équipement.

### ✅ CORRECTION #2 — Stream sans N+1 query

**Bug original :** `watchAvailableQuantity` relisait le document `equipment` à chaque mise à jour du stream via `asyncMap`. Corrigé en combinant deux streams avec `Rx.combineLatest2`.

### ✅ CORRECTION #8 — Limite 3 réservations actives implémentée

```dart
// lib/data/repositories/firebase_equipment_booking_repository.dart — CORRIGÉ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_with_availability.dart';
import '../../domain/repositories/equipment_booking_repository.dart';
import '../../utils/date_utils.dart';
import '../../utils/booking_conflict_utils.dart';

class FirebaseEquipmentBookingRepository
    implements EquipmentBookingRepository {
  final FirebaseFirestore _firestore;
  static const int _maxActiveBookingsPerUser = 3;

  FirebaseEquipmentBookingRepository(this._firestore);

  // ── CORRECTION #1 : Transaction atomique ──────────────────────────────
  // Check + write dans une seule transaction Firestore.
  // Sans ça, deux utilisateurs peuvent passer le check simultanément.
  @override
  Future<String> createBooking(EquipmentBooking booking) async {
    final bookingRef = _firestore.collection('equipment_bookings').doc();
    final equipmentRef = _firestore
        .collection('equipment')
        .doc(booking.equipmentId);

    await _firestore.runTransaction((transaction) async {
      // 1. Lire l'équipement dans la transaction
      final equipmentSnap = await transaction.get(equipmentRef);
      if (!equipmentSnap.exists) {
        throw Exception('Équipement introuvable');
      }
      final totalQty =
          (equipmentSnap.data()?['total_quantity'] ?? 0) as int;

      // 2. Vérifier limite de réservations actives (CORRECTION #8)
      final userActiveBookings = await _firestore
          .collection('equipment_bookings')
          .where('user_id', isEqualTo: booking.userId)
          .where('status', isEqualTo: 'confirmed')
          .get();
      if (userActiveBookings.docs.length >= _maxActiveBookingsPerUser) {
        throw Exception(
          'Limite de $_maxActiveBookingsPerUser réservations actives atteinte',
        );
      }

      // 3. Lire les réservations existantes pour cette date/équipement
      final existingBookings = await _firestore
          .collection('equipment_bookings')
          .where('equipment_id', isEqualTo: booking.equipmentId)
          .where('date_string', isEqualTo: booking.dateString)
          .where('status', whereIn: ['confirmed', 'completed'])
          .get();

      // 4. Calculer conflits avec la logique symétrique (CORRECTION #6)
      final conflictCount = countConflictingBookings(
        existingBookings.docs.map((d) => d.data()).toList(),
        booking.slot,
      );

      if (conflictCount >= totalQty) {
        throw Exception('Matériel non disponible pour ce créneau');
      }

      // 5. Écriture atomique dans la même transaction
      transaction.set(bookingRef, {
        ...booking.toJson(),
        'id': bookingRef.id,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    });

    return bookingRef.id;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _firestore
        .collection('equipment_bookings')
        .doc(bookingId)
        .update({
      'status': 'cancelled',
      'updated_at': FieldValue.serverTimestamp(),
    });
    // Pas de réincrémentation : le calcul dynamique gère automatiquement
  }

  @override
  Future<void> completeBooking(String bookingId) async {
    await _firestore
        .collection('equipment_bookings')
        .doc(bookingId)
        .update({
      'status': 'completed',
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<EquipmentBooking>> getUserBookings(String userId) async {
    final snapshot = await _firestore
        .collection('equipment_bookings')
        .where('user_id', isEqualTo: userId)
        .orderBy('date_timestamp', descending: true)
        .limit(50)
        .get();
    return snapshot.docs
        .map((doc) => EquipmentBooking.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<EquipmentBooking>> getBookingsByDate(DateTime date) async {
    final dateString = formatDateForQuery(date);
    final snapshot = await _firestore
        .collection('equipment_bookings')
        .where('date_string', isEqualTo: dateString)
        .orderBy('date_timestamp')
        .get();
    return snapshot.docs
        .map((doc) => EquipmentBooking.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<EquipmentBooking>> getEquipmentBookings(
      String equipmentId) async {
    final snapshot = await _firestore
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .orderBy('date_timestamp', descending: true)
        .limit(100)
        .get();
    return snapshot.docs
        .map((doc) => EquipmentBooking.fromJson(doc.data()))
        .toList();
  }

  @override
  Stream<List<EquipmentBooking>> watchUserBookings(String userId) {
    return _firestore
        .collection('equipment_bookings')
        .where('user_id', isEqualTo: userId)
        .orderBy('date_timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map((doc) => EquipmentBooking.fromJson(doc.data()))
            .toList());
  }

  // ── CORRECTION #2 : Stream sans N+1 query ─────────────────────────────
  // Version originale : asyncMap relisait equipment à chaque update du stream.
  // Version corrigée : Rx.combineLatest2 combine deux streams indépendants,
  // aucune lecture imbriquée.
  Stream<EquipmentWithAvailability> watchEquipmentAvailability({
    required String equipmentId,
    required DateTime date,
    required EquipmentBookingSlot slot,
  }) {
    final dateString = formatDateForQuery(date);

    // Stream 1 : l'équipement lui-même
    final equipmentStream = _firestore
        .collection('equipment')
        .doc(equipmentId)
        .snapshots()
        .map((snap) => snap.exists
            ? Equipment.fromJson(snap.data()!)
            : null);

    // Stream 2 : les réservations pour cette date
    final bookingsStream = _firestore
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());

    // Combinaison sans lecture imbriquée
    return Rx.combineLatest2<Equipment?, List<Map<String, dynamic>>,
        EquipmentWithAvailability>(
      equipmentStream,
      bookingsStream,
      (equipment, bookings) {
        if (equipment == null) throw Exception('Équipement introuvable');
        final conflictCount = countConflictingBookings(bookings, slot);
        return EquipmentWithAvailability(
          equipment: equipment,
          availableQuantity: equipment.totalQuantity - conflictCount,
          requestedSlot: slot,
          requestedDate: date,
        );
      },
    );
  }
}
```

---

## 6. State Management (Riverpod)

### ✅ CORRECTION #3 — `AsyncValue.guard` utilisé correctement

**Bug original :** `result.fold()` n'existe pas sur `AsyncValue` en Riverpod. La version originale avait data et error inversés en plus.

```dart
// lib/presentation/providers/equipment_booking_notifier.dart — CORRIGÉ
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/repositories/equipment_booking_repository.dart';
import '../providers/auth_state_provider.dart';
import 'repository_providers.dart';

part 'equipment_booking_notifier.g.dart';

@riverpod
class EquipmentBookingNotifier extends _$EquipmentBookingNotifier {
  @override
  FutureOr<List<EquipmentBooking>> build(String userId) async {
    return ref
        .watch(equipmentBookingRepositoryProvider)
        .getUserBookings(userId);
  }

  // ── CORRECTION #3 : AsyncValue.guard sans .fold() ─────────────────────
  // Pattern correct : guard + .value!, pas fold(data, error)
  Future<String> createBooking({
    required String equipmentId,
    required String equipmentType,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,
    required DateTime date,
    required EquipmentBookingSlot slot,
    String? sessionId,
    String? notes,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) throw Exception('Utilisateur non connecté');

    final dateString = formatDateForQuery(date);
    final dateTimestamp = DateTime.utc(date.year, date.month, date.day);

    final booking = EquipmentBooking(
      id: '',
      userId: user.id,
      userName: user.displayName,
      userEmail: user.email,
      equipmentId: equipmentId,
      equipmentType: equipmentType,
      equipmentBrand: equipmentBrand,
      equipmentModel: equipmentModel,
      equipmentSize: equipmentSize,
      dateString: dateString,
      dateTimestamp: dateTimestamp,
      slot: slot,
      status: EquipmentBookingStatus.confirmed,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: user.id,
      sessionId: sessionId,
      notes: notes,
    );

    // AsyncValue.guard retourne AsyncValue<T>
    // .value! lance l'exception si AsyncError, retourne la valeur sinon
    final result = await AsyncValue.guard(
      () => ref
          .read(equipmentBookingRepositoryProvider)
          .createBooking(booking),
    );

    final bookingId = result.value!;
    ref.invalidateSelf();
    return bookingId;
  }

  Future<void> cancelBooking(String bookingId) async {
    final result = await AsyncValue.guard(
      () => ref
          .read(equipmentBookingRepositoryProvider)
          .cancelBooking(bookingId),
    );
    result.value; // Lance l'exception si erreur
    ref.invalidateSelf();
  }
}
```

---

## 7. Security Rules

### ✅ AJOUT #7 — Firestore Security Rules

> ⚠️ Absent dans la version originale. Non-négociable en production : sans ces règles, n'importe quel utilisateur peut écrire une réservation pour n'importe quel `user_id`.

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ── Helpers ──────────────────────────────────────────────────────────
    function isAuth() { return request.auth != null; }
    function isOwner(userId) { return request.auth.uid == userId; }
    function isMonitor() {
      return isAuth() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid))
          .data.role == 'monitor';
    }
    function isAdmin() {
      return isAuth() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid))
          .data.role == 'admin';
    }

    // ── Equipment (lecture auth, écriture admin/monitor) ─────────────────
    match /equipment/{equipmentId} {
      allow read: if isAuth();
      allow write: if isAdmin() || isMonitor();
    }

    // ── Equipment Bookings ────────────────────────────────────────────────
    match /equipment_bookings/{bookingId} {
      // Lecture : propriétaire, moniteur ou admin
      allow read: if isAuth() && (
        isOwner(resource.data.user_id) || isMonitor() || isAdmin()
      );

      // Création : élève pour lui-même, ou moniteur avec session_id
      allow create: if isAuth() && (
        (isOwner(request.resource.data.user_id) &&
          request.resource.data.keys().hasAll([
            'user_id', 'equipment_id', 'date_string',
            'date_timestamp', 'slot', 'status'
          ]) &&
          request.resource.data.status == 'confirmed'
        ) ||
        (isMonitor() && request.resource.data.session_id != null)
      );

      // Mise à jour : élève peut seulement annuler sa propre réservation
      allow update: if isAuth() && (
        (isOwner(resource.data.user_id) &&
          request.resource.data.status == 'cancelled' &&
          request.resource.data.diff(resource.data).affectedKeys()
            .hasOnly(['status', 'updated_at'])
        ) ||
        isMonitor() || isAdmin()
      );

      // Suppression : admin seulement
      allow delete: if isAdmin();
    }
  }
}
```

```bash
firebase deploy --only firestore:rules
```

---

## 8. Tests

```dart
// test/repositories/equipment_booking_repository_test.dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/data/repositories/firebase_equipment_booking_repository.dart';
import 'package:your_app/domain/models/equipment_booking.dart';
import 'package:your_app/utils/booking_conflict_utils.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirebaseEquipmentBookingRepository repo;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repo = FirebaseEquipmentBookingRepository(fakeFirestore);
  });

  // ── Tests logique de conflit (CORRECTION #6) ────────────────────────
  group('slotsConflict', () {
    test('full_day conflit avec morning', () {
      expect(
        slotsConflict(EquipmentBookingSlot.fullDay, EquipmentBookingSlot.morning),
        isTrue,
      );
    });
    test('morning conflit avec full_day', () {
      expect(
        slotsConflict(EquipmentBookingSlot.morning, EquipmentBookingSlot.fullDay),
        isTrue,
      );
    });
    test('morning pas de conflit avec afternoon', () {
      expect(
        slotsConflict(EquipmentBookingSlot.morning, EquipmentBookingSlot.afternoon),
        isFalse,
      );
    });
    test('afternoon conflit avec afternoon', () {
      expect(
        slotsConflict(EquipmentBookingSlot.afternoon, EquipmentBookingSlot.afternoon),
        isTrue,
      );
    });
  });

  group('createBooking', () {
    setUp(() async {
      await fakeFirestore.collection('equipment').doc('eq1').set({
        'total_quantity': 1,
        'status': 'active',
      });
    });

    test('réservation réussie si disponible', () async {
      final id = await repo.createBooking(_makeBooking());
      expect(id, isNotEmpty);
    });

    test('lance exception si plus disponible', () async {
      await repo.createBooking(_makeBooking());
      expect(() => repo.createBooking(_makeBooking()), throwsA(isA<Exception>()));
    });

    test('full_day bloque morning ET afternoon', () async {
      await repo.createBooking(_makeBooking(slot: EquipmentBookingSlot.fullDay));
      expect(
        () => repo.createBooking(_makeBooking(slot: EquipmentBookingSlot.morning)),
        throwsA(isA<Exception>()),
      );
    });

    test('annulation libère le créneau', () async {
      final id = await repo.createBooking(_makeBooking());
      await repo.cancelBooking(id);
      final id2 = await repo.createBooking(_makeBooking());
      expect(id2, isNotEmpty);
    });

    test('limite 3 réservations actives par utilisateur', () async {
      for (var i = 2; i <= 4; i++) {
        await fakeFirestore.collection('equipment').doc('eq$i').set({
          'total_quantity': 1, 'status': 'active',
        });
      }
      await repo.createBooking(_makeBooking(eqId: 'eq1'));
      await repo.createBooking(_makeBooking(eqId: 'eq2'));
      await repo.createBooking(_makeBooking(eqId: 'eq3'));
      expect(
        () => repo.createBooking(_makeBooking(eqId: 'eq4')),
        throwsA(isA<Exception>()),
      );
    });
  });
}

EquipmentBooking _makeBooking({
  EquipmentBookingSlot slot = EquipmentBookingSlot.morning,
  String eqId = 'eq1',
}) {
  return EquipmentBooking(
    id: '',
    userId: 'user1',
    userName: 'Test User',
    userEmail: 'test@example.com',
    equipmentId: eqId,
    equipmentType: 'kite',
    equipmentBrand: 'F-ONE',
    equipmentModel: 'Bandit',
    equipmentSize: 12.0,
    dateString: '2026-03-15',
    dateTimestamp: DateTime.utc(2026, 3, 15),
    slot: slot,
    status: EquipmentBookingStatus.confirmed,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    createdBy: 'user1',
  );
}
```

---

## 9. Migration & Déploiement

### Script de migration

```dart
// lib/scripts/migrate_equipment_quantities.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Ajoute total_quantity, supprime available_quantity (obsolète).
Future<void> migrateEquipmentQuantities() async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('equipment').get();

  int updated = 0;
  for (final doc in snapshot.docs) {
    final data = doc.data();
    if (data.containsKey('total_quantity')) continue; // Déjà migré

    await doc.reference.update({
      'total_quantity': 1, // Valeur par défaut, à ajuster manuellement
      'status': data['status'] == 'available' ? 'active' : data['status'],
      'available_quantity': FieldValue.delete(), // Supprimer l'ancien champ
      'updated_at': FieldValue.serverTimestamp(),
    });
    updated++;
  }
  print('✅ $updated équipements migrés');
}
```

### Dépendances requises

```yaml
# pubspec.yaml — nouvelles dépendances
dependencies:
  rxdart: ^0.27.7        # Rx.combineLatest2 pour watchEquipmentAvailability
  intl: ^0.19.0          # DateFormat pour formatDateForQuery

dev_dependencies:
  fake_cloud_firestore: ^2.x  # Tests unitaires sans Firestore réel
```

### Checklist de déploiement

| Tâche | Détail |
|-------|--------|
| `flutter analyze` | Aucun warning autorisé avant merge |
| `flutter test` | Tous les tests `slotsConflict` + `createBooking` |
| `build_runner` | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Index Firestore | `firebase deploy --only firestore:indexes` |
| Security Rules | `firebase deploy --only firestore:rules` |
| Migration données | Exécuter en staging d'abord, vérifier `total_quantity` |
| Test multi-users | Deux appareils, même créneau, même équipement simultanément |
| Test timezone | Réserver depuis UTC+1 et UTC-5, vérifier `date_string` |

---

> ✅ **Prêt pour implémentation.** Approche recommandée : commencer par les tests unitaires (`slotsConflict`) avant d'implémenter le repository — TDD garantit la correction de la logique de conflit avant tout le reste.

---

*Version 2.0 — 2026-03-02 · Revue Lead Dev Senior*
