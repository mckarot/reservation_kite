// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) =>
    _$ReservationImpl(
      id: json['id'] as String,
      clientName: json['client_name'] as String,
      pupilId: json['pupil_id'] as String?,
      date: const TimestampConverter().fromJson(json['date']),
      slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
      staffId: json['staff_id'] as String?,
      status: $enumDecodeNullable(_$ReservationStatusEnumMap, json['status']) ??
          ReservationStatus.confirmed,
      notes: json['notes'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.clientName,
      'pupil_id': instance.pupilId,
      'date': const TimestampConverter().toJson(instance.date),
      'slot': _$TimeSlotEnumMap[instance.slot]!,
      'staff_id': instance.staffId,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
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
