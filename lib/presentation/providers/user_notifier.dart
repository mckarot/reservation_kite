import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user.dart';
import '../../data/providers/repository_providers.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<List<User>> build() async {
    return _fetchUsers();
  }

  Future<List<User>> _fetchUsers() {
    return ref.read(userRepositoryProvider).getAllUsers();
  }

  Future<void> addUser(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).saveUser(user);
      return _fetchUsers();
    });
  }

  Future<void> updateBalance(String userId, int newBalance) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      final user = await repo.getUser(userId);
      if (user != null) {
        final updatedUser = user.copyWith(
          walletBalance: newBalance,
          lastSeen: DateTime.now(),
        );
        await repo.saveUser(updatedUser);
      }
      return _fetchUsers();
    });
  }

  Future<void> updateProgress(String userId, UserProgress progress) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      final user = await repo.getUser(userId);
      if (user != null) {
        final updatedUser = user.copyWith(
          progress: progress,
          lastSeen: DateTime.now(),
        );
        await repo.saveUser(updatedUser);
      }
      return _fetchUsers();
    });
  }

  Future<void> addNote(String userId, UserNote note) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      final user = await repo.getUser(userId);
      if (user != null) {
        final currentProgress = user.progress ?? const UserProgress();
        final updatedProgress = currentProgress.copyWith(
          notes: [...currentProgress.notes, note],
        );
        final updatedUser = user.copyWith(
          progress: updatedProgress,
          lastSeen: DateTime.now(),
        );
        await repo.saveUser(updatedUser);
      }
      return _fetchUsers();
    });
  }

  Future<void> deleteUser(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).deleteUser(id);
      return _fetchUsers();
    });
  }
}
