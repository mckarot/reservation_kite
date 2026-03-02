import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_notifier.dart';
import '../../domain/models/app_notification.dart';
import 'package:intl/intl.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(notificationNotifierProvider);
    
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myNotifications),
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
                    color: primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noNotificationsYet,
                    style: TextStyle(color: primaryColor.withOpacity(0.5)),
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
        error: (e, _) => Center(child: Text('${l10n.errorLabel}: $e')),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    
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
            : BorderSide(color: primaryColor.withOpacity(0.3), width: 1.5),
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
