import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/equipment_booking.dart';
import '../models/equipment.dart';
import '../models/equipment_with_availability.dart';

/// Repository interface pour les réservations de matériel.
///
/// Définit les contrats pour toutes les opérations liées aux réservations
/// d'équipements (location de matériel sans cours).
abstract class EquipmentBookingRepository {
  /// Crée une nouvelle réservation de matériel.
  ///
  /// Utilise une transaction Firestore pour garantir l'atomicité :
  /// - Vérification de la disponibilité
  /// - Vérification de la limite de 3 réservations actives par utilisateur
  /// - Création de la réservation
  ///
  /// Lance une exception si :
  /// - L'équipement n'existe pas
  /// - Le matériel n'est pas disponible pour ce créneau
  /// - L'utilisateur a atteint sa limite de réservations actives
  Future<String> createBooking(EquipmentBooking booking);

  /// Annule une réservation existante.
  ///
  /// Change le statut à 'cancelled'. La disponibilité est recalculée
  /// dynamiquement, donc pas besoin de réincrémentation.
  Future<void> cancelBooking(String bookingId);

  /// Marque une réservation comme complétée (après utilisation).
  Future<void> completeBooking(String bookingId);

  /// Récupère l'historique des réservations d'un utilisateur.
  ///
  /// Retourne les 50 dernières réservations, triées par date décroissante.
  Future<List<EquipmentBooking>> getUserBookings(String userId);

  /// Récupère toutes les réservations pour une date donnée.
  ///
  /// Utile pour l'administration ou la vue calendrier.
  Future<List<EquipmentBooking>> getBookingsByDate(DateTime date);

  /// Récupère toutes les réservations pour un équipement donné.
  ///
  /// Utile pour la gestion du matériel (maintenance, planning).
  Future<List<EquipmentBooking>> getEquipmentBookings(String equipmentId);

  /// Stream en temps réel des réservations d'un utilisateur.
  ///
  /// Se met à jour automatiquement lors des ajouts/suppressions.
  Stream<List<EquipmentBooking>> watchUserBookings(String userId);

  /// Stream en temps réel de la disponibilité d'un équipement.
  ///
  /// Calcule dynamiquement : total_quantity - réservations_actives
  /// Se met à jour en temps réel lors des nouvelles réservations.
  Stream<EquipmentWithAvailability> watchEquipmentAvailability({
    required String equipmentId,
    required DateTime date,
    required EquipmentBookingSlot slot,
  });
}
