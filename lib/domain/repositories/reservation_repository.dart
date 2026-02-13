import '../models/reservation.dart';

abstract class ReservationRepository {
  Future<List<Reservation>> getAllReservations();
  Future<void> saveReservation(Reservation reservation);
  Future<void> deleteReservation(String id);
}
