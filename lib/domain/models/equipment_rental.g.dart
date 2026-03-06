// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_rental.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentRentalImpl _$$EquipmentRentalImplFromJson(
        Map<String, dynamic> json) =>
    _$EquipmentRentalImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      studentEmail: json['student_email'] as String,
      equipmentId: json['equipment_id'] as String,
      equipmentName: json['equipment_name'] as String,
      equipmentCategory: json['equipment_category'] as String,
      equipmentBrand: json['equipment_brand'] as String,
      equipmentModel: json['equipment_model'] as String,
      equipmentSize: (json['equipment_size'] as num).toDouble(),
      dateString: json['date_string'] as String,
      dateTimestamp:
          const TimestampConverter().fromJson(json['date_timestamp']),
      slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
      assignmentType:
          $enumDecode(_$AssignmentTypeEnumMap, json['assignment_type']),
      status: $enumDecodeNullable(_$RentalStatusEnumMap, json['status']) ??
          RentalStatus.pending,
      totalPrice: (json['total_price'] as num?)?.toInt(),
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['payment_status']),
      reservationId: json['reservation_id'] as String?,
      bookedBy: json['booked_by'] as String,
      bookedAt: const TimestampConverter().fromJson(json['booked_at']),
      adminAssignedAt:
          const TimestampConverter().fromJson(json['admin_assigned_at']),
      adminAssignedBy: json['admin_assigned_by'] as String?,
      adminAssignmentNotes: json['admin_assignment_notes'] as String?,
      instructorAssignedAt:
          const TimestampConverter().fromJson(json['instructor_assigned_at']),
      instructorAssignedBy: json['instructor_assigned_by'] as String?,
      checkedOutAt: const TimestampConverter().fromJson(json['checked_out_at']),
      checkedOutBy: json['checked_out_by'] as String?,
      checkedInAt: const TimestampConverter().fromJson(json['checked_in_at']),
      checkedInBy: json['checked_in_by'] as String?,
      conditionAtCheckout: json['condition_at_checkout'] as String?,
      conditionAtCheckin: json['condition_at_checkin'] as String?,
      damageNotes: json['damage_notes'] as String?,
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      updatedAt: const TimestampConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$EquipmentRentalImplToJson(
        _$EquipmentRentalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'student_email': instance.studentEmail,
      'equipment_id': instance.equipmentId,
      'equipment_name': instance.equipmentName,
      'equipment_category': instance.equipmentCategory,
      'equipment_brand': instance.equipmentBrand,
      'equipment_model': instance.equipmentModel,
      'equipment_size': instance.equipmentSize,
      'date_string': instance.dateString,
      'date_timestamp':
          const TimestampConverter().toJson(instance.dateTimestamp),
      'slot': _$TimeSlotEnumMap[instance.slot]!,
      'assignment_type': _$AssignmentTypeEnumMap[instance.assignmentType]!,
      'status': _$RentalStatusEnumMap[instance.status]!,
      'total_price': instance.totalPrice,
      'payment_status': _$PaymentStatusEnumMap[instance.paymentStatus],
      'reservation_id': instance.reservationId,
      'booked_by': instance.bookedBy,
      'booked_at': const TimestampConverter().toJson(instance.bookedAt),
      'admin_assigned_at': _$JsonConverterToJson<dynamic, DateTime>(
          instance.adminAssignedAt, const TimestampConverter().toJson),
      'admin_assigned_by': instance.adminAssignedBy,
      'admin_assignment_notes': instance.adminAssignmentNotes,
      'instructor_assigned_at': _$JsonConverterToJson<dynamic, DateTime>(
          instance.instructorAssignedAt, const TimestampConverter().toJson),
      'instructor_assigned_by': instance.instructorAssignedBy,
      'checked_out_at': _$JsonConverterToJson<dynamic, DateTime>(
          instance.checkedOutAt, const TimestampConverter().toJson),
      'checked_out_by': instance.checkedOutBy,
      'checked_in_at': _$JsonConverterToJson<dynamic, DateTime>(
          instance.checkedInAt, const TimestampConverter().toJson),
      'checked_in_by': instance.checkedInBy,
      'condition_at_checkout': instance.conditionAtCheckout,
      'condition_at_checkin': instance.conditionAtCheckin,
      'damage_notes': instance.damageNotes,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'updated_at': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$TimeSlotEnumMap = {
  TimeSlot.morning: 'morning',
  TimeSlot.afternoon: 'afternoon',
  TimeSlot.fullDay: 'fullDay',
};

const _$AssignmentTypeEnumMap = {
  AssignmentType.studentRental: 'student_rental',
  AssignmentType.adminAssignment: 'admin_assignment',
  AssignmentType.instructorAssignment: 'instructor_assignment',
};

const _$RentalStatusEnumMap = {
  RentalStatus.pending: 'pending',
  RentalStatus.confirmed: 'confirmed',
  RentalStatus.active: 'active',
  RentalStatus.completed: 'completed',
  RentalStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.unpaid: 'unpaid',
  PaymentStatus.paid: 'paid',
  PaymentStatus.refunded: 'refunded',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
