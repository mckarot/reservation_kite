// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_assignment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$equipmentAssignmentNotifierHash() =>
    r'3aecf635cd5db7a2a6e5e7e1d597bd50f7e24902';

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

abstract class _$EquipmentAssignmentNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<EquipmentBooking>> {
  late final String sessionId;

  FutureOr<List<EquipmentBooking>> build(
    String sessionId,
  );
}

/// See also [EquipmentAssignmentNotifier].
@ProviderFor(EquipmentAssignmentNotifier)
const equipmentAssignmentNotifierProvider = EquipmentAssignmentNotifierFamily();

/// See also [EquipmentAssignmentNotifier].
class EquipmentAssignmentNotifierFamily
    extends Family<AsyncValue<List<EquipmentBooking>>> {
  /// See also [EquipmentAssignmentNotifier].
  const EquipmentAssignmentNotifierFamily();

  /// See also [EquipmentAssignmentNotifier].
  EquipmentAssignmentNotifierProvider call(
    String sessionId,
  ) {
    return EquipmentAssignmentNotifierProvider(
      sessionId,
    );
  }

  @override
  EquipmentAssignmentNotifierProvider getProviderOverride(
    covariant EquipmentAssignmentNotifierProvider provider,
  ) {
    return call(
      provider.sessionId,
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
  String? get name => r'equipmentAssignmentNotifierProvider';
}

/// See also [EquipmentAssignmentNotifier].
class EquipmentAssignmentNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EquipmentAssignmentNotifier,
        List<EquipmentBooking>> {
  /// See also [EquipmentAssignmentNotifier].
  EquipmentAssignmentNotifierProvider(
    String sessionId,
  ) : this._internal(
          () => EquipmentAssignmentNotifier()..sessionId = sessionId,
          from: equipmentAssignmentNotifierProvider,
          name: r'equipmentAssignmentNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$equipmentAssignmentNotifierHash,
          dependencies: EquipmentAssignmentNotifierFamily._dependencies,
          allTransitiveDependencies:
              EquipmentAssignmentNotifierFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  EquipmentAssignmentNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  FutureOr<List<EquipmentBooking>> runNotifierBuild(
    covariant EquipmentAssignmentNotifier notifier,
  ) {
    return notifier.build(
      sessionId,
    );
  }

  @override
  Override overrideWith(EquipmentAssignmentNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: EquipmentAssignmentNotifierProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EquipmentAssignmentNotifier,
      List<EquipmentBooking>> createElement() {
    return _EquipmentAssignmentNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EquipmentAssignmentNotifierProvider &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EquipmentAssignmentNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<EquipmentBooking>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _EquipmentAssignmentNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EquipmentAssignmentNotifier,
        List<EquipmentBooking>> with EquipmentAssignmentNotifierRef {
  _EquipmentAssignmentNotifierProviderElement(super.provider);

  @override
  String get sessionId =>
      (origin as EquipmentAssignmentNotifierProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
