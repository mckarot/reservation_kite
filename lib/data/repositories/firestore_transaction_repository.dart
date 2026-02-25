import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class FirestoreTransactionRepository implements TransactionRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'transactions';

  FirestoreTransactionRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Transaction>> getUserTransactions(String userId) async {
    final snapshot = await _collection
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => Transaction.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    final data = transaction.toJson();

    final docRef = _collection.doc(transaction.id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      data['created_at'] = FieldValue.serverTimestamp();
    }

    await docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<List<Transaction>> getAllTransactions({int? limit}) async {
    final snapshot = await _collection
        .orderBy('created_at', descending: true)
        .limit(limit ?? 100)
        .get();

    return snapshot.docs
        .map((doc) => Transaction.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
