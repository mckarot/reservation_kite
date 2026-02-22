import 'package:hive_flutter/hive_flutter.dart';
// import '../domain/models/reservation.dart'; // Supprimé car inutilisé directement ici

class HiveConfig {
  static const String reservationsBox = 'reservations_box';
  static const String usersBox = 'users_box';
  static const String settingsBox = 'settings_box';
  static const String staffBox = 'staff_box';
  static const String equipmentBox = 'equipment_box';
  static const String creditPacksBox = 'credit_packs_box';
  static const String unavailabilitiesBox = 'unavailabilities_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Ouverture des boxes au démarrage
    await Future.wait([
      Hive.openBox<String>(reservationsBox),
      Hive.openBox<String>(usersBox),
      Hive.openBox<String>(settingsBox),
      Hive.openBox<String>(staffBox),
      Hive.openBox<String>(equipmentBox),
      Hive.openBox<String>(creditPacksBox),
      Hive.openBox<String>(unavailabilitiesBox),
    ]);
  }

  static void close() {
    Hive.close();
  }
}
