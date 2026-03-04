import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_assignment.freezed.dart';
part 'equipment_assignment.g.dart';

/// Assignment d'un équipement à un élève pour une séance.
///
/// Ce modèle permet à l'admin/moniteur de réserver du matériel
/// spécifique pour un élève lors d'une séance de cours.
@freezed
class EquipmentAssignment with _$EquipmentAssignment {
  const factory EquipmentAssignment({
    required String id,
    required String sessionId,
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String equipmentId,
    required String equipmentType,
    required String equipmentBrand,
    required String equipmentModel,
    required String equipmentSize,
    @JsonKey(name: 'date_string') required String dateString,
    @JsonKey(name: 'date_timestamp') required DateTime dateTimestamp,
    required String slot,
    required EquipmentAssignmentStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required String createdBy,
    String? notes,
  }) = _EquipmentAssignment;

  factory EquipmentAssignment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentAssignmentFromJson(json);
}

enum EquipmentAssignmentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}
