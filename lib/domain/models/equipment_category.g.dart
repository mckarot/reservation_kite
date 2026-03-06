// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentCategoryImpl _$$EquipmentCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$EquipmentCategoryImpl(
      id: json['id'] as String,
      nameFr: json['name_fr'] as String,
      nameEn: json['name_en'] as String,
      icon: json['icon'] as String,
      colorHex: (json['color_hex'] as num).toInt(),
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      updatedAt: const TimestampConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$EquipmentCategoryImplToJson(
        _$EquipmentCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_fr': instance.nameFr,
      'name_en': instance.nameEn,
      'icon': instance.icon,
      'color_hex': instance.colorHex,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'updated_at': const TimestampConverter().toJson(instance.updatedAt),
    };
