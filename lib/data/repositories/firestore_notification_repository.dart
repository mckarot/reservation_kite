import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class FirestoreNotificationRepository implements NotificationRepository {
  final FirebaseFirestore _firestore;

  FirestoreNotificationRepository(this._firestore);

  @override
  Future<List<AppNotification>> getNotifications(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AppNotification.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toJson());
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }
}
