import '../models/equipment_rental.dart';
import '../models/equipment_item.dart';
import '../models/reservation.dart';

/// Repository interface pour la gestion des locations de matériel.
///
/// Gère les trois flux d'affectation :
/// - Location directe (élève)
/// - Assignment admin (validation réservation)
/// - Assignment moniteur (obligatoire si admin skip)
abstract class EquipmentRentalRepository {
  // ───────────────────────────────────────────────────────────────────────────
  // Lecture
  // ───────────────────────────────────────────────────────────────────────────

  /// Récupère l'historique des locations d'un élève.
  Future<List<EquipmentRental>> getRentalsByStudent(String studentId);

  /// Récupère les locations pour une date donnée.
  Future<List<EquipmentRental>> getRentalsByDate(String dateString);

  /// Récupère les locations liées à une réservation.
  Future<List<EquipmentRental>> getRentalsByReservation(String reservationId);

  /// Stream pour observer les locations d'une date en temps réel.
  Stream<List<EquipmentRental>> watchRentalsByDate(String dateString);

  // ───────────────────────────────────────────────────────────────────────────
  // Disponibilité
  // ───────────────────────────────────────────────────────────────────────────

  /// Vérifie si un équipement est disponible pour une date et un slot donnés.
  ///
  /// Utilise `date_string` pour les equality queries Firestore.
  Future<bool> isEquipmentAvailable({
    required String equipmentId,
    required String dateString,
    required TimeSlot slot,
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Écriture — TOUTES les méthodes utilisent des transactions Firestore
  // ───────────────────────────────────────────────────────────────────────────

  /// Crée une location directe (élève).
  ///
  /// Transaction atomique :
  /// 1. Vérifie disponibilité (pas de conflit)
  /// 2. Crée equipment_rental
  /// 3. Débite le wallet de l'élève
  /// 4. Met à jour currentStatus de l'équipement à 'rented'
  ///
  /// Retourne l'ID du rental créé.
  Future<String> createStudentRental({
    required EquipmentRental rental,
    required int walletDebit,
  });

  /// Crée un assignment admin (validation réservation).
  ///
  /// Transaction atomique :
  /// 1. Vérifie disponibilité
  /// 2. Crée equipment_rental
  /// 3. Met à jour reservations.equipment_assignment_required = false
  /// 4. Met à jour currentStatus de l'équipement à 'rented'
  ///
  /// Retourne l'ID du rental créé.
  Future<String> createAdminAssignment({
    required EquipmentRental rental,
    required String reservationId,
  });

  /// Crée un assignment moniteur (obligatoire si admin skip).
  ///
  /// Transaction atomique :
  /// 1. Vérifie disponibilité
  /// 2. Crée equipment_rental
  /// 3. Met à jour reservations.equipment_assignment_required = false
  /// 4. Met à jour currentStatus de l'équipement à 'rented'
  ///
  /// Retourne l'ID du rental créé.
  Future<String> createInstructorAssignment({
    required EquipmentRental rental,
    required String reservationId,
  });

  /// Annule une location.
  ///
  /// Transaction atomique :
  /// 1. Met à jour status = 'cancelled'
  /// 2. Rembourse le wallet (si student_rental et paid)
  /// 3. Met à jour currentStatus de l'équipement à 'available'
  Future<void> cancelRental(String rentalId, String cancelledBy);

  /// Check-out d'un équipement.
  ///
  /// Transaction atomique :
  /// 1. Met à jour checked_out_at, checked_out_by, condition_at_checkout
  /// 2. Met à jour status = 'active'
  /// 3. Met à jour currentStatus de l'équipement à 'rented'
  Future<void> checkOut({
    required String rentalId,
    required String staffId,
    required String condition,
  });

  /// Check-in d'un équipement.
  ///
  /// Transaction atomique :
  /// 1. Met à jour checked_in_at, checked_in_by, condition_at_checkin, damage_notes
  /// 2. Met à jour status = 'completed'
  /// 3. Incrémente total_rentals de l'équipement
  /// 4. Met à jour currentStatus de l'équipement à 'available'
  Future<void> checkIn({
    required String rentalId,
    required String staffId,
    required String condition,
    String? damageNotes,
  });
}
