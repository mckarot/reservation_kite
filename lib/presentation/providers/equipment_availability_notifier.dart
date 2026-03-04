import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/equipment_with_availability.dart';

part 'equipment_availability_notifier.g.dart';

/// State management pour la disponibilité des équipements en temps réel.
///
/// Fournit un stream qui se met à jour automatiquement lorsque :
/// - Un équipement est modifié (status)
/// - Une réservation est créée/annulée
@riverpod
class EquipmentAvailabilityNotifier extends _$EquipmentAvailabilityNotifier {
  @override
  Stream<List<Equipment>> build() {
    // Watch tous les équipements triés par marque
    return FirebaseFirestore.instance
        .collection('equipment')
        .orderBy('brand')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
              .toList(),
        );
  }

  /// Stream de disponibilité pour un équipement spécifique à une date/créneau.
  ///
  /// Retourne un [EquipmentWithAvailability] avec :
  /// - L'équipement complet
  /// - La quantité disponible calculée dynamiquement (toujours 0 ou 1 pour un équipement individuel)
  /// - Le créneau demandé
  /// - La date demandée
  ///
  /// Se met à jour en temps réel lors des nouvelles réservations.
  Stream<EquipmentWithAvailability> watchEquipmentAvailability({
    required String equipmentId,
    required DateTime date,
    required EquipmentBookingSlot slot,
  }) {
    return ref
        .watch(equipmentBookingRepositoryProvider)
        .watchEquipmentAvailability(
          equipmentId: equipmentId,
          date: date,
          slot: slot,
        );
  }

  /// Récupère un équipement spécifique par son ID.
  Stream<Equipment?> watchEquipment(String equipmentId) {
    return FirebaseFirestore.instance
        .collection('equipment')
        .doc(equipmentId)
        .snapshots()
        .map(
          (doc) => doc.exists
              ? Equipment.fromJson(doc.data() as Map<String, dynamic>..['id'] = doc.id)
              : null,
        );
  }
}
