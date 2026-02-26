import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/staff_unavailability.dart';
import '../../domain/repositories/availability_repository.dart';

class FirestoreAvailabilityRepository implements AvailabilityRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'availabilities';

  FirestoreAvailabilityRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<StaffUnavailability>> getAvailabilities(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _collection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs
        .map((doc) => StaffUnavailability.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> saveAvailability(StaffUnavailability availability) async {
    final data = availability.toJson();
    data['updated_at'] = FieldValue.serverTimestamp();

    await _collection.doc(availability.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteAvailability(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<List<StaffUnavailability>> getInstructorAvailabilities(
    String instructorId,
  ) async {
    final snapshot = await _collection
        .where('instructor_id', isEqualTo: instructorId)
        .limit(100)
        .get();

    return snapshot.docs
        .map((doc) => StaffUnavailability.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<StaffUnavailability>> getAllAvailabilities() async {
    final snapshot = await _collection.limit(200).get();
    return snapshot.docs
        .map((doc) => StaffUnavailability.fromJson(doc.data()))
        .toList();
  }
}
