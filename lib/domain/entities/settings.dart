class Settings {
  final String id;
  final Map<String, dynamic> settingsData;
  final DateTime updatedAt;

  Settings({
    required this.id,
    required this.settingsData,
    required this.updatedAt,
  });

  factory Settings.initial() {
    return Settings(
      id: 'app_settings',
      settingsData: {},
      updatedAt: DateTime.now(),
    );
  }
}