import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../database/hive_config.dart';
import '../../domain/models/staff_unavailability.dart';
import '../../domain/models/reservation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'unavailability_notifier.g.dart';

@riverpod
class UnavailabilityNotifier extends _$UnavailabilityNotifier {
  late final Box<String> _box;

  @override
  FutureOr<List<StaffUnavailability>> build() async {
    _box = Hive.box<String>(HiveConfig.unavailabilitiesBox);
    return _loadUnavailabilities();
  }

  List<StaffUnavailability> _loadUnavailabilities() {
    return _box.values
        .map((s) => StaffUnavailability.fromJson(jsonDecode(s)))
        .toList();
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
      createdAt:
          DateTime.now(), // Devrait idéalement être serverTimestamp si en ligne
    );

    await _box.put(newEntry.id, jsonEncode(newEntry.toJson()));
    state = AsyncData([...state.value ?? [], newEntry]);
  }

  Future<void> updateStatus(String id, UnavailabilityStatus status) async {
    final list = state.value ?? [];
    final index = list.indexWhere((u) => u.id == id);
    if (index != -1) {
      final updated = list[index].copyWith(status: status);
      await _box.put(id, jsonEncode(updated.toJson()));

      final newList = [...list];
      newList[index] = updated;
      state = AsyncData(newList);
    }
  }

  Future<void> deleteRequest(String id) async {
    await _box.delete(id);
    state = AsyncData((state.value ?? []).where((u) => u.id != id).toList());
  }
}
