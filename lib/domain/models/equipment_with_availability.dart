import 'equipment.dart';
import 'equipment_booking.dart';

/// Modèle enrichi : Equipment + disponibilité calculée dynamiquement.
///
/// Ce modèle ne correspond à aucun document Firestore et n'est jamais stocké.
/// Il est utilisé uniquement pour l'affichage UI avec la disponibilité en temps réel.
class EquipmentWithAvailability {
  final Equipment equipment;
  final int availableQuantity;
  final EquipmentBookingSlot requestedSlot;
  final DateTime requestedDate;

  const EquipmentWithAvailability({
    required this.equipment,
    required this.availableQuantity,
    required this.requestedSlot,
    required this.requestedDate,
  });

  /// True si au moins un équipement est disponible pour ce créneau.
  bool get isAvailable => availableQuantity > 0;
}
