// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) =>
    _$ReservationImpl(
      id: json['id'] as String,
      clientName: json['client_name'] as String,
      date: const TimestampConverter().fromJson(json['date']),
      slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      pupilId: json['pupil_id'] as String?,
      staffId: json['staff_id'] as String?,
      status: $enumDecodeNullable(_$ReservationStatusEnumMap, json['status']) ??
          ReservationStatus.confirmed,
      notes: json['notes'] as String? ?? '',
      equipmentAssignmentRequired:
          json['equipment_assignment_required'] as bool? ?? false,
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.clientName,
      'date': const TimestampConverter().toJson(instance.date),
      'slot': _$TimeSlotEnumMap[instance.slot]!,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'pupil_id': instance.pupilId,
      'staff_id': instance.staffId,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'equipment_assignment_required': instance.equipmentAssignmentRequired,
    };

const _$TimeSlotEnumMap = {
  TimeSlot.morning: 'morning',
  TimeSlot.afternoon: 'afternoon',
  TimeSlot.fullDay: 'fullDay',
};

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'pending',
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.cancelled: 'cancelled',
};
