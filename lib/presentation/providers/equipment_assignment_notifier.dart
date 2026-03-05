import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment_booking.dart';

part 'equipment_assignment_notifier.g.dart';

@riverpod
class EquipmentAssignmentNotifier extends _$EquipmentAssignmentNotifier {
  @override
  FutureOr<List<EquipmentBooking>> build(String sessionId) async {
    return _fetchAssignments(sessionId);
  }

  Future<List<EquipmentBooking>> _fetchAssignments(String sessionId) async {
    return ref
        .read(equipmentBookingRepositoryProvider)
        .getSessionBookings(sessionId);
  }

  Future<void> assignEquipment(EquipmentBooking booking) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(equipmentBookingRepositoryProvider).createBooking(booking);
      return _fetchAssignments(booking.sessionId!);
    });
  }

  Future<void> cancelAssignment(String bookingId, String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(equipmentBookingRepositoryProvider)
          .cancelBooking(bookingId);
      return _fetchAssignments(sessionId);
    });
  }

  Future<void> completeAssignment(String bookingId, String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(equipmentBookingRepositoryProvider)
          .completeBooking(bookingId);
      return _fetchAssignments(sessionId);
    });
  }
}
