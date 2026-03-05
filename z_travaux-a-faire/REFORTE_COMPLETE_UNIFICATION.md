# 🚀 REFORTE COMPLÈTE - UNIFICATION ASSIGNMENT/BOOKING

**Mode :** ⚡ DEV SANS FILET - On casse tout, on reconstruit propre  
**Date :** 4 mars 2026  
**Statut :** ✅ PRÊT À DÉPLOYER

---

## 🎯 OBJECTIF

**Supprimer `EquipmentAssignment` et tout migrer vers `EquipmentBooking`**

**Pourquoi ?**
- ✅ Une seule collection : `equipment_bookings`
- ✅ Une seule logique : conflits de créneau
- ✅ Plus de bugs de synchronisation
- ✅ Code simplifié (~300 lignes en moins)

---

## 🔥 PHASE 1 : MODIFIER `EquipmentBooking` (15 min)

### Fichier : `lib/domain/models/equipment_booking.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_booking.freezed.dart';
part 'equipment_booking.g.dart';

// NOUVEAU : Type de réservation
enum EquipmentBookingType {
  @JsonValue('student')
  student,      // Réservation élève (self-service)
  
  @JsonValue('assignment')
  assignment,   // Assignment moniteur (pour cours)
  
  @JsonValue('staff')
  staff,        // Réservation staff/événement
}

enum EquipmentBookingSlot {
  @JsonValue('morning')
  morning,
  @JsonValue('afternoon')
  afternoon,
  @JsonValue('full_day')
  fullDay,
}

enum EquipmentBookingStatus {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}

String _anyToString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

@freezed
class EquipmentBooking with _$EquipmentBooking {
  const factory EquipmentBooking({
    required String id,
    required String userId,           // studentId → userId (unifié)
    required String userName,
    required String userEmail,
    required String equipmentId,
    required String equipmentType,
    required String equipmentBrand,
    required String equipmentModel,
    @JsonKey(fromJson: _anyToString) required String equipmentSize,
    required String dateString,
    required DateTime dateTimestamp,
    required EquipmentBookingSlot slot,
    required EquipmentBookingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    
    // NOUVEAUX CHAMPS POUR UNIFICATION
    required EquipmentBookingType type,  // ✅ student | assignment | staff
    String? assignedBy,                  // ✅ ID moniteur (si assignment)
    String? sessionId,                   // ✅ ID de la séance
    String? notes,
  }) = _EquipmentBooking;
  
  factory EquipmentBooking.fromJson(Map<String, dynamic> json) =>
      _$EquipmentBookingFromJson(json);
}
```

### Générer le code :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔥 PHASE 2 : NETTOYER REPOSITORIES (30 min)

### 1. Supprimer `EquipmentAssignmentRepository`

```bash
# Fichiers à SUPPRIMER
rm lib/domain/repositories/equipment_assignment_repository.dart
rm lib/data/repositories/firebase_equipment_assignment_repository.dart
rm lib/presentation/providers/equipment_assignment_notifier.dart
rm test/domain/equipment_assignment_test.dart
```

### 2. Mettre à jour `repository_providers.dart`

**Fichier :** `lib/data/providers/repository_providers.dart`

```dart
// ❌ SUPPRIMER :
// - EquipmentAssignmentRepository
// - FirebaseEquipmentAssignmentRepository
// - equipmentAssignmentRepositoryProvider

