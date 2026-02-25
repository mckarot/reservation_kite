// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentImpl _$$EquipmentImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentImpl(
      id: json['id'] as String,
      type: $enumDecode(_$EquipmentTypeEnumMap, json['type']),
      brand: json['brand'] as String,
      model: json['model'] as String,
      size: json['size'] as String,
      status: $enumDecodeNullable(_$EquipmentStatusEnumMap, json['status']) ??
          EquipmentStatus.available,
      notes: json['notes'] as String? ?? '',
      updatedAt: const TimestampConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$EquipmentImplToJson(_$EquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EquipmentTypeEnumMap[instance.type]!,
      'brand': instance.brand,
      'model': instance.model,
      'size': instance.size,
      'status': _$EquipmentStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'updated_at': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$EquipmentTypeEnumMap = {
  EquipmentType.kite: 'kite',
  EquipmentType.board: 'board',
  EquipmentType.harness: 'harness',
  EquipmentType.other: 'other',
};

const _$EquipmentStatusEnumMap = {
  EquipmentStatus.available: 'available',
  EquipmentStatus.maintenance: 'maintenance',
  EquipmentStatus.damaged: 'damaged',
};
