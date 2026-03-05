# 🎯 HARMONISATION DE LA GESTION DES CRÉNEAUX - ÉTAT DES LIEUX

## 📊 DATE : 4 mars 2026

---

## ✅ CE QUI EST DÉJÀ HARMONISÉ

### 1. Repository Principal

**Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`

**Fonctions harmonisées :**
- ✅ `bookEquipmentAtomically()` - Utilise les conflits, pas le statut
- ✅ `releaseEquipment()` - Ne change pas le statut automatiquement
- ✅ `getAvailableCount()` - Utilise les conflits de créneau

**Principe :**
```dart
// La disponibilité est calculée UNIQUEMENT via les conflits
// Le statut de l'équipement n'est PAS utilisé (sauf maintenance/damaged)
```

---

### 2. Écran de Réservation (Élève)

**Fichier :** `lib/presentation/screens/equipment_booking_screen.dart`

**Fonctions harmonisées :**
- ✅ `_watchSizeAvailability()` - Utilise `countConflictingBookings`
- ✅ `_bookEquipmentForSize()` - Vérifie les conflits avant de réserver

**Exemple :**
```dart
final availableCount = equipmentList.where((eq) {
  if (eq.status == EquipmentStatus.maintenance || 
      eq.status == EquipmentStatus.damaged) {
    return false; // Toujours indisponible
  }

  final eqBookings = bookingsByEquipment[eq.id] ?? [];
  if (eqBookings.isEmpty) return true;

  final conflicts = countConflictingBookings(eqBookings, _selectedSlot);
  return conflicts == 0; // Disponible si aucun conflit
}).length;
```

---

### 3. Écran de Visualisation (Admin)

**Fichier :** `lib/presentation/screens/equipment_reservations_screen.dart`

**Fonctions harmonisées :**
- ✅ Affiche les réservations par date
- ✅ Filtre par catégorie (utilise EquipmentCategoryFilter)
- ✅ Regroupe par type d'équipement

**Requête :**
```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where('date_string', isEqualTo: dateString)
      .where('status', whereIn: ['confirmed', 'completed'])
      .snapshots(),
  // ...
)
```

---

### 4. Service Utilitaire (NOUVEAU)

**Fichier :** `lib/utils/equipment_slot_availability_service.dart`

**Méthodes disponibles :**
- ✅ `isEquipmentAvailable()` - Vérifie la disponibilité d'un équipement
- ✅ `countAvailableEquipment()` - Compte les équipements dispos
- ✅ `getAvailableEquipmentIds()` - Liste les IDs disponibles
- ✅ `hasSlotConflict()` - Vérifie un conflit rapidement

**Utilisation :**
```dart
import '../../utils/equipment_slot_availability_service.dart';

final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: equipment.id,
  date: _selectedDate,
  slot: EquipmentBookingSlot.morning,
);
```

---

## ⚠️ CE QUI N'EST PAS ENCORE HARMONISÉ

### 1. Écran d'Assignment (Moniteur/Admin)

**Fichier :** `lib/presentation/screens/equipment_assignment_screen.dart`

**Problème :**
- Utilise peut-être encore le statut pour la disponibilité
- Devrait utiliser `EquipmentSlotAvailabilityService`

**Action requise :**
```dart
// À AJOUTER
import '../../utils/equipment_slot_availability_service.dart';

// Remplacer la logique de disponibilité par :
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: equipmentId,
  date: date,
  slot: slot,
);
```

---

### 2. Écran de Validation de Séance (Moniteur)

**Fichier :** `lib/presentation/screens/lesson_validation_screen.dart`

**Problème :**
- Section "Incident matériel" peut utiliser le statut
- Devrait utiliser le service pour la disponibilité

**Action requise :**
```dart
// Dans _EquipmentIncidentSection
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: _selectedEquipId,
  date: DateTime.now(),
  slot: EquipmentBookingSlot.morning,
);
```

---

### 3. Repository de Booking

**Fichier :** `lib/data/repositories/firebase_equipment_booking_repository.dart`

**Problème :**
- Contient peut-être des méthodes redondantes
- Devrait déléguer au service utilitaire

**Action requise :**
```dart
// Remplacer les méthodes de vérification par :
import '../../utils/equipment_slot_availability_service.dart';

final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  // ...
);
```

---

## 📋 CHECKLIST DE MIGRATION

### Fichiers à vérifier/migrer :

| Fichier | Statut | Action | Priorité |
|---------|--------|--------|----------|
| `firestore_equipment_repository.dart` | ✅ Harmonisé | Aucun | - |
| `equipment_booking_screen.dart` | ✅ Harmonisé | Aucun | - |
| `equipment_reservations_screen.dart` | ✅ Harmonisé | Aucun | - |
| `equipment_slot_availability_service.dart` | ✅ Créé | Tests unitaires | Moyenne |
| `equipment_assignment_screen.dart` | ⚠️ À vérifier | Migrer vers service | Haute |
| `lesson_validation_screen.dart` | ⚠️ Partiel | Utiliser service | Moyenne |
| `firebase_equipment_booking_repository.dart` | ⚠️ À vérifier | Harmoniser | Haute |
| `equipment_admin_screen.dart` | ℹ️ Affichage | Aucun (OK) | - |
| `equipment_init_screen.dart` | ❓ Inconnu | À vérifier | Basse |

---

## 🎯 RÈGLES D'HARMONISATION

### Règle 1 : JAMAIS de statut pour la disponibilité

```dart
// ❌ INTERDIT
if (equipment.status == 'available') {
  // Réserver
}