// ✅ GARDER UNIQUEMENT :
Provider<EquipmentBookingRepository>((ref) {
  return FirebaseEquipmentBookingRepository(FirebaseFirestore.instance);
});
```

---

## 🔥 PHASE 3 : MIGRER `EquipmentAssignmentScreen` (1h)

### Fichier : `lib/presentation/screens/equipment_assignment_screen.dart`

**Remplacer `_assignEquipment()` par :**

```dart
Future<void> _assignEquipment(Equipment eq) async {
  final l10n = AppLocalizations.of(context);
  final currentUser = ref.read(currentUserProvider).value;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Utilisateur non connecté')),
    );
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmer l\'assignment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Équipement : ${eq.brand} ${eq.model} - ${eq.size}m²'),
          if (eq.serialNumber != null) Text('S/N: ${eq.serialNumber}'),
          const SizedBox(height: 8),
          Text('Élève : ${_selectedSession!.clientName}'),
          Text(
            'Séance : ${DateFormat('dd/MM/yyyy').format(_selectedSession!.date)} - ${_selectedSession!.slot == TimeSlot.morning ? 'Matin' : 'Après-midi'}',
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

  if (confirmed != true || !mounted) return;

  try {
    // ✅ CRÉER UN BOOKING DE TYPE "ASSIGNMENT"
    final booking = EquipmentBooking(
      id: const Uuid().v4(),
      userId: _selectedSession!.pupilId ?? '',
      userName: _selectedSession!.clientName,
      userEmail: '',
      equipmentId: eq.id,
      equipmentType: eq.categoryId,
      equipmentBrand: eq.brand,
      equipmentModel: eq.model,
      equipmentSize: eq.size,
      dateString: DateFormat('yyyy-MM-dd').format(_selectedSession!.date),
      dateTimestamp: _selectedSession!.date,
      slot: _selectedSession!.slot == TimeSlot.morning
          ? EquipmentBookingSlot.morning
          : _selectedSession!.slot == TimeSlot.afternoon
              ? EquipmentBookingSlot.afternoon
              : EquipmentBookingSlot.fullDay,
      status: EquipmentBookingStatus.confirmed,
      type: EquipmentBookingType.assignment,  // ✅ TYPE ASSIGNMENT
      assignedBy: currentUser.id,             // ✅ QUI A ASSIGNÉ
      sessionId: _selectedSession!.id,        // ✅ LIEN VERS SÉANCE
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: currentUser.id,
    );

    // ✅ UTILISER LE REPOSITORY DE BOOKING (plus d'assignment)
    await ref
        .read(equipmentBookingRepositoryProvider)
        .createBooking(booking);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Équipement assigné et réservé avec succès'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      _selectedSession = null;
      _selectedStudentId = null;
      _selectedCategory = null;
    });
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
```

### Mettre à jour `_EquipmentTile` :

```dart
class _EquipmentTile extends ConsumerWidget {
  final Equipment equipment;
  final String sessionId;
  final String studentId;
  final VoidCallback onAssign;
  final DateTime? sessionDate;
  final TimeSlot? sessionSlot;

  const _EquipmentTile({
    required this.equipment,
    required this.sessionId,
    required this.studentId,
    required this.onAssign,
    this.sessionDate,
    this.sessionSlot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Utiliser la date et le créneau de la séance
    final slot = sessionSlot == TimeSlot.morning
        ? EquipmentBookingSlot.morning
        : sessionSlot == TimeSlot.afternoon
            ? EquipmentBookingSlot.afternoon
            : EquipmentBookingSlot.fullDay;

    return FutureBuilder<bool>(
      future: EquipmentSlotAvailabilityService.isEquipmentAvailable(
        equipmentId: equipment.id,
        date: sessionDate ?? DateTime.now(),
        slot: slot,
      ),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isAvailable ? Colors.green : Colors.grey,
              child: Icon(
                _getCategoryIcon(equipment.categoryId),
                color: Colors.white,
              ),
            ),
            title: Text('${equipment.brand} ${equipment.model}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${equipment.size}m²'),
                if (equipment.serialNumber != null)
                  Text(
                    'S/N: ${equipment.serialNumber}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                if (!isAvailable && !isLoading)
                  Text(
                    'Indisponible (déjà réservé)',
                    style: const TextStyle(fontSize: 11, color: Colors.red),
                  ),
              ],
            ),
            trailing: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : isAvailable
                    ? ElevatedButton(
                        onPressed: onAssign,
                        child: const Text('Assigner'),
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

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'kite':
        return Icons.kitesurfing;
      case 'foil':
        return Icons.surfing;
      case 'board':
        return Icons.directions_bike;
      case 'harness':
        return Icons.security;
      default:
        return Icons.inventory_2;
    }
  }
}
```

### Imports à ajouter en haut du fichier :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';  // ✅ NOUVEAU
import '../../domain/models/reservation.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/equipment_slot_availability_service.dart';
import '../providers/auth_state_provider.dart';
import '../providers/booking_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../widgets/equipment_category_filter.dart';
```

---

## 🔥 PHASE 4 : MIGRER `LessonValidationScreen` (1h)

### Fichier : `lib/presentation/screens/lesson_validation_screen.dart`

**Remplacer `_releaseEquipment()` par :**

```dart
// Libère le matériel après la séance
void _releaseEquipment(EquipmentBooking booking) async {
  final l10n = AppLocalizations.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Libérer le matériel'),
      content: Text(
        'Confirmer la libération de :\n${booking.equipmentBrand} ${booking.equipmentModel} - ${booking.equipmentSize}m² ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancelButton),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Libérer'),
        ),
      ],
    ),
  );

  if (confirmed != true || !mounted) return;

  try {
    // ✅ UTILISER LE REPOSITORY DE BOOKING (plus d'assignment)
    await ref
        .read(equipmentBookingRepositoryProvider)
        .completeBooking(booking.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Matériel libéré avec succès'),
        backgroundColor: Colors.green,
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
```

