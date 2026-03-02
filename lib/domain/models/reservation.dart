import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum TimeSlot { morning, afternoon, fullDay }

enum ReservationStatus { pending, confirmed, cancelled }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String clientName,
    @TimestampConverter() required DateTime date, required TimeSlot slot, @TimestampConverter() required DateTime createdAt, String? pupilId,
    String? staffId,
    @Default(ReservationStatus.confirmed)
    ReservationStatus
    status, // Default to confirmed for backward compatibility with manual entries
    @Default('') String notes,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
