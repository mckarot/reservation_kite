// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolSettingsImpl _$$SchoolSettingsImplFromJson(Map<String, dynamic> json) =>
    _$SchoolSettingsImpl(
      hours: OpeningHours.fromJson(json['hours'] as Map<String, dynamic>),
      daysOff: (json['days_off'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxStudentsPerInstructor:
          (json['max_students_per_instructor'] as num?)?.toInt() ?? 4,
      updatedAt: const TimestampConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$SchoolSettingsImplToJson(
        _$SchoolSettingsImpl instance) =>
    <String, dynamic>{
      'hours': instance.hours.toJson(),
      'days_off': instance.daysOff,
      'max_students_per_instructor': instance.maxStudentsPerInstructor,
      'updated_at': const TimestampConverter().toJson(instance.updatedAt),
    };

_$OpeningHoursImpl _$$OpeningHoursImplFromJson(Map<String, dynamic> json) =>
    _$OpeningHoursImpl(
      morning: TimeSlot.fromJson(json['morning'] as Map<String, dynamic>),
      afternoon: TimeSlot.fromJson(json['afternoon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpeningHoursImplToJson(_$OpeningHoursImpl instance) =>
    <String, dynamic>{
      'morning': instance.morning.toJson(),
      'afternoon': instance.afternoon.toJson(),
    };

_$TimeSlotImpl _$$TimeSlotImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotImpl(
      start: json['start'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$$TimeSlotImplToJson(_$TimeSlotImpl instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
