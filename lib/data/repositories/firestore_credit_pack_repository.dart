import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/credit_pack.dart';
import '../../domain/repositories/credit_pack_repository.dart';

class FirestoreCreditPackRepository implements CreditPackRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'credit_packs';

  FirestoreCreditPackRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<CreditPack>> getAllPacks() async {
    final snapshot = await _collection
        .where('is_active', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => CreditPack.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<CreditPack?> getPack(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return CreditPack.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> savePack(CreditPack pack) async {
    final data = pack.toJson();
    await _collection.doc(pack.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deletePack(String id) async {
    await _collection.doc(id).delete();
  }
}
