import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';
part 'equipment.g.dart';

enum EquipmentType {
  @JsonValue('kite')
  kite,
  @JsonValue('board')
  board,
  @JsonValue('harness')
  harness,
  @JsonValue('other')
  other,
}

enum EquipmentStatus {
  @JsonValue('available')
  available,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('damaged')
  damaged,
}

@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    required String id,
    required EquipmentType type,
    required String brand,
    required String model,
    required String size,
    @Default(EquipmentStatus.available) EquipmentStatus status,
    @Default('') String notes,
    required DateTime updatedAt,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}
