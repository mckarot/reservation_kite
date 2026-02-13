import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../domain/models/reservation.dart';
import '../../database/hive_config.dart';

class HiveReservationRepository implements ReservationRepository {
  Box<String> get _box => Hive.box<String>(HiveConfig.reservationsBox);

  @override
  Future<List<Reservation>> getAllReservations() async {
    return _box.values
        .map(
          (json) =>
              Reservation.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> saveReservation(Reservation reservation) async {
    final json = jsonEncode(reservation.toJson());
    await _box.put(reservation.id, json);
  }

  @override
  Future<void> deleteReservation(String id) async {
    await _box.delete(id);
  }
}