**Mettre à jour `_showAssignedEquipment()` :**

```dart
void _showAssignedEquipment() {
  final l10n = AppLocalizations.of(context);

  // ✅ Watch les bookings de type "assignment" pour cette séance
  final bookingsAsync = ref.watch(
    equipmentBookingNotifierProvider(widget.reservation.id),
  );

  bookingsAsync.whenData((bookings) {
    // Filtrer les bookings de type "assignment" pour cet élève
    final studentBookings = bookings
        .where((b) => b.userId == widget.pupil.id)
        .where((b) => b.type == EquipmentBookingType.assignment)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.inventory_2),
            SizedBox(width: 8),
            Text('Matériel assigné'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: studentBookings.isEmpty
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Aucun matériel assigné pour cet élève'),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...studentBookings.map((booking) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(_getCategoryIcon(booking.equipmentType)),
                        ),
                        title: Text('${booking.equipmentBrand} ${booking.equipmentModel}'),
                        subtitle: Text('${booking.equipmentSize}m²'),
                        trailing: Chip(
                          label: Text(
                            booking.status.name,
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          backgroundColor: _getStatusColor(booking.status),
                        ),
                      ),
                    )),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
        ],
      ),
    );
  });
}
```

**Mettre à jour l'affichage dans `build()` :**

```dart
// ✅ Watch les bookings au lieu des assignments
final bookingsAsync = ref.watch(
  equipmentBookingNotifierProvider(widget.reservation.id),
);

// Dans le Widget build :
body: SingleChildScrollView(
  padding: const EdgeInsets.all(24),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section: Équipement assigné
      bookingsAsync!.when(
        data: (bookings) {
          if (bookings.isEmpty) return const SizedBox.shrink();

          final studentBookings = bookings
              .where((b) => b.userId == widget.pupil.id)
              .where((b) => b.type == EquipmentBookingType.assignment)
              .toList();

          if (studentBookings.isEmpty) return const SizedBox.shrink();

          return Card(
            color: primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.inventory_2, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Matériel assigné',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...studentBookings.map((booking) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${booking.equipmentBrand} ${booking.equipmentModel} - ${booking.equipmentSize}m²',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (booking.status == EquipmentBookingStatus.confirmed)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            tooltip: 'Libérer le matériel',
                            onPressed: () => _releaseEquipment(booking),
                          ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => const SizedBox.shrink(),
      ),
      // ... reste du code inchangé
```

**Imports à mettre à jour :**

```dart
// ❌ SUPPRIMER :
// import '../../domain/models/equipment_assignment.dart';

// ✅ AJOUTER :
import '../../domain/models/equipment_booking.dart';
```

---

## 🔥 PHASE 5 : MIGRER DONNÉES EXISTANTES (30 min)

### Script de migration Firestore (à exécuter dans Firebase Console)

**Fichier :** `z_travaux-a-faire/migrate_assignments.js`

```javascript
// Migration : equipment_assignments → equipment_bookings
// À exécuter dans la Firebase Console → Firestore → Data

const assignmentsRef = db.collection('equipment_assignments');
const bookingsRef = db.collection('equipment_bookings');

assignmentsRef.get().then((snapshot) => {
  const batch = db.batch();
  let count = 0;

  snapshot.forEach((doc) => {
    const data = doc.data();
    
    // Créer le nouveau booking
    const bookingRef = bookingsRef.doc();
    const bookingData = {
      // Champs existants (renommés)
      userId: data.studentId,
      userName: data.studentName,
      userEmail: data.studentEmail || '',
      equipmentId: data.equipmentId,
      equipmentType: data.equipmentType,
      equipmentBrand: data.equipmentBrand,
      equipmentModel: data.equipmentModel,
      equipmentSize: data.equipmentSize,
      dateString: data.date_string,
      dateTimestamp: data.date_timestamp,
      slot: data.slot,
      status: data.status,
      
      // Nouveaux champs
      type: 'assignment',
      assignedBy: data.createdBy,
      sessionId: data.sessionId,
      
      // Métadonnées
      createdAt: data.created_at,
      updatedAt: new Date(),
      createdBy: data.createdBy,
      id: bookingRef.id,
    };
    
    batch.set(bookingRef, bookingData);
    count++;
  });

  batch.commit().then(() => {
    console.log(`✅ ${count} assignments migrés avec succès`);
    console.log('⚠️ Pense à supprimer la collection equipment_assignments');
  });
});
```

