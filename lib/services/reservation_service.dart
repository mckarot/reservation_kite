import 'package:flutter/foundation.dart';
import '../domain/models/reservation.dart';
import '../domain/repositories/reservation_repository.dart';

class ReservationService extends ChangeNotifier {
  final ReservationRepository _repository;
  List<Reservation> _reservations = [];

  ReservationService(this._repository) {
    _loadReservations();
  }

  List<Reservation> get reservations => _reservations;

  Future<void> _loadReservations() async {
    _reservations = await _repository.getAllReservations();
    notifyListeners();
  }

  Future<void> addReservation(Reservation reservation) async {
    await _repository.addReservation(reservation);
    await _loadReservations();
  }

  Future<void> updateReservation(int index, Reservation reservation) async {
    await _repository.updateReservation(index, reservation);
    await _loadReservations();
  }

  Future<void> deleteReservation(int index) async {
    await _repository.deleteReservation(index);
    await _loadReservations();
  }

  Future<void> toggleConfirmation(int index) async {
    final reservation = _reservations[index];
    final updatedReservation = Reservation(
      id: reservation.id,
      clientName: reservation.clientName,
      reservationDate: reservation.reservationDate,
      kiteType: reservation.kiteType,
      confirmed: !reservation.confirmed,
    );
    await updateReservation(index, updatedReservation);
  }
}
