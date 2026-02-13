// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentImpl _$$EquipmentImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentImpl(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      size: json['size'] as String,
      category: $enumDecode(_$EquipmentCategoryEnumMap, json['category']),
      status: $enumDecode(_$EquipmentStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMaintenance: json['lastMaintenance'] == null
          ? null
          : DateTime.parse(json['lastMaintenance'] as String),
    );

Map<String, dynamic> _$$EquipmentImplToJson(_$EquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'model': instance.model,
      'size': instance.size,
      'category': _$EquipmentCategoryEnumMap[instance.category]!,
      'status': _$EquipmentStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMaintenance': instance.lastMaintenance?.toIso8601String(),
    };

const _$EquipmentCategoryEnumMap = {
  EquipmentCategory.kite: 'kite',
  EquipmentCategory.board: 'board',
  EquipmentCategory.bar: 'bar',
  EquipmentCategory.harness: 'harness',
  EquipmentCategory.other: 'other',
};

const _$EquipmentStatusEnumMap = {
  EquipmentStatus.available: 'available',
  EquipmentStatus.maintenance: 'maintenance',
  EquipmentStatus.retired: 'retired',
};