// ✅ OBLIGATOIRE
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: equipment.id,
  date: date,
  slot: slot,
);
```

### Règle 2 : TOUJOURS utiliser le service utilitaire

```dart
// ❌ INTERDIT (code dispersé)
final bookings = await db.collection('equipment_bookings')
    .where('equipment_id', isEqualTo: id)
    .where('date_string', isEqualTo: dateString)
    .get();

// ✅ OBLIGATOIRE (centralisé)
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: id,
  date: date,
  slot: slot,
);
```

### Règle 3 : UNIQUEMENT les conflits déterminent la disponibilité

```dart
// ❌ INTERDIT
if (existingBookings.isNotEmpty) {
  return false; // Indisponible
}

// ✅ OBLIGATOIRE
final conflicts = countConflictingBookings(bookings, slot);
return conflicts == 0; // Disponible si aucun conflit
```

---

## 📊 STATISTIQUES DE CONFLITS

### Matrice de conflits :

| Créneau demandé | Conflit avec morning | Conflit avec afternoon | Conflit avec full_day |
|----------------|---------------------|----------------------|---------------------|
| `morning` | ❌ (même créneau) | ✅ (différent) | ❌ (full_day bloque) |
| `afternoon` | ✅ (différent) | ❌ (même créneau) | ❌ (full_day bloque) |
| `full_day` | ❌ (bloque tout) | ❌ (bloque tout) | ❌ (même créneau) |

### Exemples :

```
Cas 1 : morning + afternoon = ✅ OK (pas de conflit)
Cas 2 : morning + morning = ❌ Conflit (même créneau)
Cas 3 : full_day + morning = ❌ Conflit (full_day bloque)
Cas 4 : afternoon + full_day = ❌ Conflit (full_day bloque)
```

---

## 🔧 COMMENT MIGRER UN ÉCRAN

### Étape 1 : Identifier la logique actuelle

```dart
// Chercher dans le fichier :
// - Les requêtes directes à 'equipment_bookings'
// - Les vérifications de statut
// - Les calculs de disponibilité
```

### Étape 2 : Remplacer par le service

```dart
// Avant
final bookings = await db.collection('equipment_bookings')
    .where('equipment_id', isEqualTo: id)
    .get();
final isAvailable = bookings.isEmpty;

// Après
final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
  equipmentId: id,
  date: date,
  slot: slot,
);
```

### Étape 3 : Tester

```dart
// Vérifier que :
// 1. Les réservations futures ne bloquent pas l'équipement avant
// 2. morning + afternoon = possible (même jour, même équipement)
// 3. full_day bloque tout (même jour)
// 4. maintenance/damaged bloque toujours
```

---

## 📝 EXEMPLE DE MIGRATION

### Avant (code dispersé) :

```dart
class _EquipmentAssignmentScreenState extends ConsumerState<EquipmentAssignmentScreen> {
  Future<bool> _checkAvailability(String equipmentId, DateTime date) async {
    // Requête directe
    final bookings = await FirebaseFirestore.instance
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: _formatDate(date))
        .get();
    
    // Logique de conflit manuelle
    for (final doc in bookings.docs) {
      final slot = doc.data()['slot'] as String;
      if (slot == 'morning' && _selectedSlot == EquipmentBookingSlot.morning) {
        return false;
      }
      if (slot == 'full_day') {
        return false;
      }
    }
    
    return true;
  }
}
```

### Après (harmonisé) :

```dart
class _EquipmentAssignmentScreenState extends ConsumerState<EquipmentAssignmentScreen> {
  Future<bool> _checkAvailability(String equipmentId, DateTime date) async {
    // Utilise le service centralisé
    return await EquipmentSlotAvailabilityService.isEquipmentAvailable(
      equipmentId: equipmentId,
      date: date,
      slot: _selectedSlot,
    );
  }
}
```

---

## 🎯 BÉNÉFICES DE L'HARMONISATION

| Avant | Après |
|-------|-------|
| 10 fichiers avec logique différente | 1 fichier centralisé |
| Bugs de disponibilité incohérents | 100% harmonisé |
| Complexe à déboguer | Simple : 1 fichier à checker |
| Mise à jour manuelle de 10 fichiers | 1 fichier à mettre à jour |
| Risque d'oubli dans un écran | Tous les écrans mis à jour automatiquement |

---

## 📚 DOCUMENTATION ASSOCIÉE

- `REFACTORISATION_HARMONISATION.md` - Guide de migration
- `GESTION_CRENEAUX_VERSION_FINALE.md` - Principe fondamental
- `equipment_slot_availability_service.dart` - Code du service

---

**Prochaine étape :** Migrer `equipment_assignment_screen.dart` vers le service utilitaire.
