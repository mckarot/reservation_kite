// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentBookingImpl _$$EquipmentBookingImplFromJson(
        Map<String, dynamic> json) =>
    _$EquipmentBookingImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      equipmentId: json['equipment_id'] as String,
      equipmentType: json['equipment_type'] as String,
      equipmentBrand: json['equipment_brand'] as String,
      equipmentModel: json['equipment_model'] as String,
      equipmentSize: _anyToString(json['equipment_size']),
      dateString: json['date_string'] as String,
      dateTimestamp: DateTime.parse(json['date_timestamp'] as String),
      slot: $enumDecode(_$EquipmentBookingSlotEnumMap, json['slot']),
      status: $enumDecode(_$EquipmentBookingStatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$EquipmentBookingTypeEnumMap, json['type']) ??
          EquipmentBookingType.student,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String,
      assignedBy: json['assigned_by'] as String?,
      sessionId: json['session_id'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$EquipmentBookingImplToJson(
        _$EquipmentBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'equipment_id': instance.equipmentId,
      'equipment_type': instance.equipmentType,
      'equipment_brand': instance.equipmentBrand,
      'equipment_model': instance.equipmentModel,
      'equipment_size': instance.equipmentSize,
      'date_string': instance.dateString,
      'date_timestamp': instance.dateTimestamp.toIso8601String(),
      'slot': _$EquipmentBookingSlotEnumMap[instance.slot]!,
      'status': _$EquipmentBookingStatusEnumMap[instance.status]!,
      'type': _$EquipmentBookingTypeEnumMap[instance.type]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_by': instance.createdBy,
      'assigned_by': instance.assignedBy,
      'session_id': instance.sessionId,
      'notes': instance.notes,
    };

const _$EquipmentBookingSlotEnumMap = {
  EquipmentBookingSlot.morning: 'morning',
  EquipmentBookingSlot.afternoon: 'afternoon',
  EquipmentBookingSlot.fullDay: 'full_day',
};

const _$EquipmentBookingStatusEnumMap = {
  EquipmentBookingStatus.confirmed: 'confirmed',
  EquipmentBookingStatus.cancelled: 'cancelled',
  EquipmentBookingStatus.completed: 'completed',
};

const _$EquipmentBookingTypeEnumMap = {
  EquipmentBookingType.student: 'student',
  EquipmentBookingType.assignment: 'assignment',
  EquipmentBookingType.staff: 'staff',
};
