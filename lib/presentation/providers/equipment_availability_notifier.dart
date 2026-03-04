import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_with_availability.dart';
import '../../domain/models/equipment_booking.dart';
import '../../utils/date_utils.dart';
import '../../utils/booking_conflict_utils.dart';
import '../../data/providers/repository_providers.dart';

part 'equipment_availability_notifier.g.dart';

/// State management pour la disponibilité des équipements en temps réel.
///
/// Fournit un stream qui se met à jour automatiquement lorsque :
/// - Un équipement est modifié (total_quantity, status)
/// - Une réservation est créée/annulée
///
/// Utilise Rx.combineLatest2 pour éviter les N+1 queries.
@riverpod
class EquipmentAvailabilityNotifier extends _$EquipmentAvailabilityNotifier {
  @override
  Stream<List<Equipment>> build() {
    return FirebaseFirestore.instance
        .collection('equipment')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Equipment.fromJson(doc.data()))
              .toList(),
        );
  }

  /// Stream de disponibilité pour un équipement spécifique à une date/créneau.
  ///
  /// Retourne un [EquipmentWithAvailability] avec :
  /// - L'équipement complet
  /// - La quantité disponible calculée dynamiquement
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
              ? Equipment.fromJson(doc.data() as Map<String, dynamic>)
              : null,
        );
  }
}
