import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/equipment.dart';
import '../../data/providers/repository_providers.dart';

part 'equipment_notifier.g.dart';

@riverpod
class EquipmentNotifier extends _$EquipmentNotifier {
  @override
  FutureOr<List<Equipment>> build() async {
    return _fetchEquipment();
  }

  Future<List<Equipment>> _fetchEquipment() {
    return ref.read(equipmentRepositoryProvider).getAllEquipment();
  }

  Future<void> addEquipment(Equipment equipment) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(equipmentRepositoryProvider).saveEquipment(equipment);
      return _fetchEquipment();
    });
  }

  Future<void> updateStatus(String id, EquipmentStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(equipmentRepositoryProvider);
      final equip = await repo.getEquipment(id);
      if (equip != null) {
        final updated = equip.copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
        await repo.saveEquipment(updated);
      }
      return _fetchEquipment();
    });
  }

  Future<void> deleteEquipment(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(equipmentRepositoryProvider).deleteEquipment(id);
      return _fetchEquipment();
    });
  }
}
