import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';
import 'reservation.dart';

part 'equipment_rental.freezed.dart';
part 'equipment_rental.g.dart';

enum RentalStatus {
  @JsonValue('pending') pending,
  @JsonValue('confirmed') confirmed,
  @JsonValue('active') active,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled,
}

enum PaymentStatus {
  @JsonValue('unpaid') unpaid,
  @JsonValue('paid') paid,
  @JsonValue('refunded') refunded,
}

enum AssignmentType {
  @JsonValue('student_rental') studentRental,
  @JsonValue('admin_assignment') adminAssignment,
  @JsonValue('instructor_assignment') instructorAssignment,
}

@freezed
class EquipmentRental with _$EquipmentRental {
  const factory EquipmentRental({
    required String id,

    // Élève
    required String studentId,
    required String studentName,
    required String studentEmail,

    // Équipement (dénormalisé)
    required String equipmentId,
    required String equipmentName,
    required String equipmentCategory,
    required String equipmentBrand,
    required String equipmentModel,
    required double equipmentSize,

    // Période — double stockage pour requêtes Firestore
    required String dateString,
    @TimestampConverter() required DateTime dateTimestamp,
    required TimeSlot slot,

    // Type d'affectation
    required AssignmentType assignmentType,

    // Statut
    @Default(RentalStatus.pending) RentalStatus status,

    // Prix — null pour admin/instructor assignments
    int? totalPrice,
    PaymentStatus? paymentStatus,

    // Contexte (FK → reservations)
    String? reservationId,
    required String bookedBy,
    @TimestampConverter() required DateTime bookedAt,

    // Assignment Admin
    @TimestampConverter() DateTime? adminAssignedAt,
    String? adminAssignedBy,
    String? adminAssignmentNotes,

    // Assignment Moniteur
    @TimestampConverter() DateTime? instructorAssignedAt,
    String? instructorAssignedBy,

    // Check-out / Check-in
    @TimestampConverter() DateTime? checkedOutAt,
    String? checkedOutBy,
    @TimestampConverter() DateTime? checkedInAt,
    String? checkedInBy,

    // État matériel
    String? conditionAtCheckout,
    String? conditionAtCheckin,
    String? damageNotes,

    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EquipmentRental;

  factory EquipmentRental.fromJson(Map<String, dynamic> json) =>
      _$EquipmentRentalFromJson(json);
}
