import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/session.dart';
import '../../domain/repositories/session_repository.dart';

class FirestoreSessionRepository implements SessionRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'sessions';

  FirestoreSessionRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Session>> getAllSessions() async {
    final snapshot = await _collection
        .orderBy('date', descending: true)
        .limit(100)
        .get();
    return snapshot.docs
        .map((doc) => Session.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<Session?> getSession(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Session.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> saveSession(Session session) async {
    final data = session.toJson();

    final docRef = _collection.doc(session.id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      data['created_at'] = FieldValue.serverTimestamp();
    } else {
      data.remove('created_at');
    }

    await docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteSession(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<List<Session>> getSessionsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _collection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs
        .map((doc) => Session.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
