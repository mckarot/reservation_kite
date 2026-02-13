import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';
part 'equipment.g.dart';

enum EquipmentCategory { kite, board, bar, harness, other }

enum EquipmentStatus { available, maintenance, retired }

@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    required String id,
    required String brand,
    required String model,
    required String size, // ex: "12m", "138cm"
    required EquipmentCategory category,
    required EquipmentStatus status,
    String? notes,
    required DateTime createdAt,
    DateTime? lastMaintenance,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}
