// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) =>
    _$ReservationImpl(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      pupilId: json['pupilId'] as String?,
      date: DateTime.parse(json['date'] as String),
      slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
      staffId: json['staffId'] as String?,
      confirmed: json['confirmed'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientName': instance.clientName,
      'pupilId': instance.pupilId,
      'date': instance.date.toIso8601String(),
      'slot': _$TimeSlotEnumMap[instance.slot]!,
      'staffId': instance.staffId,
      'confirmed': instance.confirmed,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TimeSlotEnumMap = {
  TimeSlot.morning: 'morning',
  TimeSlot.afternoon: 'afternoon',
};
