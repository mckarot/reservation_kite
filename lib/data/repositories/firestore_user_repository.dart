import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'users';

  FirestoreUserRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<User>> getAllUsers() async {
    final snapshot = await _collection.orderBy('display_name').limit(100).get();

    return snapshot.docs
        .map((doc) => User.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<User?> getUser(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return User.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> saveUser(User user) async {
    final data = user.toJson();

    // Remplacement des DateTime par serverTimestamp pour les champs système
    // Note: Pour une mise à jour, on ne veut pas écraser created_at s'il existe déjà
    // ou alors on le gère via un check d'existence.

    final docRef = _collection.doc(user.id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      data['created_at'] = FieldValue.serverTimestamp();
    } else {
      // On retire created_at du toJson pour ne pas l'écraser sur une mise à jour
      data.remove('created_at');
    }

    data['last_seen'] = FieldValue.serverTimestamp();

    await docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteUser(String id) async {
    await _collection.doc(id).delete();
  }
}
