import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment_booking.dart';
import 'booking_conflict_utils.dart';

/// Service utilitaire pour la gestion des créneaux de réservation.
///
/// Ce fichier centralise TOUTE la logique de disponibilité du matériel
/// pour garantir une harmonisation entre tous les écrans (élève, moniteur, admin).
///
/// ## PRINCIPE FONDAMENTAL :
/// - La disponibilité est calculée UNIQUEMENT via les conflits de créneau
/// - Le statut de l'équipement (available/reserved) n'est PAS utilisé pour la disponibilité
/// - Seuls les statuts 'maintenance' et 'damaged' bloquent les réservations
///
/// ## UTILISATION :
/// ```dart
/// // Vérifier si un équipement est disponible
/// final isAvailable = await EquipmentSlotAvailabilityService.isEquipmentAvailable(
///   equipmentId: 'kite_123',
///   date: DateTime(2026, 3, 15),
///   slot: EquipmentBookingSlot.morning,
/// );
///
/// // Compter les équipements disponibles dans une catégorie
/// final count = await EquipmentSlotAvailabilityService.countAvailableEquipment(
///   categoryId: 'kite',
///   date: DateTime(2026, 3, 15),
///   slot: EquipmentBookingSlot.morning,
/// );
/// ```
class EquipmentSlotAvailabilityService {
  /// Vérifie si un équipement spécifique est disponible pour un créneau donné.
  ///
  /// Retourne `true` si l'équipement peut être réservé, `false` sinon.
  ///
  /// ## Règles :
  /// 1. Si le statut est 'maintenance' ou 'damaged' → ❌ Indisponible
  /// 2. Si aucune réservation existante → ✅ Disponible
  /// 3. Si des réservations existent → Vérifie les conflits de créneau
  static Future<bool> isEquipmentAvailable({
    required String equipmentId,
    required DateTime date,
    required EquipmentBookingSlot slot,
    FirebaseFirestore? firestore,
  }) async {
    final db = firestore ?? FirebaseFirestore.instance;
    final dateString = _formatDate(date);

    // Récupérer l'équipement pour vérifier son statut
    final equipmentDoc = await db.collection('equipment').doc(equipmentId).get();

    if (!equipmentDoc.exists) {
      return false; // Équipement introuvable
    }

    final status = equipmentDoc.data()?['status'] as String?;

    // Statuts qui bloquent toujours
    if (status == 'maintenance' || status == 'damaged') {
      return false;
    }

    // Récupérer les réservations existantes pour cet équipement à cette date
    final bookingsSnapshot = await db
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    if (bookingsSnapshot.docs.isEmpty) {
      return true; // Pas de réservations → disponible
    }

    // Vérifier les conflits de créneau
    final bookings = bookingsSnapshot.docs
        .map((doc) => doc.data())
        .toList();

    final conflicts = countConflictingBookings(bookings, slot);
    return conflicts == 0; // Disponible si aucun conflit
  }

  /// Compte le nombre d'équipements disponibles dans une catégorie pour un créneau.
  ///
  /// Cette méthode est optimisée pour les écrans de liste qui doivent afficher
  /// la disponibilité de plusieurs équipements d'un coup.
  static Future<int> countAvailableEquipment({
    required String categoryId,
    required DateTime date,
    required EquipmentBookingSlot slot,
    FirebaseFirestore? firestore,
  }) async {
    final db = firestore ?? FirebaseFirestore.instance;
    final dateString = _formatDate(date);

    // Récupérer tous les équipements de la catégorie
    final equipmentSnapshot = await db
        .collection('equipment')
        .where('category_id', isEqualTo: categoryId)
        .get();

    if (equipmentSnapshot.docs.isEmpty) {
      return 0;
    }

    // Récupérer toutes les réservations pour cette date
    final bookingsSnapshot = await db
        .collection('equipment_bookings')
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    // Grouper les réservations par équipement
    final bookingsByEquipment = <String, List<Map<String, dynamic>>>{};
    for (final doc in bookingsSnapshot.docs) {
      final data = doc.data();
      final equipmentId = data['equipment_id'] as String;
      bookingsByEquipment.putIfAbsent(equipmentId, () => []).add(data);
    }

    // Compter les équipements disponibles
    var availableCount = 0;

    for (final doc in equipmentSnapshot.docs) {
      final equipmentId = doc.id;
      final status = doc.data()['status'] as String?;

      // Statuts qui bloquent toujours
      if (status == 'maintenance' || status == 'damaged') {
        continue;
      }

      final eqBookings = bookingsByEquipment[equipmentId] ?? [];

      if (eqBookings.isEmpty) {
        availableCount++; // Pas de réservations → disponible
        continue;
      }

      // Vérifier les conflits de créneau
      final conflicts = countConflictingBookings(eqBookings, slot);
      if (conflicts == 0) {
        availableCount++;
      }
    }

    return availableCount;
  }

