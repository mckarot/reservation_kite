# 🌤️ Feature : Configuration Latitude/Longitude Météo

**Document de spécification pour permettre à l'admin de modifier la localisation météo**

---

## 📋 TABLE DES MATIÈRES

1. [Vue d'ensemble](#1-vue-densemble)
2. [Architecture actuelle](#2-architecture-actuelle)
3. [Architecture cible](#3-architecture-cible)
4. [Schéma Firestore](#4-schéma-firestore)
5. [UI/UX](#5-uiux)
6. [Implémentation](#6-implémentation)
7. [Checklist de validation](#7-checklist-de-validation)

---

## 1. VUE D'ENSEMBLE

### Objectif
Permettre à l'administrateur de **modifier la localisation géographique** utilisée pour afficher la météo dans l'application, sans modifier le code ni redéployer.

### Cas d'usage
- 🏖️ **Changement de spot** selon la saison (ex: plage nord en été, plage sud en hiver)
- 🌊 **Plusieurs spots de kite** à proximité
- ✈️ **École itinérante** (voyages, stages)
- 🎯 **Correction** si les coordonnées initiales sont imprécises

### Bénéfices
| Avant | Après |
|-------|-------|
| Coordonnées en dur dans le code | Coordonnées modifiables depuis l'UI |
| Nécessite un redéploiement | Changement instantané |
| Admin dépendant du développeur | Admin autonome |

---

## 2. ARCHITECTURE ACTUELLE

### Code actuel (`lib/services/weather_service.dart`)

```dart
class WeatherService {
  // ❌ Coordonnées en dur (HARDCODED)
  static const double _latitude = 45.123;
  static const double _longitude = -1.456;
  
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  
  Future<Weather> getWeatherForDate(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.parse(
      '$_baseUrl?latitude=$_latitude&longitude=$_longitude&...'
    );
    // ...
  }
}
```

### Problèmes
- 🔴 **Non flexible** : Nécessite une modification du code
- 🔴 **Coûteux** : Redéploiement requis pour chaque changement
- 🔴 **Non autonome** : L'admin doit demander au développeur

---

## 3. ARCHITECTURE CIBLE

### Nouveau flux

```
┌─────────────────────────────────────────────────────────────┐
│  Admin                                                     │
│    ↓                                                       │
│  Modifie Latitude/Longitude dans AdminSettingsScreen       │
│    ↓                                                       │
│  Firestore (settings/school_config)                        │
│    ↓                                                       │
│  WeatherService lit les coordonnées depuis Firestore       │
│    ↓                                                       │
│  Open-Meteo API (avec nouvelles coordonnées)               │
│    ↓                                                       │
│  Tous les élèves voient la météo du bon spot 🎉            │
└─────────────────────────────────────────────────────────────┘
```

### Avantages
- ✅ **Flexible** : Changement en temps réel
- ✅ **Économique** : Aucun redéploiement nécessaire
- ✅ **Autonome** : L'admin gère lui-même

---

## 4. SCHÉMA FIRESTORE

### Collection : `settings`

**Document :** `school_config`

| Champ | Type | Description | Exemple |
|-------|------|-------------|---------|
| `weather_latitude` | `number` | Latitude du spot de kite | `45.123456` |
| `weather_longitude` | `number` | Longitude du spot de kite | `-1.654321` |
| `weather_location_name` | `string` | Nom du spot (optionnel, pour affichage) | `"Plage Principale"` |

### Document Firestore exemple

```json
{
  "school_name": "Kite School Atlantic",
  "opening_hours": { ... },
  "days_off": ["monday"],
  "max_students_per_instructor": 4,
  "weather_latitude": 45.123456,
  "weather_longitude": -1.654321,
  "weather_location_name": "Plage Principale, La Baule"
}
```

### Valeurs par défaut

Si les champs n'existent pas dans Firestore, utiliser des **coordonnées de fallback** :

```dart
// Coordonnées de secours (ex: siège de l'école)
static const double defaultLatitude = 45.123;
static const double defaultLongitude = -1.456;
```

---

## 5. UI/UX

### Écran : Admin Settings

**Emplacement :** Dans `admin_settings_screen.dart`, ajouter une nouvelle section après les réglages existants.

### Maquette visuelle

```
┌─────────────────────────────────────────────────────────────┐
│  RÉGLAGES                                           [✕]    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🕒 HORAIRES D'OUVERTURE                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  | Matin: [08:00 ▼] - Après-midi: [13:00 ▼]            |   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  🌤️ MÉTÉO - LOCALISATION DU SPOT                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  |                                                     |   │
│  |  Latitude                                          |   │
│  |  ┌─────────────────────────────────────────────┐  |   │
│  |  | 45.123456                                   |  |   │
│  |  └─────────────────────────────────────────────┘  |   │
│  |                                                     |   │
│  |  Longitude                                         |   │
│  |  ┌─────────────────────────────────────────────┐  |   │
│  |  | -1.654321                                   |  |   │
│  |  └─────────────────────────────────────────────┘  |   │
│  |                                                     |   │
│  |  ┌─────────────────────────────────────────────┐   │
│  |  | 📍 UTILISER MA POSITION                     |   │
│  |  └─────────────────────────────────────────────┘   │
│  |                                                     |   │
│  |  ┌─────────────────────────────────────────────┐   │
│  |  | 💾 ENREGISTRER LES COORDONNÉES              |   │
│  |  └─────────────────────────────────────────────┘   │
│  |                                                     |   │
│  |  📍 Plage Principale, La Baule, France             |   │
│  |  (Aperçu de la localisation)                       |   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### États de l'UI

| État | Affichage |
|------|-----------|
| **Chargement** | Spinner + "Chargement des coordonnées..." |
| **Mode édition** | Champs latitude/longitude modifiables |
| **Succès** | SnackBar vert "✅ Coordonnées enregistrées" |
| **Erreur** | SnackBar rouge "❌ Échec de l'enregistrement" |
| **Position GPS** | "📍 Utilisation de votre position..." |

### Interactions

| Action | Résultat |
|--------|----------|
| **Modifier manuellement** | L'admin saisit les coordonnées |
| **📍 "Utiliser ma position"** | GPS du téléphone → remplit les champs |
| **💾 "Enregistrer"** | Écrit dans Firestore → mise à jour immédiate |

---

## 6. IMPLÉMENTATION

### Fichiers à créer/modifier

| Fichier | Type | Modification |
|---------|------|--------------|
| `lib/services/weather_service.dart` | Modifier | Lire depuis Firestore |
| `lib/presentation/screens/admin_settings_screen.dart` | Modifier | Ajouter section météo |
| `lib/data/repositories/firestore_settings_repository.dart` | Créer | Repository pour settings |
| `lib/domain/repositories/settings_repository.dart` | Créer | Interface repository |
| `lib/domain/models/school_config.dart` | Créer | Modèle SchoolConfig |
| `firestore_schema.md` | Modifier | Documenter nouveaux champs |

---

### Étape 6.1 : Créer le modèle `SchoolConfig`

**Fichier :** `lib/domain/models/school_config.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_config.freezed.dart';
part 'school_config.g.dart';

@freezed
class SchoolConfig with _$SchoolConfig {
  const factory SchoolConfig({
    @JsonKey(name: 'weather_latitude') double? weatherLatitude,
    @JsonKey(name: 'weather_longitude') double? weatherLongitude,
    @JsonKey(name: 'weather_location_name') String? weatherLocationName,
    // ... autres champs existants (opening_hours, days_off, etc.)
  }) = _SchoolConfig;

  factory SchoolConfig.fromJson(Map<String, dynamic> json) =>
      _$SchoolConfigFromJson(json);
}
```

**Commande :**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Étape 6.2 : Créer le repository Settings

**Fichier :** `lib/domain/repositories/settings_repository.dart`

```dart
import '../models/school_config.dart';

abstract class SettingsRepository {
  Future<SchoolConfig?> getSchoolConfig();
  Future<void> updateWeatherLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  });
}
```

**Fichier :** `lib/data/repositories/firestore_settings_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/school_config.dart';
import '../../domain/repositories/settings_repository.dart';

class FirestoreSettingsRepository implements SettingsRepository {
  final FirebaseFirestore _firestore;

  FirestoreSettingsRepository(this._firestore);

  @override
  Future<SchoolConfig?> getSchoolConfig() async {
    final doc = await _firestore
        .collection('settings')
        .doc('school_config')
        .get();
    
    if (!doc.exists) return null;
    return SchoolConfig.fromJson(doc.data()!);
  }

  @override
  Future<void> updateWeatherLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    await _firestore.collection('settings').doc('school_config').set({
      'weather_latitude': latitude,
      'weather_longitude': longitude,
      if (locationName != null) 'weather_location_name': locationName,
    }, SetOptions(merge: true));
  }
}
```

---

### Étape 6.3 : Mettre à jour `WeatherService`

**Fichier :** `lib/services/weather_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'weather.dart';

class WeatherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Coordonnées par défaut (fallback)
  static const double _defaultLatitude = 45.123;
  static const double _defaultLongitude = -1.456;
  
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Récupère les coordonnées depuis Firestore
  Future<Map<String, double>> _getCoordinates() async {
    try {
      final doc = await _firestore
          .collection('settings')
          .doc('school_config')
          .get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final latitude = data['weather_latitude'] as double?;
        final longitude = data['weather_longitude'] as double?;
        
        if (latitude != null && longitude != null) {
          return {'latitude': latitude, 'longitude': longitude};
        }
      }
    } catch (e) {
      // En cas d'erreur, utiliser les coordonnées par défaut
      print('Erreur lecture coordonnées: $e');
    }
    
    // Fallback aux coordonnées par défaut
    return {
      'latitude': _defaultLatitude,
      'longitude': _defaultLongitude,
    };
  }

  Future<Weather> getWeatherForDate(DateTime date) async {
    final coords = await _getCoordinates();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    
    final url = Uri.parse(
      '$_baseUrl?'
      'latitude=${coords['latitude']}&'
      'longitude=${coords['longitude']}&'
      'daily=weathercode,temperature_2m_max,windspeed_10m_max,winddirection_10m_dominant&'
      'start_date=$formattedDate&'
      'end_date=$formattedDate&'
      'timezone=auto'
    );

    final response = await http.get(url);
    
    if (response.statusCode != 200) {
      throw Exception('Erreur API météo: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Weather.fromJson(json, 0);
  }
}
```

---

### Étape 6.4 : Ajouter la section dans Admin Settings

**Fichier :** `lib/presentation/screens/admin_settings_screen.dart`

**Structure de la nouvelle section :**

```dart
class _WeatherLocationSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_WeatherLocationSection> createState() =>
      _WeatherLocationSectionState();
}

class _WeatherLocationSectionState
    extends ConsumerState<_WeatherLocationSection> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentCoordinates();
  }

  Future<void> _loadCurrentCoordinates() async {
    setState(() => _isLoading = true);
    
    final config = await ref.read(settingsRepositoryProvider).getSchoolConfig();
    
    if (config != null) {
      _latitudeController.text = config.weatherLatitude?.toString() ?? '';
      _longitudeController.text = config.weatherLongitude?.toString() ?? '';
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveCoordinates() async {
    final latitude = double.tryParse(_latitudeController.text);
    final longitude = double.tryParse(_longitudeController.text);
    
    if (latitude == null || longitude == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Coordonnées invalides'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(settingsRepositoryProvider).updateWeatherLocation(
        latitude: latitude,
        longitude: longitude,
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Coordonnées enregistrées'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    // Utiliser le package geolocator pour récupérer la position GPS
    setState(() => _isLoading = true);
    
    try {
      // Demander permission
      // final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // final permission = await Geolocator.checkPermission();
      // final position = await Geolocator.getCurrentPosition();
      
      // _latitudeController.text = position.latitude.toString();
      // _longitudeController.text = position.longitude.toString();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📍 Position actuelle utilisée'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌Erreur GPS: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌤️ MÉTÉO - LOCALISATION DU SPOT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _latitudeController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: 'Ex: 45.123456',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _longitudeController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: 'Ex: -1.654321',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _useCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('📍 Ma position'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveCoordinates,
                    icon: const Icon(Icons.save),
                    label: const Text('💾 Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Étape 6.5 : Ajouter le provider Settings

**Fichier :** `lib/data/providers/repository_providers.dart`

```dart
// Import
import '../../domain/repositories/settings_repository.dart';
import '../repositories/firestore_settings_repository.dart';

// Provider
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return FirestoreSettingsRepository(FirebaseFirestore.instance);
}
```

**Générer le provider :**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Étape 6.6 : Mettre à jour `firestore_schema.md`

**Ajouter dans le tableau des collections :**

```markdown
| `settings/{docId}` | Configuration école | `weather_latitude`, `weather_longitude`, `weather_location_name`, `opening_hours`, ... |
```

---

## 7. CHECKLIST DE VALIDATION

### Validation technique

- [ ] `flutter analyze` — aucun warning
- [ ] `flutter test` — tous les tests passent
- [ ] `build_runner` — code généré sans erreur
- [ ] Firestore — collection `settings` existe
- [ ] Document `school_config` créé avec les nouveaux champs

### Validation fonctionnelle

- [ ] L'admin peut modifier latitude/longitude
- [ ] Le bouton "📍 Ma position" fonctionne (GPS)
- [ ] L'enregistrement met à jour Firestore
- [ ] La météo affiche les données du nouveau spot
- [ ] Les coordonnées par défaut fonctionnent (fallback)

### Validation UX

- [ ] Messages d'erreur clairs (coordonnées invalides)
- [ ] Messages de succès (enregistrement OK)
- [ ] Loading states pendant les opérations
- [ ] `if (!mounted)` après chaque `await`

---

## 📞 RESSOURCES

### Packages Flutter nécessaires

```yaml
dependencies:
  geolocator: ^10.1.0  # Pour récupérer la position GPS
```

### Commandes utiles

```bash
# Ajouter le package
flutter pub add geolocator

# Générer le code
flutter pub run build_runner build --delete-conflicting-outputs

# Analyser
flutter analyze

# Tester sur device
flutter run
```

### Permissions à ajouter

**Android (`AndroidManifest.xml`) :**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**iOS (`Info.plist`) :**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Nous utilisons votre position pour définir la localisation météo</string>
```

---

## 📝 NOTES IMPORTANTES

### Économie de tokens pour l'IA

Quand tu demanderas à l'IA d'implémenter :

1. **Donner ce fichier en contexte** : "Voici le plan : `FEATURE_WEATHER_LOCATION.md`"
2. **Demander étape par étape** :
   - "Commence par l'étape 6.1 : créer le modèle SchoolConfig"
   - "Maintenant fais l'étape 6.2 : créer le repository"
3. **Valider chaque étape** avant de continuer

### Respect des conventions du projet

- Utiliser **uniquement des diffs** (jamais de fichiers complets)
- Respecter l'architecture **Clean Architecture** (data/domain/presentation)
- Utiliser `FieldValue.serverTimestamp()` pour Firestore
- Ajouter `if (!mounted)` après les `await` avec BuildContext
- Retourner des `AsyncValue` dans les Providers

---

**Dernière mise à jour :** 2026-02-26  
**Version du document :** 1.0  
**Statut :** Prêt pour implémentation
