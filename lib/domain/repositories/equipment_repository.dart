import '../models/equipment.dart';

/// Repository interface pour la gestion des équipements.
///
/// Chaque équipement est une entité physique unique avec un statut individuel.
abstract class EquipmentRepository {
  /// Récupère tous les équipements.
  Future<List<Equipment>> getAllEquipment();

  /// Récupère un équipement spécifique par son ID.
  Future<Equipment?> getEquipment(String id);

  /// Sauvegarde un équipement (création ou mise à jour).
  Future<void> saveEquipment(Equipment equipment);

  /// Supprime un équipement.
  Future<void> deleteEquipment(String id);

  /// Met à jour le statut d'un équipement.
  Future<void> updateStatus(String id, EquipmentStatus status);

  /// Réserve un équipement spécifique de manière ATOMIQUE.
  ///
  /// Utilise une transaction Firestore pour garantir que :
  /// - L'équipement existe
  /// - L'équipement est disponible (status = 'available')
  /// - La réservation est créée dans la même transaction
  ///
  /// Retourne `true` si la réservation a réussi, `false` si l'équipement
  /// n'était plus disponible (race condition).
  Future<bool> bookEquipmentAtomically({
    required String equipmentId,
    required Map<String, dynamic> bookingData,
  });

  /// Libère un équipement (annulation ou fin de session) — ATOMIQUE.
  ///
  /// Met à jour le statut de l'équipement à 'available' et change
  /// le statut de la réservation en une opération atomique.
  ///
  /// [newBookingStatus] doit être 'cancelled' ou 'completed'.
  Future<void> releaseEquipment({
    required String equipmentId,
    required String bookingId,
    required String newBookingStatus,
  });

  /// Compte les équipements disponibles pour une catégorie, date et créneau.
  ///
  /// Exclut les équipements :
  /// - Déjà réservés sur ce créneau
  /// - En maintenance ou endommagés
  Future<int> getAvailableCount({
    required String categoryId,
    required String dateString,
    required String slot,
  });

  /// Récupère les équipements disponibles pour une catégorie.
  Future<List<Equipment>> getAvailableEquipment(String categoryId);

  /// Watch les équipements d'une catégorie en temps réel.
  Stream<List<Equipment>> watchEquipmentByCategory(String categoryId);
}
