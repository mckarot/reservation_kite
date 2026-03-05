# 🔄 REFACTORISATION - HARMONISATION DE LA GESTION DES CRÉNEAUX

## 🎯 OBJECTIF

Centraliser **TOUTE** la logique de disponibilité du matériel dans un fichier utilitaire unique pour garantir une harmonisation parfaite entre tous les écrans (élève, moniteur, admin).

---

## 📁 FICHIER CENTRALISÉ

### `lib/utils/equipment_slot_availability_service.dart`

Ce fichier contient **TOUS** les méthodes pour vérifier la disponibilité :

| Méthode | Description | Usage |
|---------|-------------|-------|
| `isEquipmentAvailable()` | Vérifie si un équipement est disponible | Écrans de réservation |
| `countAvailableEquipment()` | Compte les équipements dispos | Listes avec compteur |
| `getAvailableEquipmentIds()` | Liste les IDs disponibles | Filtrage avancé |
| `hasSlotConflict()` | Vérifie un conflit de créneau | Validation rapide |

---

## 📖 COMMENT UTILISER

### Cas 1 : Vérifier la disponibilité d'un équipement

```dart
import '../../utils/equipment_slot_availability_service.dart';

// Dans un écran de réservation
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: equipment.id,
  date: _selectedDate,
  slot: EquipmentBookingSlot.morning,
);

if (isAvailable) {
  // Réserver
} else {
  // Afficher "Indisponible"
}
```

### Cas 2 : Compter les équipements disponibles

```dart
import '../../utils/equipment_slot_availability_service.dart';

// Dans un écran de liste
final availableCount = await EquipmentSlotAvailabilityService.countAvailableEquipment(
  categoryId: 'kite',
  date: _selectedDate,
  slot: EquipmentBookingSlot.afternoon,
);

Text('$availableCount équipements disponibles');
```

### Cas 3 : Vérifier un conflit rapidement

```dart
import '../../utils/equipment_slot_availability_service.dart';

// Dans une validation de formulaire
final hasConflict = EquipmentSlotAvailabilityService.hasSlotConflict(
  existingBookings: bookings,
  requestedSlot: EquipmentBookingSlot.fullDay,
);

if (hasConflict) {
  showError('Créneau déjà réservé');
}
```

---

## 🔄 MIGRATION DES ÉCRANS EXISTANTS

### Écran : EquipmentBookingScreen (Élève)

**Avant :**
```dart
Stream<_SizeAvailability> _watchSizeAvailability(List<Equipment> equipmentList) {
  // Code dispersé avec logique de conflit
  return FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where(...)
      .snapshots()
      .map((snapshot) {
    // Logique de comptage...
  });
}
```

**Après :**
```dart
Stream<_SizeAvailability> _watchSizeAvailability(List<Equipment> equipmentList) {
  return FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where('date_string', isEqualTo: dateString)
      .where('status', whereIn: ['confirmed', 'completed'])
      .snapshots()
      .map((snapshot) {
    final bookingsByEquipment = <String, List<Map<String, dynamic>>>{};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final equipmentId = data['equipment_id'] as String;
      bookingsByEquipment.putIfAbsent(equipmentId, () => []).add(data);
    }

    final availableCount = equipmentList.where((eq) {
      if (eq.status == EquipmentStatus.maintenance || 
          eq.status == EquipmentStatus.damaged) {
        return false;
      }

      final eqBookings = bookingsByEquipment[eq.id] ?? [];
      if (eqBookings.isEmpty) return true;

      final conflicts = countConflictingBookings(eqBookings, _selectedSlot);
      return conflicts == 0;
    }).length;

    return _SizeAvailability(
      availableCount: availableCount,
      totalCount: equipmentList.length,
    );
  });
}
```

### Écran : EquipmentReservationsScreen (Admin)

**Avant :**
```dart
// Requête directe dans le StreamBuilder
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where('date_string', isEqualTo: dateString)
      .snapshots(),
  // ...
)
```

**Après :**
```dart
// Utiliser le service pour la cohérence
final availableIds = await EquipmentSlotAvailabilityService.getAvailableEquipmentIds(
  categoryId: _selectedCategory,
  date: _selectedDate,
  slot: EquipmentBookingSlot.morning,
);
```

