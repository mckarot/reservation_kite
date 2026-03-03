import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/settings.dart';
import '../../domain/repositories/settings_repository.dart';

class FirestoreSettingsRepository implements SettingsRepository {
  final FirebaseFirestore _firestore;
  static const String _documentPath = 'settings/school_config';

  FirestoreSettingsRepository(this._firestore);

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(_documentPath);

  @override
  Future<SchoolSettings?> getSettings() async {
    final snapshot = await _doc.get();
    if (!snapshot.exists) return null;
    return SchoolSettings.fromJson(snapshot.data()!);
  }

  @override
  Future<void> saveSettings(SchoolSettings settings) async {
    final data = settings.toJson();
    data['updated_at'] = FieldValue.serverTimestamp();
    await _doc.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> updateWeatherLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    await _doc.set({
      'weather_latitude': latitude,
      'weather_longitude': longitude,
      if (locationName != null) 'weather_location_name': locationName,
    }, SetOptions(merge: true));
  }
}
