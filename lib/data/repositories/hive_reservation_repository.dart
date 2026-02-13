import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../domain/models/reservation.dart';
import '../../database/hive_config.dart';

class HiveReservationRepository implements ReservationRepository {
  Box<Reservation> get _box =>
      Hive.box<Reservation>(HiveConfig.reservationsBox);

  @override
  Future<List<Reservation>> getAllReservations() async {
    return _box.values.toList();
  }

  @override
  Future<void> addReservation(Reservation reservation) async {
    await _box.add(reservation);
  }

  @override
  Future<void> updateReservation(int index, Reservation reservation) async {
    await _box.putAt(index, reservation);
  }

  @override
  Future<void> deleteReservation(int index) async {
    await _box.delete(index);
  }
}
