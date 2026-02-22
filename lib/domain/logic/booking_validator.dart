import '../models/reservation.dart';
import '../models/staff.dart';
import '../models/settings.dart' hide TimeSlot;
import '../models/staff_unavailability.dart';

class BookingValidator {
  /// Calcule la capacité maximale d'élèves pour un créneau donné.
  /// Règle : (Nb moniteurs actifs - moniteurs indisponibles) * Quota par moniteur
  static int calculateMaxCapacity({
    required List<Staff> activeStaff,
    required List<StaffUnavailability> unavailabilities,
    required SchoolSettings settings,
    required DateTime date,
    required TimeSlot slot,
  }) {
    // Filtrer les moniteurs indisponibles (validés) pour ce créneau spécifique
    final unavailableStaffIds = unavailabilities
        .where(
          (u) =>
              u.status == UnavailabilityStatus.approved &&
              u.date.year == date.year &&
              u.date.month == date.month &&
              u.date.day == date.day &&
              (u.slot == slot || u.slot == TimeSlot.fullDay),
        )
        .map((u) => u.staffId)
        .toSet();

    final availableStaffCount = activeStaff
        .where((s) => !unavailableStaffIds.contains(s.id))
        .length;

    return availableStaffCount * settings.maxStudentsPerInstructor;
  }

  /// Vérifie si un nouveau booking est possible.
  static bool canBook({
    required DateTime date,
    required TimeSlot slot,
    required List<Reservation> existingReservations,
    required List<Staff> activeStaff,
    required List<StaffUnavailability> unavailabilities,
    required SchoolSettings settings,
  }) {
    // 1. Filtrer les réservations pour ce créneau
    final reservationsForSlot = existingReservations.where(
      (res) =>
          res.date.year == date.year &&
          res.date.month == date.month &&
          res.date.day == date.day &&
          res.slot == slot,
    );

    // 2. Calculer capacité dynamique
    final maxCapacity = calculateMaxCapacity(
      activeStaff: activeStaff,
      unavailabilities: unavailabilities,
      settings: settings,
      date: date,
      slot: slot,
    );

    // 3. Valider
    return reservationsForSlot.length < maxCapacity;
  }
}
