// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_availability_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$equipmentAvailabilityNotifierHash() =>
    r'9e7fbef780fa45cb32b6265ca19aac1fa87f939b';

/// State management pour la disponibilité des équipements en temps réel.
///
/// Fournit un stream qui se met à jour automatiquement lorsque :
/// - Un équipement est modifié (status)
/// - Une réservation est créée/annulée
///
/// Copied from [EquipmentAvailabilityNotifier].
@ProviderFor(EquipmentAvailabilityNotifier)
final equipmentAvailabilityNotifierProvider = AutoDisposeStreamNotifierProvider<
    EquipmentAvailabilityNotifier, List<Equipment>>.internal(
  EquipmentAvailabilityNotifier.new,
  name: r'equipmentAvailabilityNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$equipmentAvailabilityNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EquipmentAvailabilityNotifier
    = AutoDisposeStreamNotifier<List<Equipment>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
