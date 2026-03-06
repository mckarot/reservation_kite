import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/equipment_rental.dart';
import '../../domain/repositories/equipment_rental_repository.dart';
import '../../domain/models/reservation.dart';
import '../../utils/date_utils.dart';

/// Implémentation Firestore du repository EquipmentRental.
///
/// TOUTES les opérations d'écriture utilisent des transactions Firestore
/// pour garantir l'intégrité des données et éviter les conflits.
class FirestoreEquipmentRentalRepository
    implements EquipmentRentalRepository {
  final FirebaseFirestore _firestore;
  static const String _rentalsPath = 'equipment_rentals';
  static const String _equipmentPath = 'equipment_items';
  static const String _usersPath = 'users';
  static const String _reservationsPath = 'reservations';

  FirestoreEquipmentRentalRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _rentalsCollection =>
      _firestore.collection(_rentalsPath);

  CollectionReference<Map<String, dynamic>> get _equipmentCollection =>
      _firestore.collection(_equipmentPath);

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(_usersPath);

  CollectionReference<Map<String, dynamic>> get _reservationsCollection =>
      _firestore.collection(_reservationsPath);

  // ───────────────────────────────────────────────────────────────────────────
  // Lecture
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<List<EquipmentRental>> getRentalsByStudent(String studentId) async {
    final snapshot = await _rentalsCollection
        .where('student_id', isEqualTo: studentId)
        .orderBy('date_timestamp', descending: true)
        .limit(100)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentRental.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<EquipmentRental>> getRentalsByDate(String dateString) async {
    final snapshot = await _rentalsCollection
        .where('date_string', isEqualTo: dateString)
        .orderBy('slot', descending: false)
        .limit(200)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentRental.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<EquipmentRental>> getRentalsByReservation(
      String reservationId) async {
    final snapshot = await _rentalsCollection
        .where('reservation_id', isEqualTo: reservationId)
        .orderBy('status', descending: false)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentRental.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Stream<List<EquipmentRental>> watchRentalsByDate(String dateString) {
    return _rentalsCollection
        .where('date_string', isEqualTo: dateString)
        .orderBy('slot', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentRental.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Disponibilité
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<bool> isEquipmentAvailable({
    required String equipmentId,
    required String dateString,
    required TimeSlot slot,
  }) async {
    // Vérifie s'il existe un rental actif/confirme pour cet équipement,
    // cette date et ce slot
    final snapshot = await _rentalsCollection
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: dateString)
        .where('slot', isEqualTo: slot.name)
        .where('status', whereIn: ['pending', 'confirmed', 'active'])
        .limit(1)
        .get();

    return snapshot.docs.isEmpty;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Écriture — Transactions atomiques
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<String> createStudentRental({
    required EquipmentRental rental,
    required int walletDebit,
  }) async {
    final rentalRef = _rentalsCollection.doc();
    final equipmentRef = _equipmentCollection.doc(rental.equipmentId);
    final userRef = _usersCollection.doc(rental.studentId);

    await _firestore.runTransaction((transaction) async {
      // 1. Vérifier disponibilité
      final availabilityCheck = await _rentalsCollection
          .where('equipment_id', isEqualTo: rental.equipmentId)
          .where('date_string', isEqualTo: rental.dateString)
          .where('slot', isEqualTo: rental.slot.name)
          .where('status', whereIn: ['pending', 'confirmed', 'active'])
          .limit(1)
          .get();

      if (availabilityCheck.docs.isNotEmpty) {
        throw Exception(
            'Cet équipement n\'est plus disponible pour ce créneau');
      }

      // 2. Vérifier solde wallet
      final userDoc = await transaction.get(userRef);
      if (!userDoc.exists) {
        throw Exception('Utilisateur non trouvé');
      }
      final currentBalance = (userDoc.data()?['wallet_balance'] as int?) ?? 0;
      if (currentBalance < walletDebit) {
        throw Exception('Solde wallet insuffisant');
      }

      // 3. Créer le rental
      transaction.set(rentalRef, rental.toJson()..['id'] = rentalRef.id);

      // 4. Débiter wallet
      transaction.update(userRef, {
        'wallet_balance': FieldValue.increment(-walletDebit),
      });

      // 5. Mettre à jour currentStatus de l'équipement
      // Seulement si la location est pour aujourd'hui (check-out immédiat)
      // Sinon, l'équipement reste disponible pour d'autres réservations futures
      final rentalDate = DateTime.parse(rental.dateString);
      final today = DateTime.now();
      final isForToday = rentalDate.year == today.year &&
          rentalDate.month == today.month &&
          rentalDate.day == today.day;

      if (isForToday) {
        // Location pour aujourd'hui → équipement indisponible
        transaction.update(equipmentRef, {
          'current_status': 'rented',
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      // Sinon : on ne change pas current_status, l'équipement reste
      // disponible pour d'autres réservations sur d'autres dates
    });

    return rentalRef.id;
  }

  @override
  Future<String> createAdminAssignment({
    required EquipmentRental rental,
    required String reservationId,
  }) async {
    final rentalRef = _rentalsCollection.doc();
    final equipmentRef = _equipmentCollection.doc(rental.equipmentId);
    final reservationRef = _reservationsCollection.doc(reservationId);

    await _firestore.runTransaction((transaction) async {
      // 1. Vérifier disponibilité
      final availabilityCheck = await _rentalsCollection
          .where('equipment_id', isEqualTo: rental.equipmentId)
          .where('date_string', isEqualTo: rental.dateString)
          .where('slot', isEqualTo: rental.slot.name)
          .where('status', whereIn: ['pending', 'confirmed', 'active'])
          .limit(1)
          .get();

      if (availabilityCheck.docs.isNotEmpty) {
        throw Exception(
            'Cet équipement n\'est plus disponible pour ce créneau');
      }

      // 2. Créer le rental
      transaction.set(rentalRef, rental.toJson()..['id'] = rentalRef.id);

      // 3. Mettre à jour reservation : equipment_assignment_required = false
      transaction.update(reservationRef, {
        'equipment_assignment_required': false,
      });

      // 4. Mettre à jour currentStatus de l'équipement
      // Seulement si la location est pour aujourd'hui (check-out immédiat)
      final rentalDate = DateTime.parse(rental.dateString);
      final today = DateTime.now();
      final isForToday = rentalDate.year == today.year &&
          rentalDate.month == today.month &&
          rentalDate.day == today.day;

      if (isForToday) {
        // Location pour aujourd'hui → équipement indisponible
        transaction.update(equipmentRef, {
          'current_status': 'rented',
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      // Sinon : on ne change pas current_status, l'équipement reste
      // disponible pour d'autres réservations sur d'autres dates
    });

    return rentalRef.id;
  }

  @override
  Future<String> createInstructorAssignment({
    required EquipmentRental rental,
    required String reservationId,
  }) async {
    final rentalRef = _rentalsCollection.doc();
    final equipmentRef = _equipmentCollection.doc(rental.equipmentId);
    final reservationRef = _reservationsCollection.doc(reservationId);

    await _firestore.runTransaction((transaction) async {
      // 1. Vérifier disponibilité
      final availabilityCheck = await _rentalsCollection
          .where('equipment_id', isEqualTo: rental.equipmentId)
          .where('date_string', isEqualTo: rental.dateString)
          .where('slot', isEqualTo: rental.slot.name)
          .where('status', whereIn: ['pending', 'confirmed', 'active'])
          .limit(1)
          .get();

      if (availabilityCheck.docs.isNotEmpty) {
        throw Exception(
            'Cet équipement n\'est plus disponible pour ce créneau');
      }

      // 2. Créer le rental
      transaction.set(rentalRef, rental.toJson()..['id'] = rentalRef.id);

      // 3. Mettre à jour reservation : equipment_assignment_required = false
      transaction.update(reservationRef, {
        'equipment_assignment_required': false,
      });

      // 4. Mettre à jour currentStatus de l'équipement
      // Seulement si la location est pour aujourd'hui (check-out immédiat)
      final rentalDate = DateTime.parse(rental.dateString);
      final today = DateTime.now();
      final isForToday = rentalDate.year == today.year &&
          rentalDate.month == today.month &&
          rentalDate.day == today.day;

      if (isForToday) {
        // Location pour aujourd'hui → équipement indisponible
        transaction.update(equipmentRef, {
          'current_status': 'rented',
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      // Sinon : on ne change pas current_status, l'équipement reste
      // disponible pour d'autres réservations sur d'autres dates
    });

    return rentalRef.id;
  }

  @override
  Future<void> cancelRental(String rentalId, String cancelledBy) async {
    final rentalRef = _rentalsCollection.doc(rentalId);

    await _firestore.runTransaction((transaction) async {
      final rentalDoc = await transaction.get(rentalRef);
      if (!rentalDoc.exists) {
        throw Exception('Location non trouvée');
      }

      final rentalData = rentalDoc.data()!;
      final equipmentId = rentalData['equipment_id'] as String;
      final equipmentRef = _equipmentCollection.doc(equipmentId);

      // 1. Vérifier la règle des 24h pour student_rental
      // Si annulation < 24h avant la session → pas de remboursement
      final assignmentType = rentalData['assignment_type'] as String?;
      final dateString = rentalData['date_string'] as String;
      final slotName = rentalData['slot'] as String;
      
      if (assignmentType == 'student_rental') {
        final slotTime = getSlotStartTime(dateString, slotName);
        if (slotTime != null) {
          final hoursUntilRental = slotTime.difference(DateTime.now()).inHours;
          
          if (hoursUntilRental < 24) {
            throw Exception(
              'Annulation impossible : moins de 24h avant la session. '
              'Aucun remboursement ne sera effectué.'
            );
          }
        }
      }

      // 2. Mettre à jour status = cancelled
      transaction.update(rentalRef, {
        'status': 'cancelled',
        'updated_at': FieldValue.serverTimestamp(),
      });

      // 3. Rembourser wallet si student_rental et paid
      // (seulement si la règle des 24h est respectée)
      final paymentStatus = rentalData['payment_status'] as String?;
      final totalPrice = rentalData['total_price'] as int?;

      if (assignmentType == 'student_rental' &&
          paymentStatus == 'paid' &&
          totalPrice != null &&
          totalPrice > 0) {
        final studentId = rentalData['student_id'] as String;
        final userRef = _usersCollection.doc(studentId);
        transaction.update(userRef, {
          'wallet_balance': FieldValue.increment(totalPrice),
        });
      }

      // 4. Mettre à jour currentStatus de l'équipement
      transaction.update(equipmentRef, {
        'current_status': 'available',
        'updated_at': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<void> checkOut({
    required String rentalId,
    required String staffId,
    required String condition,
  }) async {
    final rentalRef = _rentalsCollection.doc(rentalId);

    await _firestore.runTransaction((transaction) async {
      final rentalDoc = await transaction.get(rentalRef);
      if (!rentalDoc.exists) {
        throw Exception('Location non trouvée');
      }

      final rentalData = rentalDoc.data()!;
      final equipmentId = rentalData['equipment_id'] as String;
      final equipmentRef = _equipmentCollection.doc(equipmentId);

      // 1. Mettre à jour check-out
      transaction.update(rentalRef, {
        'checked_out_at': FieldValue.serverTimestamp(),
        'checked_out_by': staffId,
        'condition_at_checkout': condition,
        'status': 'active',
        'updated_at': FieldValue.serverTimestamp(),
      });

      // 2. Mettre à jour currentStatus de l'équipement
      transaction.update(equipmentRef, {
        'current_status': 'rented',
        'updated_at': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<void> checkIn({
    required String rentalId,
    required String staffId,
    required String condition,
    String? damageNotes,
  }) async {
    final rentalRef = _rentalsCollection.doc(rentalId);

    await _firestore.runTransaction((transaction) async {
      final rentalDoc = await transaction.get(rentalRef);
      if (!rentalDoc.exists) {
        throw Exception('Location non trouvée');
      }

      final rentalData = rentalDoc.data()!;
      final equipmentId = rentalData['equipment_id'] as String;
      final equipmentRef = _equipmentCollection.doc(equipmentId);

      // 1. Déterminer si maintenance requise
      // Maintenance si : condition = 'poor' OU damageNotes présentes
      final needsMaintenance = 
          condition == 'poor' || (damageNotes != null && damageNotes.isNotEmpty);

      // 2. Mettre à jour check-in
      final updateData = <String, dynamic>{
        'checked_in_at': FieldValue.serverTimestamp(),
        'checked_in_by': staffId,
        'condition_at_checkin': condition,
        'status': 'completed',
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (damageNotes != null) {
        updateData['damage_notes'] = damageNotes;
      }

      transaction.update(rentalRef, updateData);

      // 3. Incrémenter total_rentals et mettre à jour currentStatus
      // Si maintenance requise → 'maintenance', sinon → 'available'
      transaction.update(equipmentRef, {
        'total_rentals': FieldValue.increment(1),
        'current_status': needsMaintenance ? 'maintenance' : 'available',
        'condition': condition,
        'updated_at': FieldValue.serverTimestamp(),
      });
    });
  }
}
