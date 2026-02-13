// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      slot: json['slot'] as String,
      instructorId: json['instructorId'] as String,
      studentIds: (json['studentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxCapacity: (json['maxCapacity'] as num).toInt(),
      status: json['status'] as String? ?? 'scheduled',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'slot': instance.slot,
      'instructorId': instance.instructorId,
      'studentIds': instance.studentIds,
      'maxCapacity': instance.maxCapacity,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
