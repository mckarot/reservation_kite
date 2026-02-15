import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum TimeSlot { morning, afternoon }

enum ReservationStatus { pending, confirmed, cancelled }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String clientName,
    String? pupilId,
    required DateTime date,
    required TimeSlot slot,
    String? staffId,
    @Default(ReservationStatus.confirmed)
    ReservationStatus
    status, // Default to confirmed for backward compatibility with manual entries
    @Default('') String notes,
    required DateTime createdAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
