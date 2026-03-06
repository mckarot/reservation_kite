import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment_item.dart';
import '../../domain/repositories/equipment_repository.dart';

/// Implémentation Firestore du repository Equipment.
class FirestoreEquipmentRepository implements EquipmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'equipment_items';

  FirestoreEquipmentRepository(this._firestore);

  /// Expose Firestore pour les services d'initialisation.
  FirebaseFirestore get firestore => _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<EquipmentItem>> getAllEquipment() async {
    final snapshot = await _collection
        .orderBy('category', descending: false)
        .orderBy('name', descending: false)
        .limit(500)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentItem.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<EquipmentItem?> getEquipmentById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return EquipmentItem.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<List<EquipmentItem>> getEquipmentByCategory(
      EquipmentCategoryType category) async {
    final snapshot = await _collection
        .where('category', isEqualTo: category.name)
        .where('is_active', isEqualTo: true)
        .orderBy('name', descending: false)
        .limit(200)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentItem.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Stream<List<EquipmentItem>> watchActiveEquipment() {
    return _collection
        .where('is_active', isEqualTo: true)
        .orderBy('category', descending: false)
        .orderBy('name', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentItem.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }

  @override
  Future<void> saveEquipment(EquipmentItem equipment) async {
    final now = DateTime.now();
    final data = equipment.toJson();

    // Mise à jour des timestamps
    data['updated_at'] = FieldValue.serverTimestamp();
    if (equipment.createdAt == DateTime(0)) {
      data['created_at'] = FieldValue.serverTimestamp();
    }

    await _collection.doc(equipment.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deactivateEquipment(String id) async {
    await _collection.doc(id).update({
      'is_active': false,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateEquipmentStatus(
      String id, EquipmentCurrentStatus status) async {
    await _collection.doc(id).update({
      'current_status': status.name,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
