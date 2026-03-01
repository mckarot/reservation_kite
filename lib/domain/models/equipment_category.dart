import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_category.freezed.dart';
part 'equipment_category.g.dart';

@freezed
class EquipmentCategory with _$EquipmentCategory {
  const factory EquipmentCategory({
    required String id,
    required String name,
    required int order,
    @Default(true) bool isActive,
    @Default([]) List<String> equipmentIds,
  }) = _EquipmentCategory;

  factory EquipmentCategory.fromJson(Map<String, Object?> json) =>
      _$EquipmentCategoryFromJson(json);
}
