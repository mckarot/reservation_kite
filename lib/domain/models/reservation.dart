import 'package:hive_flutter/hive_flutter.dart';

part 'reservation.g.dart';

@HiveType(typeId: 0)
class Reservation extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String clientName;

  @HiveField(2)
  final DateTime reservationDate;

  @HiveField(3)
  final String kiteType;

  @HiveField(4)
  final bool confirmed;

  Reservation({
    required this.id,
    required this.clientName,
    required this.reservationDate,
    required this.kiteType,
    this.confirmed = false,
  });
}
