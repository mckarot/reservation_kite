# 🎯 Implémentation de la Location de Matériel - Plan Détaillé

**Document de référence pour l'implémentation de la réservation de matériel seul (sans cours)**

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble](#1-vue-densemble)
2. [Prérequis](#2-prérequis)
3. [Modifications du schéma Firestore](#3-modifications-du-schéma-firestore)
4. [Modèles de données](#4-modèles-de-données)
5. [Repositories & Data Sources](#5-repositories--data-sources)
6. [State Management (Riverpod)](#6-state-management-riverpod)
7. [Écrans UI](#7-écrans-ui)
8. [Règles métier](#8-règles-métier)
9. [Tests et validation](#9-tests-et-validation)
10. [Checklist de déploiement](#10-checklist-de-déploiement)

---

## 1. VUE D'ENSEMBLE

### Objectif
Permettre aux élèves de **réserver uniquement du matériel** (kite, foil, voile, harnais) sans cours, pour :
- ✅ **Matin** (08h-12h)
- ✅ **Après-midi** (13h-18h)
- ✅ **Journée entière** (08h-18h)

Et permettre aux moniteurs de **réserver le matériel pour l'élève** lors de la validation d'une séance.

### ⚠️ POINTS CRITIQUES À VALIDER AVANT IMPLÉMENTATION

#### 1. Gestion de la remise à zéro des stocks

**Problème :** Si tu utilises un simple compteur `available_quantity` sur `equipment`, comment le matériel redevient-il disponible le lendemain ?

**Deux approches possibles :**

| Approche | Description | Avantages | Inconvénients |
|----------|-------------|-----------|---------------|
| **A. Calcul dynamique** (RECOMMANDÉ) | `disponibilité = total_quantity - bookings_actifs pour date X` | ✅ Pas de script de reset<br>✅ Temps réel précis<br>✅ Historique complet | ❌ Requêtes plus complexes<br>❌ Performance à optimiser |
| **B. Compteur + Reset nightly** | `available_quantity` décrémenté + Cloud Function reset à 00h | ✅ Requêtes simples<br>✅ Rapide | ❌ Script Cron requis<br>❌ Risque de bug si reset échoue |

**Recommandation Lead Developer :** Utiliser l'**approche A** (calcul dynamique) pour plus de robustesse.

**Implémentation recommandée :**

```dart
// Au lieu de stocker available_quantity, on calcule :
Future<int> getAvailableQuantity({
  required String equipmentId,
  required DateTime date,
  required EquipmentBookingSlot slot,
}) async {
  final bookings = await _firestore
      .collection('equipment_bookings')
      .where('equipment_id', isEqualTo: equipmentId)
      .where('date', isEqualTo: date)
      .where('status', whereIn: ['confirmed', 'completed'])
      .get();

  int bookedSlots = 0;
  for (final booking in bookings.docs) {
    final slotData = booking.data()['slot'] as String;
    if (slotData == 'full_day' || slotData == slot.name) {
      bookedSlots++;
    }
  }

  final equipment = await _firestore.collection('equipment').doc(equipmentId).get();
  final totalQty = equipment.data()?['total_quantity'] ?? 0;

  return totalQty - bookedSlots;
}
```

#### 2. Gestion des fuseaux horaires

**Problème :** Un `DateTime` stocké avec `FieldValue.serverTimestamp()` est en UTC. Si un utilisateur à Paris réserve pour "15 mars 2026", cela peut devenir "14 mars 2026 23:00 UTC" et créer des conflits.

**Solution recommandée :**

| Type de donnée | Format | Exemple |
|----------------|--------|---------|
| **Date uniquement** (jour) | `String ISO-8601` | `"2026-03-15"` |
| **Timestamp complet** | `FieldValue.serverTimestamp()` | `Timestamp(2026-03-15T08:00:00Z)` |

**Pourquoi ?** Les requêtes Firestore `.where('date', isEqualTo: date)` comparent des timestamps précis. Une différence de fuseau peut faire rater la réservation.

**Implémentation recommandée :**

```dart
// ✅ BON : Stocker la date en tant que string ISO-8601 (sans time)
final booking = {
  'date_string': '2026-03-15',  // Requêtes faciles
  'date_timestamp': Timestamp.fromDate(DateTime.utc(2026, 3, 15)),  // Pour les indexes
  'slot': 'morning',
  // ...
};

// Conversion utilitaire
String formatDateForQuery(DateTime date) {
  // Force UTC pour éviter les décalages
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
```

---

### Architecture cible (MISE À JOUR)
```
┌─────────────────────────────────────────────────────────────┐
│  Élève / Moniteur                                           │
│         ↓                                                   │
│  EquipmentBookingScreen                                     │
│         ↓                                                   │
│  EquipmentBookingNotifier                                   │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ Firestore Transactions                       │           │
│  │ → equipment_bookings/{id}                    │           │
│  │ → equipment/{id}.available_quantity (décret) │           │
│  │ → sessions/{id}.equipment (si cours)         │           │
│  └──────────────────────────────────────────────┘           │
│         ↓                                                   │
│  ┌──────────────────────────────────────────────┐           │
│  │ Real-time Updates                            │           │
│  │ → StreamBuilder pour disponibilité           │           │
│  └──────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

### Coût estimé
- **Firestore** : Inclus dans le plan gratuit (50k lectures/jour)
- **Cloud Functions** : Optionnel pour validations complexes

---

## 2. PRÉREQUIS

### Comptes nécessaires
- [ ] Compte Firebase actif
- [ ] Accès à la Firebase Console
- [ ] Projet Flutter fonctionnel

### Connaissances requises
- [ ] Bases de Flutter/Dart
- [ ] Compréhension de Riverpod
- [ ] Familiarité avec Firestore Transactions

---

## 3. MODIFICATIONS DU SCHÉMA FIRESTORE

### Collection : `equipment` (modification)

**Actuellement :**
```
equipment/{id}
├── type: "kite" | "foil" | "board" | "harness"
├── brand: "F-ONE"
├── model: "Bandit"
├── size: 12
├── status: "available" | "rented" | "maintenance"
└── ...
```

**Nouveau schéma :**
```
equipment/{id}
├── type: "kite" | "foil" | "board" | "harness"
├── brand: "F-ONE"
├── model: "Bandit"
├── size: 12
├── status: "active" | "maintenance" | "retired"
├── total_quantity: 4                    ← NOUVEAU
└── updated_at: FieldValue.serverTimestamp()
```

**⚠️ IMPORTANT :** `available_quantity` n'est **PAS stocké** dans Firestore. Il est **calculé dynamiquement** à chaque requête pour éviter les scripts de reset nightly.

### Nouvelle collection : `equipment_bookings`

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
├── equipment_size: 12
├── date_string: "2026-03-15"          ← NOUVEAU (ISO-8601, sans timezone)
├── date_timestamp: Timestamp          ← Pour index Firestore (UTC)
├── slot: "morning" | "afternoon" | "full_day"
├── status: "confirmed" | "cancelled" | "completed"
├── created_at: FieldValue.serverTimestamp()
├── updated_at: FieldValue.serverTimestamp()
├── created_by: "uid_createur"
├── session_id: "session_456" | null   ← Si lié à un cours
└── notes: "..." | null
```

### ⚠️ CONVENTION DE DATE (CRITIQUE)

**Règle :** Toujours stocker les dates en **UTC** pour éviter les décalages de fuseau horaire.

```dart
// ✅ BON : Conversion UTC systématique
DateTime date = DateTime(2026, 3, 15);  // Local
DateTime utcDate = DateTime.utc(date.year, date.month, date.day);  // UTC

// Stockage
'date_string': formatDateForQuery(utcDate),  // "2026-03-15"
'date_timestamp': Timestamp.fromDate(utcDate),

// Requête
final startOfDay = DateTime.utc(date.year, date.month, date.day);
final endOfDay = startOfDay.add(const Duration(days: 1));
```

### Utilitaire de formatage de date

**Nouveau fichier :** `lib/utils/date_utils.dart`

```dart
import 'package:intl/intl.dart';

/// Formate une date en string ISO-8601 (YYYY-MM-DD) en UTC
String formatDateForQuery(DateTime date) {
  final utcDate = DateTime.utc(date.year, date.month, date.day);
  return DateFormat('yyyy-MM-dd').format(utcDate);
}

/// Parse un string ISO-8601 en DateTime UTC
DateTime parseDateFromQuery(String dateString) {
  final parts = dateString.split('-');
  return DateTime.utc(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

/// Vérifie si deux dates sont égales (même jour, mois, année)
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
```

### Index composites requis

**Fichier :** `firestore.indexes.json`

```json
{
  "indexes": [
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "user_id", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "date", "order": "ASCENDING" },
        { "fieldPath": "slot", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "equipment_id", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "equipment_bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "ASCENDING" }
      ]
    }
  ]
}
```

**Déploiement :**
```bash
firebase deploy --only firestore:indexes
```

---

## 4. MODÈLES DE DONNÉES

### Étape 4.1 : Créer le modèle `EquipmentBooking`

**Nouveau fichier :** `lib/domain/models/equipment_booking.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_booking.freezed.dart';
part 'equipment_booking.g.dart';

enum EquipmentBookingSlot {
  morning,
  afternoon,
  fullDay,
}

enum EquipmentBookingStatus {
  confirmed,
  cancelled,
  completed,
}

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
    required DateTime date,
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

**Génération :**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Étape 4.2 : Mettre à jour le modèle `Equipment`

**Fichier :** `lib/domain/models/equipment.dart`

```dart
@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    // ... champs existants ...
    required int totalQuantity,      ← AJOUTER
    required int availableQuantity,  ← AJOUTER
    // ... reste des champs ...
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}
```

**Génération :**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 5. REPOSITORIES & DATA SOURCES

### Étape 5.1 : Interface du repository

**Nouveau fichier :** `lib/domain/repositories/equipment_booking_repository.dart`

```dart
import '../models/equipment_booking.dart';

abstract class EquipmentBookingRepository {
  /// Créer une réservation de matériel
  Future<String> createBooking(EquipmentBooking booking);

  /// Annuler une réservation
  Future<void> cancelBooking(String bookingId);

  /// Compléter une réservation (après utilisation)
  Future<void> completeBooking(String bookingId);

  /// Récupérer les réservations d'un utilisateur
  Future<List<EquipmentBooking>> getUserBookings(String userId);

  /// Récupérer les réservations par date
  Future<List<EquipmentBooking>> getBookingsByDate(DateTime date);

  /// Récupérer les réservations d'un équipement
  Future<List<EquipmentBooking>> getEquipmentBookings(String equipmentId);

  /// Stream des réservations en temps réel
  Stream<List<EquipmentBooking>> watchUserBookings(String userId);
}
```

### Étape 5.2 : Implémentation Firebase

**Nouveau fichier :** `lib/data/repositories/firebase_equipment_booking_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/date_utils.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/repositories/equipment_booking_repository.dart';

class FirebaseEquipmentBookingRepository implements EquipmentBookingRepository {
  final FirebaseFirestore _firestore;

  FirebaseEquipmentBookingRepository(this._firestore);

  /// Calcule la quantité disponible pour un équipement à une date/créneau donné
  Future<int> getAvailableQuantity({
    required String equipmentId,
    required DateTime date,
    required EquipmentBookingSlot slot,
  }) async {
    // Récupérer le total
    final equipmentDoc = await _firestore.collection('equipment').doc(equipmentId).get();
    final totalQty = equipmentDoc.data()?['total_quantity'] ?? 0;

    // Compter les réservations actives pour cette date
    final dateString = formatDateForQuery(date);
    
    final bookingsSnapshot = await _firestore
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    int bookedSlots = 0;
    for (final doc in bookingsSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final bookingSlot = EquipmentBookingSlot.values.firstWhere(
        (e) => e.name == data['slot'],
      );

      // Journée complète bloque matin ET après-midi
      if (bookingSlot == EquipmentBookingSlot.fullDay) {
        bookedSlots++;
      } else if (bookingSlot == slot) {
        bookedSlots++;
      }
    }

    return totalQty - bookedSlots;
  }

  @override
  Future<String> createBooking(EquipmentBooking booking) async {
    // 1. Vérifier la disponibilité (calcul dynamique)
    final availableQty = await getAvailableQuantity(
      equipmentId: booking.equipmentId,
      date: booking.date,
      slot: booking.slot,
    );

    if (availableQty <= 0) {
      throw Exception('Matériel non disponible pour ce créneau');
    }

    // 2. Créer la réservation (pas besoin de transaction pour décrémenter)
    final bookingRef = _firestore.collection('equipment_bookings').doc();
    await bookingRef.set(booking.toJson());

    return bookingRef.id;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final bookingRef = _firestore.collection('equipment_bookings').doc(bookingId);
    await bookingRef.update({
      'status': 'cancelled',
      'updated_at': FieldValue.serverTimestamp(),
    });
    // Pas besoin de réincrémenter : le calcul dynamique le gère automatiquement
  }

  @override
  Future<void> completeBooking(String bookingId) async {
    final bookingRef = _firestore.collection('equipment_bookings').doc(bookingId);
    await bookingRef.update({
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
        .map((doc) => EquipmentBooking.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<EquipmentBooking>> getBookingsByDate(DateTime date) async {
    final dateString = formatDateForQuery(date);
    final startOfDay = DateTime.utc(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('equipment_bookings')
        .where('date_string', isEqualTo: dateString)
        .orderBy('date_timestamp')
        .get();

    return snapshot.docs
        .map((doc) => EquipmentBooking.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<EquipmentBooking>> getEquipmentBookings(String equipmentId) async {
    final snapshot = await _firestore
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .orderBy('date_timestamp', descending: true)
        .limit(100)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentBooking.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<EquipmentBooking>> watchUserBookings(String userId) {
    return _firestore
        .collection('equipment_bookings')
        .where('user_id', isEqualTo: userId)
        .orderBy('date_timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentBooking.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Stream de disponibilité en temps réel
  Stream<int> watchAvailableQuantity({
    required String equipmentId,
    required DateTime date,
    required EquipmentBookingSlot slot,
  }) {
    final dateString = formatDateForQuery(date);
    
    return _firestore
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .snapshots()
        .asyncMap((snapshot) async {
      final equipmentDoc = await _firestore.collection('equipment').doc(equipmentId).get();
      final totalQty = equipmentDoc.data()?['total_quantity'] ?? 0;

      int bookedSlots = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final bookingSlot = EquipmentBookingSlot.values.firstWhere(
          (e) => e.name == data['slot'],
        );

        if (bookingSlot == EquipmentBookingSlot.fullDay || bookingSlot == slot) {
          bookedSlots++;
        }
      }

      return totalQty - bookedSlots;
    });
  }
}
```

### Étape 5.3 : Provider du repository

**Fichier :** `lib/data/providers/repository_providers.dart`

```dart
// ... imports existants ...
import '../repositories/firebase_equipment_booking_repository.dart';
import '../../domain/repositories/equipment_booking_repository.dart';

@Riverpod(keepAlive: true)
EquipmentBookingRepository equipmentBookingRepositoryRef(_) {
  return FirebaseEquipmentBookingRepository(FirebaseFirestore.instance);
}
```

---

## 6. STATE MANAGEMENT (RIVERPOD)

### Étape 6.1 : Créer le notifier de réservation

**Nouveau fichier :** `lib/presentation/providers/equipment_booking_notifier.dart`

```dart
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
    return ref.watch(equipmentBookingRepositoryProvider).getUserBookings(userId);
  }

  /// Créer une réservation
  Future<String?> createBooking({
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

    final booking = EquipmentBooking(
      id: '',  // Généré par Firestore
      userId: user.id,
      userName: user.displayName,
      userEmail: user.email,
      equipmentId: equipmentId,
      equipmentType: equipmentType,
      equipmentBrand: equipmentBrand,
      equipmentModel: equipmentModel,
      equipmentSize: equipmentSize,
      date: date,
      slot: slot,
      status: EquipmentBookingStatus.confirmed,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: user.id,
      sessionId: sessionId,
      notes: notes,
    );

    final result = await AsyncValue.guard(
      () => ref.read(equipmentBookingRepositoryProvider).createBooking(booking),
    );

    return result.fold(
      (bookingId) {
        // Rafraîchir la liste
        ref.invalidateSelf();
        return bookingId;
      },
      (error) {
        throw error;
      },
    );
  }

  /// Annuler une réservation
  Future<void> cancelBooking(String bookingId) async {
    final result = await AsyncValue.guard(
      () => ref.read(equipmentBookingRepositoryProvider).cancelBooking(bookingId),
    );

    result.fold(
      (_) => ref.invalidateSelf(),
      (error) => throw error,
    );
  }
}
```

### Étape 6.2 : Notifier pour la disponibilité

**Nouveau fichier :** `lib/presentation/providers/equipment_availability_notifier.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment.dart';
import 'repository_providers.dart';

part 'equipment_availability_notifier.g.dart';

@riverpod
class EquipmentAvailabilityNotifier extends _$EquipmentAvailabilityNotifier {
  @override
  Stream<List<Equipment>> build() {
    return FirebaseFirestore.instance
        .collection('equipment')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Equipment.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Récupérer un équipement spécifique
  Stream<Equipment?> watchEquipment(String equipmentId) {
    return FirebaseFirestore.instance
        .collection('equipment')
        .doc(equipmentId)
        .snapshots()
        .map((doc) => doc.exists
            ? Equipment.fromJson(doc.data() as Map<String, dynamic>)
            : null);
  }
}
```

---

## 7. ÉCRANS UI

### Étape 7.1 : Écran de réservation de matériel

**Nouveau fichier :** `lib/presentation/screens/equipment_booking_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/equipment_booking.dart';
import '../../l10n/app_localizations.dart';
import '../providers/equipment_booking_notifier.dart';
import '../providers/equipment_availability_notifier.dart';
import '../providers/auth_state_provider.dart';
import '../providers/theme_notifier.dart';
import '../../domain/models/app_theme_settings.dart';

class EquipmentBookingScreen extends ConsumerStatefulWidget {
  const EquipmentBookingScreen({super.key});

  @override
  ConsumerState<EquipmentBookingScreen> createState() => _EquipmentBookingScreenState();
}

class _EquipmentBookingScreenState extends ConsumerState<EquipmentBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  EquipmentBookingSlot _selectedSlot = EquipmentBookingSlot.morning;
  String? _selectedEquipmentId;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    final equipmentAsync = ref.watch(equipmentAvailabilityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.equipmentRental),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Sélecteur de date
          _buildDateSelector(l10n),

          // Sélecteur de créneau
          _buildSlotSelector(l10n),

          // Liste des équipements disponibles
          Expanded(
            child: equipmentAsync.when(
              data: (equipment) => _buildEquipmentList(equipment, l10n),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectDate,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('EEEE dd MMMM', 'fr_FR').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlotSelector(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _SlotChip(
              label: l10n.morning,
              icon: Icons.sunrise,
              isSelected: _selectedSlot == EquipmentBookingSlot.morning,
              onTap: () => setState(() => _selectedSlot = EquipmentBookingSlot.morning),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SlotChip(
              label: l10n.afternoon,
              icon: Icons.sunset,
              isSelected: _selectedSlot == EquipmentBookingSlot.afternoon,
              onTap: () => setState(() => _selectedSlot = EquipmentBookingSlot.afternoon),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SlotChip(
              label: l10n.fullDay,
              icon: Icons.wb_sunny,
              isSelected: _selectedSlot == EquipmentBookingSlot.fullDay,
              onTap: () => setState(() => _selectedSlot = EquipmentBookingSlot.fullDay),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentList(List<Equipment> equipment, AppLocalizations l10n) {
    // Filtrer par type si nécessaire
    final kites = equipment.where((e) => e.type == 'kite').toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: kites.length,
      itemBuilder: (context, index) {
        final eq = kites[index];
        final isAvailable = eq.availableQuantity > 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isAvailable
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.errorContainer,
              child: Icon(
                Icons.kitesurfing,
                color: isAvailable
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            title: Text('${eq.brand} ${eq.model}'),
            subtitle: Text(
              '${eq.size}m² - ${eq.availableQuantity}/${eq.totalQuantity} ${l10n.available}',
              style: TextStyle(
                color: isAvailable
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: isAvailable
                ? ElevatedButton(
                    onPressed: () => _confirmBooking(eq),
                    child: Text(l10n.rentButton),
                  )
                : const Chip(
                    label: Text('Indisponible'),
                    backgroundColor: Colors.grey,
                  ),
          ),
        );
      },
    );
  }

  Future<void> _confirmBooking(Equipment eq) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmBooking),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${eq.brand} ${eq.model} - ${eq.size}m²'),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('dd/MM/yyyy').format(_selectedDate)} - ${_getSlotName(l10n)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirmButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(equipmentBookingNotifierProvider(ref.read(currentUserProvider).value!.id).notifier).createBooking(
        equipmentId: eq.id,
        equipmentType: eq.type,
        equipmentBrand: eq.brand,
        equipmentModel: eq.model,
        equipmentSize: eq.size,
        date: _selectedDate,
        slot: _selectedSlot,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.bookingConfirmed),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _getSlotName(AppLocalizations l10n) {
    switch (_selectedSlot) {
      case EquipmentBookingSlot.morning:
        return l10n.morning;
      case EquipmentBookingSlot.afternoon:
        return l10n.afternoon;
      case EquipmentBookingSlot.fullDay:
        return l10n.fullDay;
    }
  }
}

class _SlotChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SlotChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Étape 7.2 : Intégration dans l'écran de réservation de cours

**Fichier :** `lib/presentation/screens/booking_screen.dart`

Ajouter une section "Réserver du matériel" dans le flux de réservation de cours.

---

## 8. RÈGLES MÉTIER

### 8.1 : Réservation par les élèves

| Règle | Description |
|-------|-------------|
| **Créneaux** | Matin (08h-12h), Après-midi (13h-18h), Journée (08h-18h) |
| **Quantité** | 1 équipement = 1 créneau (2 pour journée complète) |
| **Limite** | Maximum 3 réservations actives par élève |
| **Annulation** | Possible jusqu'à 24h avant |
| **Pénalité** | 3 annulations tardives = blocage 7 jours |

### 8.2 : Réservation par les moniteurs

| Règle | Description |
|-------|-------------|
| **Lien session** | La réservation est liée à `session_id` |
| **Validation** | Matériel réservé quand la séance est validée |
| **Annulation** | Automatique si la séance est annulée |

### 8.3 : Gestion des quantités

```dart
// Exemple de logique métier
int calculateSlotsNeeded(EquipmentBookingSlot slot) {
  switch (slot) {
    case EquipmentBookingSlot.morning:
    case EquipmentBookingSlot.afternoon:
      return 1;
    case EquipmentBookingSlot.fullDay:
      return 2;  // Compte comme 2 réservations
  }
}
```

---

## 9. TESTS ET VALIDATION

### Checklist de test

#### Test 1 : Réservation élève
- [ ] Ouvrir l'écran de location de matériel
- [ ] Sélectionner une date
- [ ] Sélectionner un créneau (matin/après-midi/journée)
- [ ] Vérifier la disponibilité en temps réel
- [ ] Réserver un équipement
- [ ] ✅ La disponibilité affiche "3/4 disponibles" → "2/4 disponibles"
- [ ] ✅ La réservation apparaît dans l'historique
- [ ] ✅ La disponibilité se met à jour en temps réel (stream)

#### Test 2 : Conflit de réservation
- [ ] Ouvrir l'app sur 2 appareils différents
- [ ] Sélectionner le même équipement, même date, même créneau
- [ ] Réserver sur l'appareil 1
- [ ] Tenter de réserver sur l'appareil 2
- [ ] ✅ Erreur "Matériel non disponible" sur l'appareil 2
- [ ] ✅ La disponibilité est correcte sur les 2 appareils

#### Test 3 : Remise à zéro automatique (len demain)
- [ ] Réserver un équipement pour aujourd'hui
- [ ] ✅ Disponibilité décrémentée pour aujourd'hui
- [ ] Changer la date pour demain
- [ ] ✅ Disponibilité revenue à la normale (pas de reset manuel requis)

#### Test 4 : Fuseaux horaires
- [ ] Réserver depuis un appareil en UTC+1 (Paris)
- [ ] Vérifier la date stockée dans Firestore
- [ ] ✅ `date_string` = "2026-03-15" (ISO-8601)
- [ ] ✅ `date_timestamp` = UTC (pas de décalage)
- [ ] Ouvrir l'app depuis un appareil en UTC-5 (New York)
- [ ] ✅ La réservation apparaît à la bonne date

#### Test 5 : Réservation moniteur
- [ ] Valider une séance en tant que moniteur
- [ ] Sélectionner le matériel pour l'élève
- [ ] ✅ La réservation est créée avec `session_id`
- [ ] ✅ La disponibilité est décrémentée

#### Test 6 : Annulation
- [ ] Annuler une réservation élève
- [ ] ✅ La disponibilité incrémente automatiquement
- [ ] ✅ Le statut passe à "cancelled"

### Tests unitaires

**Fichier :** `test/repositories/equipment_booking_repository_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentBookingRepository', () {
    test('createBooking decrements available quantity', () async {
      // TODO: Implémenter avec mock_firestore
    });

    test('cancelBooking restores available quantity', () async {
      // TODO: Implémenter avec mock_firestore
    });

    test('createBooking throws if not enough quantity', () async {
      // TODO: Implémenter avec mock_firestore
    });
  });
}
```

---

## 10. CHECKLIST DE DÉPLOIEMENT

### Avant déploiement

- [ ] `flutter analyze` — aucun warning
- [ ] `flutter test` — tous les tests passent
- [ ] Modèles Freezed générés
- [ ] Index Firestore déployés
- [ ] Migration des équipements existants (ajouter `total_quantity`, `available_quantity`)

### Firebase Console

- [ ] Collection `equipment_bookings` créée
- [ ] Index composites déployés
- [ ] Règles de sécurité mises à jour

### Migration des données

**Script de migration :** `lib/scripts/migrate_equipment_quantities.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Migration pour ajouter total_quantity aux équipements existants
/// Note: available_quantity n'est plus stocké, il est calculé dynamiquement
Future<void> migrateEquipmentQuantities() async {
  final firestore = FirebaseFirestore.instance;
  
  final equipmentSnapshot = await firestore.collection('equipment').get();
  
  int updated = 0;
  for (final doc in equipmentSnapshot.docs) {
    await doc.reference.update({
      'total_quantity': 1,  // Valeur par défaut, à ajuster selon le matériel
      'updated_at': FieldValue.serverTimestamp(),
    });
    updated++;
  }
  
  print('$updated équipements migrés avec total_quantity');
  print('Note: available_quantity est maintenant calculé dynamiquement');
}
```

**Exécution :**
```bash
# Option 1: Via un script standalone
dart lib/scripts/migrate_equipment_quantities.dart

# Option 2: Via la console Flutter
flutter run --target=lib/scripts/migrate_equipment_quantities.dart
```

### Tests finaux

- [ ] Test sur appareil physique Android
- [ ] Test sur appareil physique iOS
- [ ] Test de réservation en temps réel (multi-utilisateurs)
- [ ] Test d'annulation
- [ ] Test de lien avec les sessions

### Documentation

- [ ] Mettre à jour `firestore_schema.md`
- [ ] Mettre à jour `README.md`
- [ ] Documenter les nouvelles règles métier

---

## 📞 SUPPORT & RESSOURCES

### Documentation officielle
- [Firestore Transactions](https://firebase.google.com/docs/firestore/manage-data/transactions)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)

###常见问题
| Problème | Solution |
|----------|----------|
| Quantité négative | Vérifier les transactions Firestore |
| Réservations en double | Utiliser des transactions atomiques |
| UI ne se met pas à jour | Utiliser `StreamBuilder` ou `ref.watch` |

---

## 📝 NOTES IMPORTANTES

### Respect des conventions du projet
- Utiliser **uniquement des diffs** (jamais de fichiers complets)
- Respecter l'architecture **Clean Architecture** (data/domain/presentation)
- Utiliser `FieldValue.serverTimestamp()` pour Firestore
- Ajouter `if (!mounted)` après les `await` avec BuildContext
- Retourner des `AsyncValue` dans les Providers
- **Transactions obligatoires** pour les écritures de quantités

### Performance
- Utiliser `.limit()` sur toutes les requêtes Firestore
- Index composites pour les requêtes fréquentes
- Streams pour le temps réel (disponibilité matériel)

### Sécurité
- Règles Firestore pour vérifier les permissions
- Validation côté serveur (Cloud Functions) pour les opérations critiques

---

**Dernière mise à jour :** 2026-03-02
**Version du document :** 1.0
**Statut :** Prêt pour implémentation
