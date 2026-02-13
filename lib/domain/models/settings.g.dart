// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolSettingsImpl _$$SchoolSettingsImplFromJson(Map<String, dynamic> json) =>
    _$SchoolSettingsImpl(
      hours: OpeningHours.fromJson(json['hours'] as Map<String, dynamic>),
      daysOff: (json['daysOff'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxStudentsPerInstructor:
          (json['maxStudentsPerInstructor'] as num?)?.toInt() ?? 4,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SchoolSettingsImplToJson(
        _$SchoolSettingsImpl instance) =>
    <String, dynamic>{
      'hours': instance.hours,
      'daysOff': instance.daysOff,
      'maxStudentsPerInstructor': instance.maxStudentsPerInstructor,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$OpeningHoursImpl _$$OpeningHoursImplFromJson(Map<String, dynamic> json) =>
    _$OpeningHoursImpl(
      morning: TimeSlot.fromJson(json['morning'] as Map<String, dynamic>),
      afternoon: TimeSlot.fromJson(json['afternoon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpeningHoursImplToJson(_$OpeningHoursImpl instance) =>
    <String, dynamic>{
      'morning': instance.morning,
      'afternoon': instance.afternoon,
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
