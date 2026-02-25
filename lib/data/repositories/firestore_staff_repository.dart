import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/staff.dart';
import '../../domain/repositories/staff_repository.dart';

class FirestoreStaffRepository implements StaffRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'staff';

  FirestoreStaffRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Staff>> getAllStaff() async {
    final snapshot = await _collection
        .orderBy('is_active', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => Staff.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> saveStaff(Staff staff) async {
    final data = staff.toJson();
    data['updated_at'] = FieldValue.serverTimestamp();

    await _collection.doc(staff.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteStaff(String id) async {
    await _collection.doc(id).delete();
  }
}
