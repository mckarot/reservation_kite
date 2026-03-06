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
    @TimestampConverter() required DateTime date,
    required TimeSlot slot,
    @TimestampConverter() required DateTime createdAt,
    @JsonKey(name: 'pupil_id') String? pupilId,
    @JsonKey(name: 'staff_id') String? staffId,
    @Default(ReservationStatus.confirmed) ReservationStatus status,
    @Default('') String notes,
    /// Indique si un matériel doit être assigné par le moniteur.
    /// - true  = admin n'a pas assigné, moniteur DOIT assigner avant de démarrer
    /// - false = matériel assigné ou pas de matériel requis
    @Default(false) @JsonKey(name: 'equipment_assignment_required') bool equipmentAssignmentRequired,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
