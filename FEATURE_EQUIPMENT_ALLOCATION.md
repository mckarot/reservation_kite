# Allocation de Matériel - Fonctionnalité

## Vue d'ensemble

Cette fonctionnalité permet aux moniteurs d'allouer du matériel aux élèves lors de la validation d'une séance de cours. Le matériel alloué est **uniquement indisponible pour le créneau spécifique** de la réservation.

## Fonctionnalités

### 1. Allocation de Matériel
- **Accès** : Depuis l'écran de validation de leçon (`LessonValidationScreen`), cliquer sur l'icône 🛒 (panier d'achat)
- **Filtrage** : Le matériel peut être filtré par catégorie (Kite, Foil, Board, Harness, etc.)
- **Disponibilité** : Vérification en temps réel de la disponibilité du matériel pour le créneau sélectionné

### 2. Gestion de la Disponibilité Temporelle

Le système gère trois types de créneaux :
- **Matin** (morning)
- **Après-midi** (afternoon)
- **Journée complète** (full_day)

#### Règles de Disponibilité

```
┌─────────────────────────────────────────────────────────────┐
│  CRÉNEAU DEMANDÉ  │  CRÉNEAU EXISTANT  │  CONFLIT ?        │
├───────────────────┼────────────────────┼───────────────────┤
│  Matin            │  Matin             │  ✅ OUI           │
│  Matin            │  Après-midi        │  ❌ NON           │
│  Matin            │  Journée complète  │  ✅ OUI           │
│  Après-midi       │  Matin             │  ❌ NON           │
│  Après-midi       │  Après-midi        │  ✅ OUI           │
│  Après-midi       │  Journée complète  │  ✅ OUI           │
│  Journée complète │  Matin             │  ✅ OUI           │
│  Journée complète │  Après-midi        │  ✅ OUI           │
│  Journée complète │  Journée complète  │  ✅ OUI           │
└─────────────────────────────────────────────────────────────┘
```

**Exemple concret :**
- Si un matériel est réservé **lundi prochain - Matin**, il sera :
  - ❌ Indisponible : Lundi matin
  - ✅ Disponible : Lundi après-midi
  - ✅ Disponible : Mardi toute la journée
  - ✅ Disponible : Mercredi toute la journée, etc.

### 3. Catégories de Matériel

Les catégories sont configurables via Firebase Firestore (collection `equipment_categories`) :
- Kite
- Foil
- Board
- Harness
- Autres (configurable par l'admin)

## Architecture

### Fichiers Créés

1. **`equipment_allocation_screen.dart`**
   - Écran principal d'allocation de matériel
   - Affiche le matériel disponible avec filtrage par catégorie
   - Vérifie la disponibilité en temps réel
   - Permet l'allocation en un clic

2. **Modifications de `lesson_validation_screen.dart`**
   - Ajout du bouton d'allocation (icône 🛒)
   - Navigation vers l'écran d'allocation
   - Affichage du matériel déjà assigné (icône 📦)

3. **Fichiers de localisation**
   - `app_localizations.dart` : Ajout des nouvelles clés
   - `app_localizations_fr.dart` : Traductions françaises
   - `app_localizations_en.dart` : Traductions anglaises

### Base de Données

#### Collection `equipment_bookings`

Chaque réservation de matériel contient :
```typescript
{
  id: string,
  user_id: string,
  user_name: string,
  user_email: string,
  equipment_id: string,        // ID de l'équipement physique
  equipment_type: string,      // Catégorie (kite, foil, etc.)
  equipment_brand: string,
  equipment_model: string,
  equipment_size: string,
  date_string: string,         // Format 'yyyy-MM-dd'
  date_timestamp: Timestamp,
  slot: 'morning' | 'afternoon' | 'full_day',
  status: 'confirmed' | 'cancelled' | 'completed',
  created_at: Timestamp,
  updated_at: Timestamp,
  created_by: string,
  session_id: string?,         // Lié à une session de cours
  notes: string?
}
```

## Utilisation

### Pour les Moniteurs

1. **Ouvrir la validation de leçon**
   - Accéder à la séance d'un élève
   - Cliquer sur "Valider la progression"

2. **Allouer du matériel**
   - Cliquer sur l'icône 🛒 en haut à droite
   - Filtrer par catégorie si nécessaire
   - Consulter la disponibilité (les équipements indisponibles sont grisés)
   - Cliquer sur le bouton ➕ pour allouer

3. **Voir le matériel assigné**
   - Cliquer sur l'icône 📦 pour voir/modifier le matériel déjà assigné
   - Libérer le matériel si nécessaire (après la séance)

### Pour les Développeurs

#### Vérifier la Disponibilité d'un Équipement

```dart
// Dans EquipmentAllocationScreen
Future<bool> _isEquipmentAvailable(
  String equipmentId,
  DateTime date,
  EquipmentBookingSlot slot,
) async {
  final dateString = formatDate(date);
  
  final bookings = await FirebaseFirestore.instance
      .collection('equipment_bookings')
      .where('equipment_id', isEqualTo: equipmentId)
      .where('date_string', isEqualTo: dateString)
      .where('status', whereIn: ['confirmed', 'pending'])
      .get();

  for (var doc in bookings.docs) {
    final bookingSlot = doc.data()['slot'] as String;
    if (_hasSlotConflict(slot, bookingSlot)) {
      return false; // Indisponible
    }
  }
  
  return true; // Disponible
}
```

#### Allouer du Matériel

```dart
final notifier = ref.read(
  equipmentBookingNotifierProvider(studentId).notifier,
);

await notifier.createBooking(
  equipmentId: equipment.id,
  equipmentType: equipment.categoryId,
  equipmentBrand: equipment.brand,
  equipmentModel: equipment.model,
  equipmentSize: equipment.size,
  date: date,
  slot: bookingSlot,
  sessionId: sessionId,
);
```

## Tests

Pour tester la fonctionnalité :

1. **Lancer l'application**
   ```bash
   flutter run
   ```

2. **Naviguer vers une séance**
   - Se connecter en tant que moniteur
   - Sélectionner une séance d'élève
   - Cliquer sur "Valider la progression"

3. **Allouer du matériel**
   - Cliquer sur 🛒
   - Vérifier que le filtrage par catégorie fonctionne
   - Allouer un équipement
   - Vérifier qu'il apparaît dans la liste "Matériel assigné"

4. **Tester les conflits**
   - Tenter d'allouer le même équipement pour le même créneau
   - Vérifier qu'il est marqué comme "Déjà réservé pour ce créneau"

## Notes Importantes

- ✅ Le matériel n'est indisponible **que pour le créneau réservé**
- ✅ Un même équipement peut être réservé **matin ET après-midi** le même jour
- ✅ Une réservation **journée complète** bloque l'équipement pour toute la journée
- ✅ Le filtrage par catégorie permet de trouver rapidement le matériel adapté
- ✅ La disponibilité est vérifiée en **temps réel**

## Améliorations Futures

- [ ] Ajouter un historique des allocations par élève
- [ ] Permettre la modification d'une allocation existante
- [ ] Ajouter des notifications de rappel de matériel
- [ ] Statistiques d'utilisation du matériel par catégorie
