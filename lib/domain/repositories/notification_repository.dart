import '../models/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications(String userId);
  Future<void> saveNotification(AppNotification notification);
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}
