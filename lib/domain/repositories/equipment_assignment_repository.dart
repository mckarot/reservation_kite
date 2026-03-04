import '../models/equipment_assignment.dart';

/// Repository interface pour les assignments d'équipements aux élèves.
abstract class EquipmentAssignmentRepository {
  /// Assigner un équipement spécifique à un élève pour une séance.
  Future<String> assignEquipment(EquipmentAssignment assignment);

  /// Annuler un assignment.
  Future<void> cancelAssignment(String assignmentId);

  /// Marquer un assignment comme complété.
  Future<void> completeAssignment(String assignmentId);

  /// Récupérer tous les assignments pour une séance.
  Future<List<EquipmentAssignment>> getSessionAssignments(String sessionId);

  /// Récupérer les assignments d'un élève.
  Future<List<EquipmentAssignment>> getStudentAssignments(String studentId);

  /// Stream en temps réel des assignments pour une séance.
  Stream<List<EquipmentAssignment>> watchSessionAssignments(String sessionId);

  /// Stream en temps réel des assignments d'un élève.
  Stream<List<EquipmentAssignment>> watchStudentAssignments(String studentId);

  /// Vérifier si un équipement est déjà assigné pour une séance donnée.
  Future<bool> isEquipmentAssigned({
    required String equipmentId,
    required String sessionId,
  });

  /// Récupérer les équipements disponibles pour une séance (non assignés).
  Future<List<String>> getAvailableEquipmentIds({
    required String sessionId,
    required String category,
  });
}
