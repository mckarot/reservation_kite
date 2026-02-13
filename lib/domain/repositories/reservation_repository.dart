import '../models/reservation.dart';

abstract class ReservationRepository {
  Future<List<Reservation>> getAllReservations();
  Future<void> addReservation(Reservation reservation);
  Future<void> updateReservation(int index, Reservation reservation);
  Future<void> deleteReservation(int index);
}
