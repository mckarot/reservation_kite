import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class HiveNotificationRepository implements NotificationRepository {
  static const String _boxName = 'notifications';

  Future<Box<String>> _getBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  @override
  Future<List<AppNotification>> getNotifications(String userId) async {
    final box = await _getBox();
    return box.values
        .map((e) => AppNotification.fromJson(jsonDecode(e)))
        .where((n) => n.userId == userId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    final box = await _getBox();
    await box.put(notification.id, jsonEncode(notification.toJson()));
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final box = await _getBox();
    final data = box.get(notificationId);
    if (data != null) {
      final notif = AppNotification.fromJson(jsonDecode(data));
      final updated = notif.copyWith(isRead: true);
      await box.put(notificationId, jsonEncode(updated.toJson()));
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final box = await _getBox();
    await box.delete(notificationId);
  }
}
