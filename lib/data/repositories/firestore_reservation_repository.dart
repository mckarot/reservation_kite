import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reservation.dart';
import '../../domain/repositories/reservation_repository.dart';

class FirestoreReservationRepository implements ReservationRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'reservations';

  FirestoreReservationRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Reservation>> getAllReservations() async {
    final snapshot = await _collection
        .orderBy('date', descending: true)
        .limit(200)
        .get();

    return snapshot.docs
        .map((doc) => Reservation.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> saveReservation(Reservation reservation) async {
    final data = reservation.toJson();

    // Pour Firestore, on utilise serverTimestamp pour les dates système
    // Mais ici on garde la date du cours telle quelle.

    await _collection.doc(reservation.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteReservation(String id) async {
    await _collection.doc(id).delete();
  }
}
