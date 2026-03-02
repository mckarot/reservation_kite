import '../../domain/models/settings.dart';

abstract class SettingsRepository {
  Future<SchoolSettings?> getSettings();
  Future<void> saveSettings(SchoolSettings settings);
  Future<void> updateWeatherLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  });
}
