// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentCategoryImpl _$$EquipmentCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$EquipmentCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
      equipmentIds: (json['equipment_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$EquipmentCategoryImplToJson(
        _$EquipmentCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'is_active': instance.isActive,
      'equipment_ids': instance.equipmentIds,
    };
