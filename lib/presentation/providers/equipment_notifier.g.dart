// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$equipmentNotifierHash() => r'334c1892666919afe193da2bfe6bcbabce571416';

/// Provider pour l'état des équipements (parc matériel).
///
/// Copied from [EquipmentNotifier].
@ProviderFor(EquipmentNotifier)
final equipmentNotifierProvider = AutoDisposeAsyncNotifierProvider<
    EquipmentNotifier, List<EquipmentItem>>.internal(
  EquipmentNotifier.new,
  name: r'equipmentNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$equipmentNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EquipmentNotifier = AutoDisposeAsyncNotifier<List<EquipmentItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
