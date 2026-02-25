import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/models/user.dart';

abstract class AuthRepository {
  Stream<firebase_auth.User?> get authStateChanges;
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? role,
  });
  Future<void> signOut();
  firebase_auth.User? get currentUser;
}
