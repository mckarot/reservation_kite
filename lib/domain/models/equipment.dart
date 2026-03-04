import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';

enum EquipmentStatus {
  @JsonValue('available')
  available,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('damaged')
  damaged,
}

String _anyToString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String brand,
    required String model,
    @JsonKey(fromJson: _anyToString) required String size,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'total_quantity') @Default(1) int totalQuantity,
    @Default(EquipmentStatus.available) EquipmentStatus status,
    @Default('') String notes,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as String? ?? '',
      categoryId:
          (json['category_id'] ?? json['categoryId']) as String? ?? 'unknown',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      size: json['size'] as String? ?? '0',
      totalQuantity: json['total_quantity'] as int? ?? 1,
      status: EquipmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EquipmentStatus.available,
      ),
      updatedAt: json['updated_at'] is Timestamp
          ? (json['updated_at'] as Timestamp).toDate()
          : DateTime.now(),
      notes: json['notes'] as String? ?? '',
    );
  }
}
