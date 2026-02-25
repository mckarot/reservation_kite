// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthStateHash() => r'6f8d86db5de2655d030ff93dcd9e6bf170c9e93e';

/// See also [firebaseAuthState].
@ProviderFor(firebaseAuthState)
final firebaseAuthStateProvider =
    AutoDisposeStreamProvider<firebase_auth.User?>.internal(
  firebaseAuthState,
  name: r'firebaseAuthStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseAuthStateRef
    = AutoDisposeStreamProviderRef<firebase_auth.User?>;
String _$currentUserHash() => r'edda4b9e1e97cd1f8f5c8d6e36a9e7f0605d123d';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeFutureProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = AutoDisposeFutureProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
