import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'equipment.freezed.dart';

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
    required String categoryId,
    required String brand,
    required String model,
    required String size,
    @Default(EquipmentStatus.available) EquipmentStatus status,
    @Default('') String notes,
    required DateTime updatedAt,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) {
    // Migration: ancien champ 'type' vers nouveau champ 'categoryId'
    String categoryId;
    
    // Le champ dans Firestore est 'category_id' (avec underscore)
    if (json['category_id'] != null && json['category_id'] != '') {
      categoryId = json['category_id'] as String;
    } else if (json['type'] != null) {
      // Ancien format : mapper le type vers une catégorie par défaut
      final oldType = json['type'] as String;
      categoryId = _mapOldTypeToCategory(oldType);
    } else {
      categoryId = 'unknown';
    }
    
    return Equipment(
      id: json['id'] as String,
      categoryId: categoryId,
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      size: json['size'] as String? ?? '',
      status: EquipmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EquipmentStatus.available,
      ),
      notes: json['notes'] as String? ?? '',
      updatedAt: _parseTimestamp(json['updated_at']),
    );
  }

  static String _mapOldTypeToCategory(String oldType) {
    // Mapping des anciens types vers les nouvelles catégories
    // Ce sont des IDs de documents qu'on devra mapper manuellement
    switch (oldType.toLowerCase()) {
      case 'kite':
      case 'kites':
        return 'kite'; // ID du document dans equipment_categories
      case 'foil':
      case 'foils':
        return 'foil';
      case 'board':
      case 'boards':
        return 'board';
      case 'harness':
      case 'harnesses':
        return 'harness';
      case 'wetsuit':
      case 'combinaison':
        return 'wetsuit';
      case 'accessory':
      case 'accessories':
      case 'other':
      default:
        return 'accessories';
    }
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }
}
