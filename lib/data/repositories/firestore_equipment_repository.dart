import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment.dart';
import '../../domain/repositories/equipment_repository.dart';

class FirestoreEquipmentRepository implements EquipmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'equipment';

  FirestoreEquipmentRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Equipment>> getAllEquipment() async {
    final snapshot = await _collection.limit(100).get();

    return snapshot.docs
        .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<Equipment?> getEquipment(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Equipment.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> saveEquipment(Equipment equipment) async {
    final data = {
      'id': equipment.id,
      'category_id': equipment.categoryId,
      'brand': equipment.brand,
      'model': equipment.model,
      'size': equipment.size,
      'status': equipment.status.name,
      'notes': equipment.notes,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _collection.doc(equipment.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await _collection.doc(id).delete();
  }
}
