import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment_item.dart';
import '../../domain/models/reservation.dart';
import '../../utils/date_utils.dart';

part 'equipment_notifier.g.dart';

/// Provider pour l'état des équipements (parc matériel).
@riverpod
class EquipmentNotifier extends _$EquipmentNotifier {
  @override
  FutureOr<List<EquipmentItem>> build() {
    return _fetchAllEquipment();
  }

  Future<List<EquipmentItem>> _fetchAllEquipment() async {
    return ref.read(equipmentRepositoryProvider).getAllEquipment();
  }

  /// Stream pour les équipements actifs.
  Stream<List<EquipmentItem>> watchActiveEquipment() {
    return ref.read(equipmentRepositoryProvider).watchActiveEquipment();
  }

  /// Récupère un équipement par ID.
  Future<EquipmentItem?> getEquipmentById(String id) async {
    return ref.read(equipmentRepositoryProvider).getEquipmentById(id);
  }

  /// Récupère les équipements par catégorie.
  Future<List<EquipmentItem>> getEquipmentByCategory(
      EquipmentCategoryType category) async {
    return ref.read(equipmentRepositoryProvider).getEquipmentByCategory(category);
  }

  /// Sauvegarde un équipement (création ou mise à jour).
  Future<void> saveEquipment(EquipmentItem equipment) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(equipmentRepositoryProvider).saveEquipment(equipment);
      return _fetchAllEquipment();
    });
  }

  /// Désactive un équipement.
  Future<void> deactivateEquipment(String id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(equipmentRepositoryProvider).deactivateEquipment(id);
      return _fetchAllEquipment();
    });
  }

  /// Met à jour le statut d'un équipement.
  Future<void> updateEquipmentStatus(String id, EquipmentCurrentStatus status) async {
    state = await AsyncValue.guard(() async {
      await ref.read(equipmentRepositoryProvider).updateEquipmentStatus(id, status);
      return _fetchAllEquipment();
    });
  }

  /// Vérifie la disponibilité d'un équipement.
  Future<bool> isEquipmentAvailable({
    required String equipmentId,
    required DateTime date,
    required TimeSlot slot,
  }) async {
    final dateString = formatDateForQuery(date);
    return ref.read(equipmentRentalRepositoryProvider).isEquipmentAvailable(
          equipmentId: equipmentId,
          dateString: dateString,
          slot: slot,
        );
  }
}
