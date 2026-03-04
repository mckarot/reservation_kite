import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';
part 'equipment.g.dart';

enum EquipmentStatus {
  @JsonValue('available')
  available,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('damaged')
  damaged,
  @JsonValue('reserved')
  reserved,
}

/// Historique de maintenance d'un équipement.
@freezed
class MaintenanceHistory with _$MaintenanceHistory {
  const factory MaintenanceHistory({
    required DateTime date,
    required String type,
    @Default('') String notes,
    @Default(0) num cost,
  }) = _MaintenanceHistory;

  factory MaintenanceHistory.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceHistoryFromJson(json);
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
    @JsonKey(name: 'serial_number') String? serialNumber,
    required EquipmentStatus status,
    @Default('') String notes,
    @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
    @JsonKey(name: 'last_maintenance_date') DateTime? lastMaintenanceDate,
    @JsonKey(name: 'maintenance_history')
    @Default([])
    List<MaintenanceHistory> maintenanceHistory,
    @JsonKey(name: 'total_bookings') @Default(0) int totalBookings,
    @JsonKey(name: 'total_quantity') @Default(1) int totalQuantity,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Champs de migration (optionnels)
    @JsonKey(name: 'migrated_from') String? migratedFrom,
    @JsonKey(name: 'migration_date') DateTime? migrationDate,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as String? ?? '',
      categoryId:
          (json['category_id'] ?? json['categoryId']) as String? ?? 'unknown',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      size: json['size'] as String? ?? '0',
      serialNumber: json['serial_number'] as String?,
      status: EquipmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EquipmentStatus.available,
      ),
      notes: json['notes'] as String? ?? '',
      purchaseDate: json['purchase_date'] is Timestamp
          ? (json['purchase_date'] as Timestamp).toDate()
          : null,
      lastMaintenanceDate: json['last_maintenance_date'] is Timestamp
          ? (json['last_maintenance_date'] as Timestamp).toDate()
          : null,
      maintenanceHistory: (json['maintenance_history'] as List?)
              ?.map((e) => MaintenanceHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalBookings: json['total_bookings'] as int? ?? 0,
      updatedAt: json['updated_at'] is Timestamp
          ? (json['updated_at'] as Timestamp).toDate()
          : DateTime.now(),
      migratedFrom: json['migrated_from'] as String?,
      migrationDate: json['migration_date'] is Timestamp
          ? (json['migration_date'] as Timestamp).toDate()
          : null,
    );
  }
}

/// Extension pour ajouter la méthode de conversion vers Firestore.
extension EquipmentFirestore on Equipment {
  /// Convertit l'équipement en données Firestore pour sauvegarde.
  Map<String, dynamic> toFirestoreData() {
    return {
      'id': id,
      'category_id': categoryId,
      'brand': brand,
      'model': model,
      'size': size,
      'serial_number': serialNumber,
      'status': status.name,
      'notes': notes,
      'purchase_date': purchaseDate != null ? Timestamp.fromDate(purchaseDate!) : null,
      'last_maintenance_date': lastMaintenanceDate != null
          ? Timestamp.fromDate(lastMaintenanceDate!)
          : null,
      'maintenance_history': maintenanceHistory
          .map((e) => {
                'date': Timestamp.fromDate(e.date),
                'type': e.type,
                'notes': e.notes,
                'cost': e.cost,
              })
          .toList(),
      'total_bookings': totalBookings,
      'total_quantity': totalQuantity,
      'updated_at': FieldValue.serverTimestamp(),
      if (migratedFrom != null) 'migrated_from': migratedFrom,
      if (migrationDate != null) 'migration_date': Timestamp.fromDate(migrationDate!),
    };
  }
}
