import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'equipment_category.freezed.dart';
part 'equipment_category.g.dart';

@freezed
class EquipmentCategory with _$EquipmentCategory {
  const factory EquipmentCategory({
    required String id,
    required String nameFr,
    required String nameEn,
    required String icon,
    required int colorHex,
    required int displayOrder,
    @Default(true) bool isActive,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EquipmentCategory;

  factory EquipmentCategory.fromJson(Map<String, dynamic> json) =>
      _$EquipmentCategoryFromJson(json);
}
