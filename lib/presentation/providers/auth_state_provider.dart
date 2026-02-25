import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/models/user.dart';
import '../../data/providers/repository_providers.dart';

part 'auth_state_provider.g.dart';

@riverpod
Stream<firebase_auth.User?> firebaseAuthState(FirebaseAuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@riverpod
Future<User?> currentUser(CurrentUserRef ref) async {
  final authState = ref.watch(firebaseAuthStateProvider).value;
  if (authState == null) return null;

  return ref.watch(userRepositoryProvider).getUser(authState.uid);
}
