// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_unavailability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffUnavailabilityImpl _$$StaffUnavailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffUnavailabilityImpl(
      id: json['id'] as String,
      staffId: json['instructor_id'] as String,
      date: const TimestampConverter().fromJson(json['date']),
      slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
      reason: json['reason'] as String,
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      status:
          $enumDecodeNullable(_$UnavailabilityStatusEnumMap, json['status']) ??
              UnavailabilityStatus.pending,
    );

Map<String, dynamic> _$$StaffUnavailabilityImplToJson(
        _$StaffUnavailabilityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instructor_id': instance.staffId,
      'date': const TimestampConverter().toJson(instance.date),
      'slot': _$TimeSlotEnumMap[instance.slot]!,
      'reason': instance.reason,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'status': _$UnavailabilityStatusEnumMap[instance.status]!,
    };

const _$TimeSlotEnumMap = {
  TimeSlot.morning: 'morning',
  TimeSlot.afternoon: 'afternoon',
  TimeSlot.fullDay: 'fullDay',
};

const _$UnavailabilityStatusEnumMap = {
  UnavailabilityStatus.pending: 'pending',
  UnavailabilityStatus.approved: 'approved',
  UnavailabilityStatus.rejected: 'rejected',
};
