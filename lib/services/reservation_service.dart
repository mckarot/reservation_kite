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

  Future<void> saveReservation(Reservation reservation) async {
    await _repository.saveReservation(reservation);
    await _loadReservations();
  }

  Future<void> deleteReservation(String id) async {
    await _repository.deleteReservation(id);
    await _loadReservations();
  }

  Future<void> toggleConfirmation(String id) async {
    final index = _reservations.indexWhere((r) => r.id == id);
    if (index != -1) {
      final reservation = _reservations[index];
      final updatedReservation = reservation.copyWith(
        status: reservation.status == ReservationStatus.confirmed
            ? ReservationStatus.pending
            : ReservationStatus.confirmed,
      );
      await saveReservation(updatedReservation);
    }
  }
}
