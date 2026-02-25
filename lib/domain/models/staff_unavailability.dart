import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';
import 'reservation.dart'; // Pour TimeSlot

part 'staff_unavailability.freezed.dart';
part 'staff_unavailability.g.dart';

enum UnavailabilityStatus { pending, approved, rejected }

@freezed
class StaffUnavailability with _$StaffUnavailability {
  const factory StaffUnavailability({
    required String id,
    @JsonKey(name: 'instructor_id') required String staffId,
    @TimestampConverter() required DateTime date,
    required TimeSlot slot, // morning, afternoon, or full_day?
    required String reason,
    @Default(UnavailabilityStatus.pending) UnavailabilityStatus status,
    @TimestampConverter()
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _StaffUnavailability;

  factory StaffUnavailability.fromJson(Map<String, dynamic> json) =>
      _$StaffUnavailabilityFromJson(json);
}