  /// Récupère les équipements disponibles dans une catégorie pour un créneau.
  ///
  /// Retourne la liste des IDs d'équipements qui peuvent être réservés.
  static Future<List<String>> getAvailableEquipmentIds({
    required String categoryId,
    required DateTime date,
    required EquipmentBookingSlot slot,
    FirebaseFirestore? firestore,
  }) async {
    final db = firestore ?? FirebaseFirestore.instance;
    final dateString = _formatDate(date);

    // Récupérer tous les équipements de la catégorie
    final equipmentSnapshot = await db
        .collection('equipment')
        .where('category_id', isEqualTo: categoryId)
        .get();

    if (equipmentSnapshot.docs.isEmpty) {
      return [];
    }

    // Récupérer toutes les réservations pour cette date
    final bookingsSnapshot = await db
        .collection('equipment_bookings')
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    // Grouper les réservations par équipement
    final bookingsByEquipment = <String, List<Map<String, dynamic>>>{};
    for (final doc in bookingsSnapshot.docs) {
      final data = doc.data();
      final equipmentId = data['equipment_id'] as String;
      bookingsByEquipment.putIfAbsent(equipmentId, () => []).add(data);
    }

    // Filtrer les équipements disponibles
    final availableIds = <String>[];

    for (final doc in equipmentSnapshot.docs) {
      final equipmentId = doc.id;
      final status = doc.data()['status'] as String?;

      // Statuts qui bloquent toujours
      if (status == 'maintenance' || status == 'damaged') {
        continue;
      }

      final eqBookings = bookingsByEquipment[equipmentId] ?? [];

      if (eqBookings.isEmpty) {
        availableIds.add(equipmentId); // Pas de réservations → disponible
        continue;
      }

      // Vérifier les conflits de créneau
      final conflicts = countConflictingBookings(eqBookings, slot);
      if (conflicts == 0) {
        availableIds.add(equipmentId);
      }
    }

    return availableIds;
  }

  /// Vérifie s'il y a un conflit pour un créneau spécifique.
  ///
  /// Cette méthode est un wrapper autour de `countConflictingBookings` pour
  /// une utilisation plus simple dans les écrans.
  static bool hasSlotConflict({
    required List<Map<String, dynamic>> existingBookings,
    required EquipmentBookingSlot requestedSlot,
  }) {
    final conflicts = countConflictingBookings(existingBookings, requestedSlot);
    return conflicts > 0;
  }

  /// Formate une date en string YYYY-MM-DD.
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Extension pour vérifier la disponibilité directement sur un EquipmentBookingSlot.
extension EquipmentBookingSlotAvailability on EquipmentBookingSlot {
  /// Vérifie si ce créneau est en conflit avec un autre.
  bool conflictsWith(EquipmentBookingSlot other) {
    // full_day conflit avec tout
    if (this == EquipmentBookingSlot.fullDay || other == EquipmentBookingSlot.fullDay) {
      return true;
    }

    // morning et afternoon ne confligent pas entre eux
    return this == other;
  }
}
