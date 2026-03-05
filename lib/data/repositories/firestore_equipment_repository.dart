import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../../utils/booking_conflict_utils.dart';

/// Repository Firebase pour la gestion des équipements.
///
/// Chaque équipement est une entité physique unique avec un statut individuel.
/// Les opérations critiques (réservation, libération) sont atomiques.
class FirestoreEquipmentRepository implements EquipmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'equipment';
  static const String _bookingsCollectionPath = 'equipment_bookings';

  FirestoreEquipmentRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Equipment>> getAllEquipment() async {
    final snapshot = await _collection.limit(500).get();

    return snapshot.docs
        .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<Equipment?> getEquipment(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Equipment.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> saveEquipment(Equipment equipment) async {
    final data = equipment.toFirestoreData();
    await _collection.doc(equipment.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<void> updateStatus(String id, EquipmentStatus status) async {
    await _collection.doc(id).update({
      'status': status.name,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Equipment>> getAvailableEquipment(String categoryId) async {
    final snapshot = await _collection
        .where('category_id', isEqualTo: categoryId)
        .where('status', isEqualTo: 'available')
        .get();
    return snapshot.docs
        .map((d) => Equipment.fromJson(d.data()..['id'] = d.id))
        .toList();
  }

  @override
  Stream<List<Equipment>> watchEquipmentByCategory(String categoryId) {
    return _collection
        .where('category_id', isEqualTo: categoryId)
        .orderBy('brand')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }

  /// Réserve un équipement spécifique de manière ATOMIQUE.
  ///
  /// Utilise une transaction Firestore pour garantir que :
  /// - L'équipement existe
  /// - L'équipement n'est pas en maintenance ou endommagé
  /// - La réservation est créée dans la même transaction
  ///
  /// GESTION DES CRÉNEAUX (Option A - Raffinée) :
  /// - Le statut de l'équipement NE CHANGE JAMAIS automatiquement
  /// - La disponibilité est TOUJOURS calculée par créneau via les conflits
  /// - Le statut 'reserved' est uniquement défini manuellement par l'admin
  /// - Cela permet les réservations futures sans bloquer l'équipement avant
  ///
  /// Retourne `true` si la réservation a réussi, `false` si l'équipement
  /// n'était plus disponible (race condition).
  @override
  Future<bool> bookEquipmentAtomically({
    required String equipmentId,
    required Map<String, dynamic> bookingData,
  }) async {
    final equipmentRef = _collection.doc(equipmentId);
    final bookingRef = _firestore.collection(_bookingsCollectionPath).doc();

    try {
      await _firestore.runTransaction((transaction) async {
        // 1. Lire l'équipement dans la transaction
        final equipmentDoc = await transaction.get(equipmentRef);

        if (!equipmentDoc.exists) {
          throw Exception('Équipement introuvable');
        }

        final currentStatus = equipmentDoc.data()?['status'] as String?;

        // Vérifier que l'équipement n'est pas en maintenance ou endommagé
        // Le statut 'reserved' (défini manuellement) bloque aussi les réservations
        if (currentStatus == 'maintenance' || 
            currentStatus == 'damaged' ||
            currentStatus == 'reserved') {
          throw Exception('Équipement non disponible : statut actuel = $currentStatus');
        }

        // 2. Vérifier les conflits de créneau
        final dateString = bookingData['date_string'] as String;
        final slotString = bookingData['slot'] as String;
        final requestedSlot = EquipmentBookingSlot.values.firstWhere(
          (e) => e.name == slotString,
          orElse: () => EquipmentBookingSlot.morning,
        );

        final existingBookings = await _firestore
            .collection(_bookingsCollectionPath)
            .where('equipment_id', isEqualTo: equipmentId)
            .where('date_string', isEqualTo: dateString)
            .where('status', whereIn: ['confirmed', 'completed'])
            .get();

        if (existingBookings.docs.isNotEmpty) {
          final conflicts = countConflictingBookings(
            existingBookings.docs.map((d) => d.data() as Map<String, dynamic>).toList(),
            requestedSlot,
          );

          if (conflicts > 0) {
            throw Exception('Créneau déjà réservé ($conflicts conflit(s))');
          }
        }

        // 3. AUCUNE MISE À JOUR DU STATUT
        // Le statut reste tel quel (available, reserved manuel, etc.)
        // La disponibilité est gérée uniquement par les conflits de réservation

        // 4. Création de la réservation dans la même transaction
        transaction.set(bookingRef, {
          ...bookingData,
          'equipment_id': equipmentId,
          'status': 'confirmed',
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        });
      });
      return true;
    } on Exception catch (e) {
      print('⚠️ Réservation refusée : $e');
      return false;
    }
  }

  /// Libère un équipement (annulation ou fin de session) — ATOMIQUE.
  ///
  /// GESTION DES CRÉNEAUX (Option A - Raffinée) :
  /// - Le statut de l'équipement NE CHANGE PAS automatiquement
  /// - Seul le statut de la réservation est mis à jour (cancelled/completed)
  /// - L'admin peut changer le statut manuellement si nécessaire
  ///
  /// Utilise une transaction pour garantir la cohérence.
  @override
  Future<void> releaseEquipment({
    required String equipmentId,
    required String bookingId,
    required String newBookingStatus,
  }) async {
    assert(
      newBookingStatus == 'cancelled' || newBookingStatus == 'completed',
      'newBookingStatus doit être "cancelled" ou "completed"',
    );

    final equipmentRef = _collection.doc(equipmentId);
    final bookingRef = _firestore.collection(_bookingsCollectionPath).doc(bookingId);

    try {
      await _firestore.runTransaction((transaction) async {
        // 1. Lire la réservation pour connaître la date
        final bookingDoc = await transaction.get(bookingRef);
        if (!bookingDoc.exists) {
          throw Exception('Réservation introuvable');
        }

        // 2. Mettre à jour le statut de la réservation
        transaction.update(bookingRef, {
          'status': newBookingStatus,
          'updated_at': FieldValue.serverTimestamp(),
        });

        // 3. AUCUNE MISE À JOUR DU STATUT DE L'ÉQUIPEMENT
        // Le statut reste tel quel
        // La disponibilité est gérée uniquement par les conflits de réservation
      });
    } on Exception catch (e) {
      print('⚠️ Erreur lors de la libération : $e');
      rethrow;
    }
  }

  /// Compte les équipements disponibles pour une catégorie, date et créneau.
  ///
  /// Exclut les équipements :
  /// - Déjà réservés sur ce créneau
  /// - En maintenance ou endommagés
  @override
  Future<int> getAvailableCount({
    required String categoryId,
    required String dateString,
    required String slot,
  }) async {
    // 1. IDs des équipements déjà réservés sur ce créneau
    final bookingsSnap = await _firestore
        .collection(_bookingsCollectionPath)
        .where('date_string', isEqualTo: dateString)
        .where('slot', isEqualTo: slot)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    final reservedIds = bookingsSnap.docs
        .map((d) => (d.data()['equipment_id'] as String))
        .toSet();

    // 2. Équipements disponibles dans la catégorie (statut = available)
    final equipSnap = await _collection
        .where('category_id', isEqualTo: categoryId)
        .where('status', isEqualTo: 'available')
        .get();

    // 3. Filtrer ceux qui ne sont pas réservés
    return equipSnap.docs
        .where((d) => !reservedIds.contains(d.id))
        .length;
  }
}
