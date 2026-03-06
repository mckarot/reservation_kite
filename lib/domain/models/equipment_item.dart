import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'equipment_item.freezed.dart';
part 'equipment_item.g.dart';

enum EquipmentCategoryType {
  @JsonValue('kite') kite,
  @JsonValue('board') board,
  @JsonValue('foil') foil,
  @JsonValue('harness') harness,
  @JsonValue('wing') wing,
  @JsonValue('other') other,
}

enum EquipmentCondition {
  @JsonValue('new') newCondition,
  @JsonValue('good') good,
  @JsonValue('fair') fair,
  @JsonValue('poor') poor,
}

enum EquipmentCurrentStatus {
  @JsonValue('available') available,
  @JsonValue('rented') rented,
  @JsonValue('maintenance') maintenance,
}

@freezed
class EquipmentItem with _$EquipmentItem {
  const factory EquipmentItem({
    required String id,
    required String name,
    @JsonKey(unknownEnumValue: EquipmentCategoryType.other) required EquipmentCategoryType category,
    required String brand,
    required String model,
    required double size,
    String? color,
    String? serialNumber,
    @TimestampConverter() DateTime? purchaseDate,
    required int purchasePrice,
    required int rentalPriceMorning,
    required int rentalPriceAfternoon,
    required int rentalPriceFullDay,
    @Default(true) bool isActive,
    @Default(EquipmentCurrentStatus.available) @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available) EquipmentCurrentStatus currentStatus,
    @Default(EquipmentCondition.good) @JsonKey(unknownEnumValue: EquipmentCondition.good) EquipmentCondition condition,
    @Default(0) int totalRentals,
    @TimestampConverter() DateTime? lastMaintenanceDate,
    @TimestampConverter() DateTime? nextMaintenanceDate,
    String? notes,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EquipmentItem;

  factory EquipmentItem.fromJson(Map<String, dynamic> json) =>
      _$EquipmentItemFromJson(json);
}
