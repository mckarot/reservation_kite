import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_booking.freezed.dart';
part 'equipment_booking.g.dart';

enum EquipmentBookingSlot {
  @JsonValue('morning')
  morning,
  @JsonValue('afternoon')
  afternoon,
  @JsonValue('full_day')
  fullDay,
}

enum EquipmentBookingStatus {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}

enum EquipmentBookingType {
  @JsonValue('student')
  student,
  @JsonValue('assignment')
  assignment,
  @JsonValue('staff')
  staff,
}

String _anyToString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

@freezed
class EquipmentBooking with _$EquipmentBooking {
  const factory EquipmentBooking({
    required String id,
    required String userId,
    required String userName,
    required String userEmail,
    required String equipmentId,
    required String equipmentType,
    required String equipmentBrand,
    required String equipmentModel,
    @JsonKey(fromJson: _anyToString) required String equipmentSize,
    required String dateString,
    required DateTime dateTimestamp,
    required EquipmentBookingSlot slot,
    required EquipmentBookingStatus status,
    required DateTime createdAt, required DateTime updatedAt, required String createdBy, @Default(EquipmentBookingType.student) EquipmentBookingType type,
    String? assignedBy,
    String? sessionId,
    String? notes,
  }) = _EquipmentBooking;

  factory EquipmentBooking.fromJson(Map<String, dynamic> json) =>
      _$EquipmentBookingFromJson(json);
}
