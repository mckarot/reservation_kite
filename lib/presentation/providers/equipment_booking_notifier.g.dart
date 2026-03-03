// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_booking_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$equipmentBookingNotifierHash() =>
    r'ddf37513a0c4f475a5c0dea6da9cc5e1c818e10a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EquipmentBookingNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<EquipmentBooking>> {
  late final String userId;

  FutureOr<List<EquipmentBooking>> build(
    String userId,
  );
}

/// State management pour les réservations de matériel d'un utilisateur.
///
/// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
/// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
/// - .value! lance l'exception si AsyncError, retourne la valeur sinon
///
/// Copied from [EquipmentBookingNotifier].
@ProviderFor(EquipmentBookingNotifier)
const equipmentBookingNotifierProvider = EquipmentBookingNotifierFamily();

/// State management pour les réservations de matériel d'un utilisateur.
///
/// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
/// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
/// - .value! lance l'exception si AsyncError, retourne la valeur sinon
///
/// Copied from [EquipmentBookingNotifier].
class EquipmentBookingNotifierFamily
    extends Family<AsyncValue<List<EquipmentBooking>>> {
  /// State management pour les réservations de matériel d'un utilisateur.
  ///
  /// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
  /// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
  /// - .value! lance l'exception si AsyncError, retourne la valeur sinon
  ///
  /// Copied from [EquipmentBookingNotifier].
  const EquipmentBookingNotifierFamily();

  /// State management pour les réservations de matériel d'un utilisateur.
  ///
  /// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
  /// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
  /// - .value! lance l'exception si AsyncError, retourne la valeur sinon
  ///
  /// Copied from [EquipmentBookingNotifier].
  EquipmentBookingNotifierProvider call(
    String userId,
  ) {
    return EquipmentBookingNotifierProvider(
      userId,
    );
  }

  @override
  EquipmentBookingNotifierProvider getProviderOverride(
    covariant EquipmentBookingNotifierProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'equipmentBookingNotifierProvider';
}

/// State management pour les réservations de matériel d'un utilisateur.
///
/// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
/// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
/// - .value! lance l'exception si AsyncError, retourne la valeur sinon
///
/// Copied from [EquipmentBookingNotifier].
class EquipmentBookingNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EquipmentBookingNotifier,
        List<EquipmentBooking>> {
  /// State management pour les réservations de matériel d'un utilisateur.
  ///
  /// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
  /// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
  /// - .value! lance l'exception si AsyncError, retourne la valeur sinon
  ///
  /// Copied from [EquipmentBookingNotifier].
  EquipmentBookingNotifierProvider(
    String userId,
  ) : this._internal(
          () => EquipmentBookingNotifier()..userId = userId,
          from: equipmentBookingNotifierProvider,
          name: r'equipmentBookingNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$equipmentBookingNotifierHash,
          dependencies: EquipmentBookingNotifierFamily._dependencies,
          allTransitiveDependencies:
              EquipmentBookingNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  EquipmentBookingNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<EquipmentBooking>> runNotifierBuild(
    covariant EquipmentBookingNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(EquipmentBookingNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: EquipmentBookingNotifierProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EquipmentBookingNotifier,
      List<EquipmentBooking>> createElement() {
    return _EquipmentBookingNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EquipmentBookingNotifierProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EquipmentBookingNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<EquipmentBooking>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _EquipmentBookingNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EquipmentBookingNotifier,
        List<EquipmentBooking>> with EquipmentBookingNotifierRef {
  _EquipmentBookingNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as EquipmentBookingNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
