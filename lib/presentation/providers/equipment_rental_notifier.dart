import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment_item.dart';
import '../../domain/models/equipment_rental.dart';
import '../../domain/models/reservation.dart';
import '../../utils/date_utils.dart';

part 'equipment_rental_notifier.g.dart';

/// Provider pour l'état des locations de matériel.
@riverpod
class EquipmentRentalNotifier extends _$EquipmentRentalNotifier {
  @override
  FutureOr<List<EquipmentRental>> build() {
    return _fetchMyRentals();
  }

  /// Récupère les locations de l'utilisateur connecté.
  Future<List<EquipmentRental>> _fetchMyRentals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    return ref.read(equipmentRentalRepositoryProvider).getRentalsByStudent(user.uid);
  }

  /// Récupère les locations pour une date donnée.
  Future<List<EquipmentRental>> getRentalsByDate(DateTime date) async {
    final dateString = formatDateForQuery(date);
    return ref.read(equipmentRentalRepositoryProvider).getRentalsByDate(dateString);
  }

  /// Stream pour les locations d'une date.
  Stream<List<EquipmentRental>> watchRentalsByDate(DateTime date) {
    final dateString = formatDateForQuery(date);
    return ref.read(equipmentRentalRepositoryProvider).watchRentalsByDate(dateString);
  }

  /// Récupère les locations liées à une réservation.
  Future<List<EquipmentRental>> getRentalsByReservation(String reservationId) async {
    return ref.read(equipmentRentalRepositoryProvider)
        .getRentalsByReservation(reservationId);
  }

  /// Crée une location directe (élève).
  Future<String> createStudentRental({
    required String equipmentId,
    required String equipmentName,
    required String equipmentCategory,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,
    required DateTime date,
    required TimeSlot slot,
    required int totalPrice,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    final rental = EquipmentRental(
      id: '', // Sera généré par Firestore
      studentId: user.uid,
      studentName: user.displayName ?? 'Utilisateur',
      studentEmail: user.email ?? '',
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      equipmentCategory: equipmentCategory,
      equipmentBrand: equipmentBrand,
      equipmentModel: equipmentModel,
      equipmentSize: equipmentSize,
      dateString: formatDateForQuery(date),
      dateTimestamp: toUtcDate(date),
      slot: slot,
      assignmentType: AssignmentType.studentRental,
      status: RentalStatus.pending,
      totalPrice: totalPrice,
      paymentStatus: PaymentStatus.unpaid,
      bookedBy: user.uid,
      bookedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return ref.read(equipmentRentalRepositoryProvider).createStudentRental(
          rental: rental,
          walletDebit: totalPrice,
        );
  }

  /// Crée un assignment admin.
  Future<String> createAdminAssignment({
    required String reservationId,
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String equipmentId,
    required String equipmentName,
    required String equipmentCategory,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,
    required DateTime date,
    required TimeSlot slot,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    final rental = EquipmentRental(
      id: '',
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      equipmentCategory: equipmentCategory,
      equipmentBrand: equipmentBrand,
      equipmentModel: equipmentModel,
      equipmentSize: equipmentSize,
      dateString: formatDateForQuery(date),
      dateTimestamp: toUtcDate(date),
      slot: slot,
      assignmentType: AssignmentType.adminAssignment,
      status: RentalStatus.confirmed,
      adminAssignedAt: DateTime.now(),
      adminAssignedBy: user.uid,
      bookedBy: user.uid,
      bookedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return ref.read(equipmentRentalRepositoryProvider).createAdminAssignment(
          rental: rental,
          reservationId: reservationId,
        );
  }

  /// Crée un assignment moniteur.
  Future<String> createInstructorAssignment({
    required String reservationId,
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String equipmentId,
    required String equipmentName,
    required String equipmentCategory,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,
    required DateTime date,
    required TimeSlot slot,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    final rental = EquipmentRental(
      id: '',
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      equipmentId: equipmentId,
      equipmentName: equipmentName,
      equipmentCategory: equipmentCategory,
      equipmentBrand: equipmentBrand,
      equipmentModel: equipmentModel,
      equipmentSize: equipmentSize,
      dateString: formatDateForQuery(date),
      dateTimestamp: toUtcDate(date),
      slot: slot,
      assignmentType: AssignmentType.instructorAssignment,
      status: RentalStatus.confirmed,
      instructorAssignedAt: DateTime.now(),
      instructorAssignedBy: user.uid,
      bookedBy: user.uid,
      bookedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return ref.read(equipmentRentalRepositoryProvider)
        .createInstructorAssignment(
          rental: rental,
          reservationId: reservationId,
        );
  }

  /// Annule une location.
  Future<void> cancelRental(String rentalId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    await ref.read(equipmentRentalRepositoryProvider)
        .cancelRental(rentalId, user.uid);
    
    // Rafraîchir l'état
    ref.invalidateSelf();
  }

  /// Check-out d'un équipement.
  Future<void> checkOut({
    required String rentalId,
    required String condition,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    await ref.read(equipmentRentalRepositoryProvider).checkOut(
          rentalId: rentalId,
          staffId: user.uid,
          condition: condition,
        );

    ref.invalidateSelf();
  }

  /// Check-in d'un équipement.
  Future<void> checkIn({
    required String rentalId,
    required String condition,
    String? damageNotes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    await ref.read(equipmentRentalRepositoryProvider).checkIn(
          rentalId: rentalId,
          staffId: user.uid,
          condition: condition,
          damageNotes: damageNotes,
        );

    ref.invalidateSelf();
  }
}
