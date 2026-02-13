import 'package:hive_flutter/hive_flutter.dart';
import '../domain/models/reservation.dart';

class HiveConfig {
  static const String reservationsBox = 'reservations_box';
  static const String usersBox = 'users_box';
  static const String settingsBox = 'settings_box';
  static const String staffBox = 'staff_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Enregistrement des TypeAdapters générés
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ReservationAdapter());
    }

    // Ouverture des boxes au démarrage
    await Future.wait([
      Hive.openBox<Reservation>(reservationsBox),
      Hive.openBox<String>(usersBox),
      Hive.openBox<String>(settingsBox),
      Hive.openBox<String>(staffBox),
    ]);
  }

  static void close() {
    Hive.close();
  }
}
