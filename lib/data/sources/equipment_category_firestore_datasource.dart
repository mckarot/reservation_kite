import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment_category.dart';

class EquipmentCategoryFirestoreDataSource {
  final FirebaseFirestore _firestore;

  EquipmentCategoryFirestoreDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('equipment_categories');

  Stream<List<EquipmentCategory>> watchAll() {
    return _collection
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentCategory.fromJson(doc.data()))
            .toList());
  }

  Future<void> create(EquipmentCategory category) async {
    await _collection.doc(category.id).set(category.toJson());
  }

  Future<void> update(EquipmentCategory category) async {
    await _collection.doc(category.id).update(category.toJson());
  }

  Future<void> delete(String categoryId) async {
    await _collection.doc(categoryId).delete();
  }

  Future<void> reorder(String categoryId, int newOrder) async {
    print('🔥 [DataSource] reorder called:');
    print('   - categoryId: $categoryId');
    print('   - newOrder: $newOrder');
    
    try {
      final docRef = _firestore.collection('equipment_categories').doc(categoryId);
      print('   - Updating document: ${docRef.path}');
      
      await docRef.update({'order': newOrder});
      print('✅ [DataSource] Firestore update successful');
      
      // Vérifier que l'ordre a bien été mis à jour
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data();
        print('   - Après update: order = ${data?['order']}');
      }
    } catch (e) {
      print('❌ [DataSource] Firestore error: $e');
      rethrow;
    }
  }

  Future<List<EquipmentCategory>> getAll() async {
    final snapshot = await _collection.orderBy('order').get();
    return snapshot.docs
        .map((doc) => EquipmentCategory.fromJson(doc.data()))
        .toList();
  }
}
