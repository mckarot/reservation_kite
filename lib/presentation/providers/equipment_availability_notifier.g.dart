// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_availability_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$equipmentAvailabilityNotifierHash() =>
    r'4ebfa767525cacf3b8eef30280e4d3f5bc16bd1b';

/// State management pour la disponibilité des équipements en temps réel.
///
/// Fournit un stream qui se met à jour automatiquement lorsque :
/// - Un équipement est modifié (total_quantity, status)
/// - Une réservation est créée/annulée
///
/// Utilise Rx.combineLatest2 pour éviter les N+1 queries.
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
