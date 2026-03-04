// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentAssignmentImpl _$$EquipmentAssignmentImplFromJson(
        Map<String, dynamic> json) =>
    _$EquipmentAssignmentImpl(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      studentEmail: json['student_email'] as String,
      equipmentId: json['equipment_id'] as String,
      equipmentType: json['equipment_type'] as String,
      equipmentBrand: json['equipment_brand'] as String,
      equipmentModel: json['equipment_model'] as String,
      equipmentSize: json['equipment_size'] as String,
      dateString: json['date_string'] as String,
      dateTimestamp: DateTime.parse(json['date_timestamp'] as String),
      slot: json['slot'] as String,
      status: $enumDecode(_$EquipmentAssignmentStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$EquipmentAssignmentImplToJson(
        _$EquipmentAssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'student_email': instance.studentEmail,
      'equipment_id': instance.equipmentId,
      'equipment_type': instance.equipmentType,
      'equipment_brand': instance.equipmentBrand,
      'equipment_model': instance.equipmentModel,
      'equipment_size': instance.equipmentSize,
      'date_string': instance.dateString,
      'date_timestamp': instance.dateTimestamp.toIso8601String(),
      'slot': instance.slot,
      'status': _$EquipmentAssignmentStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_by': instance.createdBy,
      'notes': instance.notes,
    };

const _$EquipmentAssignmentStatusEnumMap = {
  EquipmentAssignmentStatus.pending: 'pending',
  EquipmentAssignmentStatus.confirmed: 'confirmed',
  EquipmentAssignmentStatus.cancelled: 'cancelled',
  EquipmentAssignmentStatus.completed: 'completed',
};
