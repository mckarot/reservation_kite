import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment_assignment.dart';

part 'equipment_assignment_notifier.g.dart';

@riverpod
class EquipmentAssignmentNotifier extends _$EquipmentAssignmentNotifier {
  @override
  FutureOr<List<EquipmentAssignment>> build(String sessionId) async {
    return _fetchAssignments(sessionId);
  }

  Future<List<EquipmentAssignment>> _fetchAssignments(String sessionId) async {
    return ref
        .read(equipmentAssignmentRepositoryProvider)
        .getSessionAssignments(sessionId);
  }

  Future<void> assignEquipment(EquipmentAssignment assignment) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(equipmentAssignmentRepositoryProvider)
          .assignEquipment(assignment);
      return _fetchAssignments(assignment.sessionId);
    });
  }

  Future<void> cancelAssignment(String assignmentId, String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(equipmentAssignmentRepositoryProvider)
          .cancelAssignment(assignmentId);
      return _fetchAssignments(sessionId);
    });
  }

  Future<void> completeAssignment(String assignmentId, String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(equipmentAssignmentRepositoryProvider)
          .completeAssignment(assignmentId);
      return _fetchAssignments(sessionId);
    });
  }
}
