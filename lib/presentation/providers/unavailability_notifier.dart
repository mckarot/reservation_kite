import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/staff_unavailability.dart';
import '../../domain/models/reservation.dart';
import '../../data/providers/repository_providers.dart';

part 'unavailability_notifier.g.dart';

@riverpod
class UnavailabilityNotifier extends _$UnavailabilityNotifier {
  @override
  FutureOr<List<StaffUnavailability>> build() async {
    return ref.read(availabilityRepositoryProvider).getAllAvailabilities();
  }

  Future<void> loadForInstructor(String instructorId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref
          .read(availabilityRepositoryProvider)
          .getInstructorAvailabilities(instructorId);
    });
  }

  Future<void> requestUnavailability({
    required String staffId,
    required DateTime date,
    required TimeSlot slot,
    required String reason,
  }) async {
    final newEntry = StaffUnavailability(
      id: const Uuid().v4(),
      staffId: staffId,
      date: DateTime(date.year, date.month, date.day),
      slot: slot,
      reason: reason,
      status: UnavailabilityStatus.pending,
      createdAt: DateTime.now(),
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(availabilityRepositoryProvider).saveAvailability(newEntry);

      // On recharge ou on met à jour l'état local
      final current = state.value ?? [];
      return [...current, newEntry];
    });
  }

  Future<void> updateStatus(String id, UnavailabilityStatus status) async {
    final list = state.value ?? [];
    final index = list.indexWhere((u) => u.id == id);
    if (index != -1) {
      final updated = list[index].copyWith(status: status);

      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        await ref
            .read(availabilityRepositoryProvider)
            .saveAvailability(updated);
        final newList = [...list];
        newList[index] = updated;
        return newList;
      });
    }
  }

  Future<void> deleteRequest(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(availabilityRepositoryProvider).deleteAvailability(id);
      return (state.value ?? []).where((u) => u.id != id).toList();
    });
  }
}
