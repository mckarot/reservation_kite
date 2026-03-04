// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaintenanceHistoryImpl _$$MaintenanceHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$MaintenanceHistoryImpl(
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      notes: json['notes'] as String? ?? '',
      cost: json['cost'] as num? ?? 0,
    );

Map<String, dynamic> _$$MaintenanceHistoryImplToJson(
        _$MaintenanceHistoryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'notes': instance.notes,
      'cost': instance.cost,
    };
