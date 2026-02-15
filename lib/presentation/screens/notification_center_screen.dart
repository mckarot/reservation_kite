import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_notifier.dart';
import '../../domain/models/app_notification.dart';
import 'package:intl/intl.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notifications'),
        actions: [
          notificationsAsync
                  .whenData(
                    (notifs) => notifs.isEmpty
                        ? const SizedBox()
                        : IconButton(
                            icon: const Icon(Icons.delete_sweep),
                            onPressed: () {
                              // Optionnel: Tout supprimer
                            },
                          ),
                  )
                  .value ??
              const SizedBox(),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifs) {
          if (notifs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucune notification pour le moment.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifs.length,
            itemBuilder: (context, index) {
              final n = notifs[index];
              return _NotificationTile(notification: n);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.success:
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case NotificationType.alert:
        iconData = Icons.error_outline;
        iconColor = Colors.red;
        break;
      case NotificationType.info:
        iconData = Icons.info_outline;
        iconColor = Colors.blue;
        break;
    }

    return Card(
      elevation: notification.isRead ? 0 : 4,
      margin: const EdgeInsets.only(bottom: 12),
      color: notification.isRead ? Colors.grey.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: notification.isRead
            ? BorderSide(color: Colors.grey.shade200)
            : BorderSide(color: Colors.blue.withOpacity(0.3), width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 8),
            Text(
              DateFormat('dd/MM à HH:mm').format(notification.timestamp),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            ref
                .read(notificationNotifierProvider.notifier)
                .markAsRead(notification.id);
          }
        },
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => ref
              .read(notificationNotifierProvider.notifier)
              .deleteNotification(notification.id),
        ),
      ),
    );
  }
}
