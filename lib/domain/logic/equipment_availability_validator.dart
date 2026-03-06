/// Validate la disponibilité des équipements pour une date et un slot donnés.
///
/// Ce validator centralise la logique métier de conflit de slots :
/// - morning + morning = ❌ Conflit
/// - morning + afternoon = ✅ Pas de conflit
/// - morning + fullDay = ❌ Conflit
/// - afternoon + afternoon = ❌ Conflit
/// - afternoon + fullDay = ❌ Conflit
/// - fullDay + anything = ❌ Conflit
library;

import '../models/equipment_rental.dart';
import '../models/reservation.dart';

class EquipmentAvailabilityValidator {
  /// Vérifie si deux slots entrent en conflit.
  ///
  /// Retourne `true` si les slots sont incompatibles, `false` sinon.
  ///
  /// Règles de conflit :
  /// - fullDay est incompatible avec TOUS les slots
  /// - morning est incompatible avec morning et fullDay
  /// - afternoon est incompatible avec afternoon et fullDay
  static bool hasSlotConflict(TimeSlot slot1, TimeSlot slot2) {
    // fullDay est incompatible avec tout
    if (slot1 == TimeSlot.fullDay || slot2 == TimeSlot.fullDay) {
      return true;
    }

    // morning et afternoon ne sont pas incompatibles entre eux
    return slot1 == slot2;
  }

  /// Vérifie si un équipement est disponible pour une date et un slot.
  ///
  /// Retourne `true` si l'équipement peut être loué, `false` s'il y a un conflit.
  ///
  /// Paramètres :
  /// - [existingRentals] : Locations existantes pour l'équipement
  /// - [dateString] : Date au format YYYY-MM-DD
  /// - [slot] : Slot demandé (morning, afternoon, fullDay)
  static bool isEquipmentAvailable({
    required List<EquipmentRental> existingRentals,
    required String dateString,
    required TimeSlot slot,
  }) {
    for (final rental in existingRentals) {
      // Skip si date différente
      if (rental.dateString != dateString) {
        continue;
      }

      // Skip si location annulée
      if (rental.status == RentalStatus.cancelled) {
        continue;
      }

      // Vérifier conflit de slots
      if (hasSlotConflict(slot, rental.slot)) {
        return false; // Conflit détecté
      }
    }

    return true; // Pas de conflit
  }

  /// Trouve les équipements disponibles pour une date et un slot.
  ///
  /// Retourne la liste des équipements qui peuvent être loués.
  ///
  /// Paramètres :
  /// - [allEquipment] : Tous les équipements actifs
  /// - [rentalsForDate] : Toutes les locations pour la date donnée
  /// - [slot] : Slot demandé
  static List<String> findAvailableEquipment({
    required List<String> allEquipment,
    required List<EquipmentRental> rentalsForDate,
    required TimeSlot slot,
  }) {
    final available = <String>[];

    for (final equipmentId in allEquipment) {
      // Filtrer les rentals pour cet équipement
      final equipmentRentals = rentalsForDate
          .where((r) => r.equipmentId == equipmentId)
          .toList();

      if (isEquipmentAvailable(
        existingRentals: equipmentRentals,
        dateString: rentalsForDate.firstOrNull?.dateString ?? '',
        slot: slot,
      )) {
        available.add(equipmentId);
      }
    }

    return available;
  }

  /// Calcule le nombre d'équipements disponibles pour une catégorie.
  ///
  /// Retourne un map avec le nombre total et le nombre disponible.
  static Map<String, int> countAvailableByCategory({
    required List<Map<String, dynamic>> allEquipment,
    required List<EquipmentRental> rentalsForDate,
    required TimeSlot slot,
    required String category,
  }) {
    final categoryEquipment = allEquipment
        .where((e) => e['category'] == category && e['is_active'] == true)
        .toList();

    final total = categoryEquipment.length;
    var available = 0;

    for (final equipment in categoryEquipment) {
      final equipmentId = equipment['id'] as String;
      final equipmentRentals = rentalsForDate
          .where((r) => r.equipmentId == equipmentId)
          .toList();

      if (isEquipmentAvailable(
        existingRentals: equipmentRentals,
        dateString: rentalsForDate.firstOrNull?.dateString ?? '',
        slot: slot,
      )) {
        available++;
      }
    }

    return {
      'total': total,
      'available': available,
    };
  }
}