### Écran : LessonValidationScreen (Moniteur)

**Avant :**
```dart
// Logique dispersée dans plusieurs endroits
```

**Après :**
```dart
// Tout passe par le service
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: equipmentId,
  date: reservationDate,
  slot: EquipmentBookingSlot.morning,
);
```

---

## ✅ CHECKLIST DE MIGRATION

### Écrans à vérifier :

- [x] `equipment_booking_screen.dart` (Élève) - Déjà harmonisé ✅
- [x] `equipment_reservations_screen.dart` (Admin) - Déjà harmonisé ✅
- [ ] `equipment_assignment_screen.dart` (Moniteur/Admin) - À migrer
- [ ] `lesson_validation_screen.dart` (Moniteur) - Déjà partiellement harmonisé
- [ ] `equipment_admin_screen.dart` (Admin) - Affichage uniquement
- [ ] `equipment_init_screen.dart` (Initialisation) - À vérifier

### Fichiers de repository :

- [x] `firestore_equipment_repository.dart` - Déjà harmonisé ✅
- [ ] `firebase_equipment_booking_repository.dart` - À vérifier

---

## 📊 RÈGLES D'OR

### 1. JAMAIS de statut pour la disponibilité

```dart
// ❌ À NE PAS FAIRE
if (equipment.status == 'available') {
  // Réserver
}

// ✅ À FAIRE
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: equipment.id,
  date: date,
  slot: slot,
);
```

### 2. TOUJOURS vérifier les conflits

```dart
// ❌ À NE PAS FAIRE
final bookings = await db.collection('equipment_bookings')
    .where('equipment_id', isEqualTo: id)
    .get();

// ✅ À FAIRE
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: id,
  date: date,
  slot: slot,
);
```

### 3. UTILISER le service dans TOUS les écrans

```dart
// ❌ À NE PAS FAIRE
// Chaque écran a sa propre logique

// ✅ À FAIRE
import '../../utils/equipment_slot_availability_service.dart';

// Tous les écrans utilisent les mêmes méthodes
```

---

## 🎯 BÉNÉFICES DE LA REFACTORISATION

| Avant | Après |
|-------|-------|
| Logique dispersée dans 10 fichiers | 1 fichier centralisé |
| Risque d'incohérence | 100% harmonisé |
| Complexe à maintenir | Simple à mettre à jour |
| Bugs de disponibilité | Logique unique et testée |

---

## 📝 EXEMPLE COMPLET

### Fichier : `my_booking_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../../utils/equipment_slot_availability_service.dart';
import '../../domain/models/equipment_booking.dart';

class MyBookingScreen extends ConsumerStatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  EquipmentBookingSlot _selectedSlot = EquipmentBookingSlot.morning;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: EquipmentSlotAvailabilityService.countAvailableEquipment(
        categoryId: 'kite',
        date: _selectedDate,
        slot: _selectedSlot,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }

        final count = snapshot.data ?? 0;

        return Text(
          count > 0
              ? '$count équipements disponibles'
              : 'Aucun équipement disponible',
          style: TextStyle(
            color: count > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
```

---

## 🔧 MAINTENANCE

### Ajouter un nouveau type de créneau

1. Modifier `EquipmentBookingSlot` dans `equipment_booking.dart`
2. Mettre à jour `countConflictingBookings()` dans `booking_conflict_utils.dart`
3. Le service est automatiquement mis à jour ✅

### Changer les règles de conflit

1. Modifier `countConflictingBookings()` dans `booking_conflict_utils.dart`
2. TOUS les écrans sont automatiquement mis à jour ✅

---

## 📚 FICHIERS CLÉS

| Fichier | Rôle |
|---------|------|
| `utils/equipment_slot_availability_service.dart` | **Service centralisé** |
| `utils/booking_conflict_utils.dart` | Logique de conflits |
| `domain/models/equipment_booking.dart` | Modèle EquipmentBookingSlot |
| `data/repositories/firestore_equipment_repository.dart` | Repository principal |

---

**Date de création :** 4 mars 2026  
**Version :** 1.0.0  
**Statut :** ✅ Service créé - En cours de migration des écrans
