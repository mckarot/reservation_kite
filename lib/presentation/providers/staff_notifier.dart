import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/staff.dart';
import '../../data/providers/repository_providers.dart';

part 'staff_notifier.g.dart';

@riverpod
class StaffNotifier extends _$StaffNotifier {
  @override
  FutureOr<List<Staff>> build() async {
    return ref.watch(staffRepositoryProvider).getAllStaff();
  }

  Future<void> addStaff(Staff staff) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(staffRepositoryProvider).saveStaff(staff);
      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }

  Future<void> updateStaff(Staff staff) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(staffRepositoryProvider).saveStaff(staff);
      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }

  Future<void> deleteStaff(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(staffRepositoryProvider).deleteStaff(id);
      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }
}
