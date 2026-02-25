// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      date: const TimestampConverter().fromJson(json['date']),
      slot: json['slot'] as String,
      instructorId: json['instructor_id'] as String,
      studentIds: (json['student_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxCapacity: (json['max_capacity'] as num).toInt(),
      status: json['status'] as String? ?? 'scheduled',
      createdAt: const TimestampConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': const TimestampConverter().toJson(instance.date),
      'slot': instance.slot,
      'instructor_id': instance.instructorId,
      'student_ids': instance.studentIds,
      'max_capacity': instance.maxCapacity,
      'status': instance.status,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
    };
