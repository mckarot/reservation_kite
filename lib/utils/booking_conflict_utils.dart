import '../domain/models/equipment_booking.dart';

/// Vérifie si deux créneaux sont en conflit.
///
/// RÈGLE MÉTIER :
/// - full_day entre en conflit avec TOUT (morning, afternoon, full_day)
/// - morning entre en conflit avec morning et full_day
/// - afternoon entre en conflit avec afternoon et full_day
///
/// Cette logique est SYMÉTRIQUE :
/// - slotsConflict(A, B) == slotsConflict(B, A)
bool slotsConflict(
  EquipmentBookingSlot existing,
  EquipmentBookingSlot requested,
) {
  // full_day bloque tout
  if (existing == EquipmentBookingSlot.fullDay) return true;
  if (requested == EquipmentBookingSlot.fullDay) return true;

  // Même créneau = conflit
  return existing == requested;
}

/// Compte combien de réservations existantes conflictent avec le créneau demandé.
///
/// [existingBookings] doit contenir les réservations pour un équipement
/// et une date donnés, avec le statut 'confirmed' ou 'completed'.
int countConflictingBookings(
  List<Map<String, dynamic>> existingBookings,
  EquipmentBookingSlot requestedSlot,
) {
  int count = 0;
  for (final booking in existingBookings) {
    final slotString = booking['slot'] as String;
    final existingSlot = EquipmentBookingSlot.values.firstWhere(
      (e) => e.name == slotString,
    );
    if (slotsConflict(existingSlot, requestedSlot)) {
      count++;
    }
  }
  return count;
}
