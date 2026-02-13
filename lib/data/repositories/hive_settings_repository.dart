import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reservation_kite/domain/repositories/settings_repository.dart';
import 'package:reservation_kite/domain/models/settings.dart';
import '../../database/hive_config.dart';

class HiveSettingsRepository implements SettingsRepository {
  Box<String> get _box => Hive.box<String>(HiveConfig.settingsBox);
  static const String _settingsKey = 'global_settings';

  @override
  Future<SchoolSettings?> getSettings() async {
    final json = _box.get(_settingsKey);
    if (json == null) return _defaultSettings();
    return SchoolSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  Future<void> saveSettings(SchoolSettings settings) async {
    final json = jsonEncode(settings.toJson());
    await _box.put(_settingsKey, json);
  }

  SchoolSettings _defaultSettings() {
    return SchoolSettings(
      hours: const OpeningHours(
        morning: TimeSlot(start: '08:00', end: '12:00'),
        afternoon: TimeSlot(start: '13:00', end: '18:00'),
      ),
      maxStudentsPerInstructor: 4,
      updatedAt: DateTime.now(),
    );
  }
}
