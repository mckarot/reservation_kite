// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentItemImpl _$$EquipmentItemImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$EquipmentCategoryTypeEnumMap, json['category'],
          unknownValue: EquipmentCategoryType.other),
      brand: json['brand'] as String,
      model: json['model'] as String,
      size: (json['size'] as num).toDouble(),
      color: json['color'] as String?,
      serialNumber: json['serial_number'] as String?,
      purchaseDate: const TimestampConverter().fromJson(json['purchase_date']),
      purchasePrice: (json['purchase_price'] as num).toInt(),
      rentalPriceMorning: (json['rental_price_morning'] as num).toInt(),
      rentalPriceAfternoon: (json['rental_price_afternoon'] as num).toInt(),
      rentalPriceFullDay: (json['rental_price_full_day'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
      currentStatus: $enumDecodeNullable(
              _$EquipmentCurrentStatusEnumMap, json['current_status'],
              unknownValue: EquipmentCurrentStatus.available) ??
          EquipmentCurrentStatus.available,
      condition: $enumDecodeNullable(
              _$EquipmentConditionEnumMap, json['condition'],
              unknownValue: EquipmentCondition.good) ??
          EquipmentCondition.good,
      totalRentals: (json['total_rentals'] as num?)?.toInt() ?? 0,
      lastMaintenanceDate:
          const TimestampConverter().fromJson(json['last_maintenance_date']),
      nextMaintenanceDate:
          const TimestampConverter().fromJson(json['next_maintenance_date']),
      notes: json['notes'] as String?,
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      updatedAt: const TimestampConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$EquipmentItemImplToJson(_$EquipmentItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': _$EquipmentCategoryTypeEnumMap[instance.category]!,
      'brand': instance.brand,
      'model': instance.model,
      'size': instance.size,
      'color': instance.color,
      'serial_number': instance.serialNumber,
      'purchase_date': _$JsonConverterToJson<dynamic, DateTime>(
          instance.purchaseDate, const TimestampConverter().toJson),
      'purchase_price': instance.purchasePrice,
      'rental_price_morning': instance.rentalPriceMorning,
      'rental_price_afternoon': instance.rentalPriceAfternoon,
      'rental_price_full_day': instance.rentalPriceFullDay,
      'is_active': instance.isActive,
      'current_status':
          _$EquipmentCurrentStatusEnumMap[instance.currentStatus]!,
      'condition': _$EquipmentConditionEnumMap[instance.condition]!,
      'total_rentals': instance.totalRentals,
      'last_maintenance_date': _$JsonConverterToJson<dynamic, DateTime>(
          instance.lastMaintenanceDate, const TimestampConverter().toJson),
      'next_maintenance_date': _$JsonConverterToJson<dynamic, DateTime>(
          instance.nextMaintenanceDate, const TimestampConverter().toJson),
      'notes': instance.notes,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'updated_at': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$EquipmentCategoryTypeEnumMap = {
  EquipmentCategoryType.kite: 'kite',
  EquipmentCategoryType.board: 'board',
  EquipmentCategoryType.foil: 'foil',
  EquipmentCategoryType.harness: 'harness',
  EquipmentCategoryType.wing: 'wing',
  EquipmentCategoryType.other: 'other',
};

const _$EquipmentCurrentStatusEnumMap = {
  EquipmentCurrentStatus.available: 'available',
  EquipmentCurrentStatus.rented: 'rented',
  EquipmentCurrentStatus.maintenance: 'maintenance',
};

const _$EquipmentConditionEnumMap = {
  EquipmentCondition.newCondition: 'new',
  EquipmentCondition.good: 'good',
  EquipmentCondition.fair: 'fair',
  EquipmentCondition.poor: 'poor',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
