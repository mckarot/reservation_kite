import '../models/reservation.dart';
import '../models/staff.dart';
import '../models/settings.dart' hide TimeSlot;

class BookingValidator {
  /// Calcule la capacité maximale d'élèves pour un créneau donné.
  /// Règle : Nb moniteurs actifs * Quota par moniteur
  static int calculateMaxCapacity(
    List<Staff> activeStaff,
    SchoolSettings settings,
  ) {
    return activeStaff.length * settings.maxStudentsPerInstructor;
  }

  /// Vérifie si un nouveau booking est possible.
  static bool canBook({
    required DateTime date,
    required TimeSlot slot,
    required List<Reservation> existingReservations,
    required List<Staff> activeStaff,
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

    // 2. Calculer capacité
    final maxCapacity = calculateMaxCapacity(activeStaff, settings);

    // 3. Valider
    return reservationsForSlot.length < maxCapacity;
  }
}
