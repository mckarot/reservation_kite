import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum TimeSlot { morning, afternoon }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String clientName,
    required DateTime date,
    required TimeSlot slot,
    String? staffId,
    @Default(false) bool confirmed,
    @Default('') String notes,
    required DateTime createdAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