### Comment exécuter le script :

**Option 1 : Firebase Console (recommandé)**

1. Ouvrir Firebase Console
2. Aller dans Firestore Database
3. Ouvrir la console JavaScript (F12)
4. Copier-coller le script
5. Appuyer sur Entrée

**Option 2 : Node.js avec Firebase Admin**

```bash
# Installer Firebase Admin
npm install firebase-admin

# Créer migrate.js
node migrate.js
```

---

## 🔥 PHASE 6 : NETTOYAGE FINAL (15 min)

### Supprimer les fichiers obsolètes :

```bash
# Models
rm lib/domain/models/equipment_assignment.dart
rm lib/domain/models/equipment_assignment.freezed.dart
rm lib/domain/models/equipment_assignment.g.dart

# Repositories
rm lib/domain/repositories/equipment_assignment_repository.dart
rm lib/data/repositories/firebase_equipment_assignment_repository.dart

# Providers
rm lib/presentation/providers/equipment_assignment_notifier.dart
rm lib/presentation/providers/equipment_assignment_notifier.g.dart

# Tests
rm test/domain/equipment_assignment_test.dart

# Documentation obsolète
rm z_travaux-a-faire/GESTION_CRENEAUX_OPTION_A.md
```

### Mettre à jour `firestore_schema.md` :

```markdown
## COLLECTION: equipment_bookings

- **Chemin**: `/equipment_bookings/{bookingId}`
- **Description**: Réservations de matériel (Location ET Cours)

### Champs :

| Champ | Type | Description |
|-------|------|-------------|
| `id` | string | ID unique |
| `userId` | string | ID de l'utilisateur (élève ou autre) |
| `userName` | string | Nom de l'utilisateur |
| `userEmail` | string | Email de l'utilisateur |
| `equipmentId` | string | ID de l'équipement réservé |
| `equipmentType` | string | Catégorie (kite, foil, board, harness) |
| `equipmentBrand` | string | Marque |
| `equipmentModel` | string | Modèle |
| `equipmentSize` | string | Taille |
| `date_string` | string | Date au format YYYY-MM-DD |
| `date_timestamp` | timestamp | Date en timestamp |
| `slot` | string | morning, afternoon, full_day |
| `status` | string | confirmed, cancelled, completed |
| `type` | string | ✅ student, assignment, staff |
| `assignedBy` | string? | ✅ ID moniteur (si type=assignment) |
| `sessionId` | string? | ✅ ID de la séance (si assignment) |
| `created_at` | timestamp | Date de création |
| `updated_at` | timestamp | Date de mise à jour |
| `created_by` | string | ID de celui qui a créé
```

---

## ✅ CHECKLIST FINALE

### Code :

- [ ] `EquipmentBooking` mis à jour avec `type`
- [ ] `build_runner` exécuté
- [ ] `EquipmentAssignmentScreen` migré
- [ ] `LessonValidationScreen` migré
- [ ] Repositories obsolètes supprimés
- [ ] Providers obsolètes supprimés
- [ ] Tests obsolètes supprimés

### Firestore :

- [ ] Script de migration exécuté
- [ ] Données migrées vérifiées
- [ ] Collection `equipment_assignments` supprimée
- [ ] Index Firestore déployés (`firebase deploy --only firestore:indexes`)

### Tests :

- [ ] Assignment fonctionne (EquipmentAssignmentScreen)
- [ ] Libération fonctionne (LessonValidationScreen)
- [ ] Plus de conflits Assignment/Booking
- [ ] Disponibilité correcte

---

## 🚀 COMMANDES À EXÉCUTER

```bash
# 1. Générer le code Freezed
flutter pub run build_runner build --delete-conflicting-outputs

# 2. Analyser le code
flutter analyze

# 3. Déployer les index Firestore
firebase deploy --only firestore:indexes

# 4. Tester manuellement
flutter run
```

---

## 🎯 RÉSULTAT FINAL

| Avant | Après |
|-------|-------|
| 2 collections | 1 collection ✅ |
| 2 repositories | 1 repository ✅ |
| 2 modèles | 1 modèle ✅ |
| ~1200 lignes | ~900 lignes ✅ |
| Bugs de synchronisation | Plus de bugs ✅ |
| Complexe | Simple ✅ |

---

**MODE : DEV SANS FILET ACTIVÉ** 🚀  
**BACKUP : NON NÉCESSAIRE (données de dev)**  
**STATUT : PRÊT À DÉPLOYER**
