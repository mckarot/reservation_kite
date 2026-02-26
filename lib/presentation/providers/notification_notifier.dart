import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/app_notification.dart';
import '../../data/providers/repository_providers.dart';
import 'auth_state_provider.dart';

part 'notification_notifier.g.dart';

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  FutureOr<List<AppNotification>> build() async {
    final userId = ref.watch(currentUserProvider).value?.id;
    if (userId == null) return [];
    return _fetchNotifications(userId);
  }

  Future<List<AppNotification>> _fetchNotifications(String userId) {
    return ref.read(notificationRepositoryProvider).getNotifications(userId);
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
  }) async {
    final notification = AppNotification(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );

    final repo = ref.read(notificationRepositoryProvider);
    await repo.saveNotification(notification);

    // Si c'est l'utilisateur actuellement connecté, on rafraîchit
    final currentUserId = ref.read(currentUserProvider).value?.id;
    if (currentUserId == userId) {
      state = AsyncData(await _fetchNotifications(userId));
    }
  }

  Future<void> markAsRead(String id) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    await ref.read(notificationRepositoryProvider).markAsRead(id);
    state = AsyncData(await _fetchNotifications(userId));
  }

  Future<void> deleteNotification(String id) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    await ref.read(notificationRepositoryProvider).deleteNotification(id);
    state = AsyncData(await _fetchNotifications(userId));
  }
}
