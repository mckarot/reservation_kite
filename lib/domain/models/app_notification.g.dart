// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      timestamp: const TimestampConverter().fromJson(json['timestamp']),
      isRead: json['is_read'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
      'is_read': instance.isRead,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.info: 'info',
  NotificationType.success: 'success',
  NotificationType.alert: 'alert',
};
