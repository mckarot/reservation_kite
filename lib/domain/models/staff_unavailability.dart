import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'reservation.dart'; // Pour TimeSlot

part 'staff_unavailability.freezed.dart';
part 'staff_unavailability.g.dart';

@HiveType(typeId: 10)
enum UnavailabilityStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  approved,
  @HiveField(2)
  rejected,
}

@freezed
class StaffUnavailability with _$StaffUnavailability {
  @HiveType(typeId: 11)
  const factory StaffUnavailability({
    @HiveField(0) required String id,
    @HiveField(1) required String staffId,
    @HiveField(2) required DateTime date,
    @HiveField(3) required TimeSlot slot, // morning, afternoon, or full_day?
    // On va considérer que TimeSlot couvre morning/afternoon.
    // Pour une journée entière, on créera deux entrées ou on ajoutera une option.
    // Restons simple avec morning/afternoon.
    @HiveField(4) required String reason,
    @HiveField(5)
    @Default(UnavailabilityStatus.pending)
    UnavailabilityStatus status,
    @HiveField(6) required DateTime createdAt,
  }) = _StaffUnavailability;

  factory StaffUnavailability.fromJson(Map<String, dynamic> json) =>
      _$StaffUnavailabilityFromJson(json);
}
