# 🎨 SYSTÈME DE THÈME ET MODE SOMBRE/CLAIR

**Document de suivi des fonctionnalités pour la gestion des thèmes de l'application**

**Créé le :** 2026-02-27
**Statut :** 🔴 À faire
**Priorité :** Haute
**Fichiers concernés :** 
- `lib/presentation/providers/theme_notifier.dart` (à créer)
- `lib/presentation/theme/app_theme.dart` (à créer)
- `lib/main.dart` (à modifier)
- `lib/presentation/screens/settings_screen.dart` (à modifier)

---

## 📋 VUE D'ENSEMBLE

### Contexte

Actuellement, l'application Reservation Kite utilise des couleurs **en dur** dans tout le code :
- Couleurs définies directement dans les widgets
- Pas de système de thème centralisé
- Pas de mode sombre/clair
- Difficile de changer les couleurs de l'application

### Fonctionnalités manquantes

L'application devrait pouvoir :
- 🌙 **Basculer** entre mode clair et mode sombre
- 🎨 **Personnaliser** les couleurs principales (primaire, secondaire, accent)
- 💾 **Sauvegarder** les préférences de thème dans Firestore/SharedPreferences
- 🔄 **Appliquer** le thème dynamiquement sans redémarrage
- 🌍 **Respecter** le thème système (optionnel)

---

## 🎯 OBJECTIFS

### Objectif principal

Implémenter un système de thème complet permettant de basculer entre mode clair/sombre et de personnaliser les couleurs de l'application.

### Objectifs secondaires

- Centraliser toutes les couleurs dans un fichier de thème
- Utiliser `ColorScheme` de Flutter pour une cohérence parfaite
- Sauvegarder les préférences utilisateur localement
- Permettre à l'admin de définir les couleurs de la marque
- Supporter le thème système (iOS/Android)

---

## 📊 ÉTAT ACTUEL

### Couleurs utilisées actuellement

```dart
// Couleurs primaires (bleu kitesurf)
Colors.blue.shade800
Colors.blue.shade700
Colors.blue.shade500

// Couleurs d'accent
Colors.cyanAccent
Colors.indigo

// Couleurs de statut
Colors.green      // Disponible/Succès
Colors.orange     // Attention/Maintenance
Colors.red        // Erreur/Endommagé
Colors.grey       // Neutre/Désactivé
```

### Problèmes identifiés

| Problème | Impact | Solution |
|----------|--------|----------|
| Couleurs en dur dans les widgets | Difficile à maintenir | Utiliser `Theme.of(context)` |
| Pas de mode sombre | Mauvaise UX la nuit | Implémenter DarkTheme |
| Pas de personnalisation | Marque non personnalisable | Système de ColorScheme |
| Pas de persistance | Perte des préférences | SharedPreferences/Firestore |
| Thème non dynamique | Nécessite redémarrage | Provider/Notifier |

---

## 🏗️ ARCHITECTURE PROPOSÉE

### Structure de données

```dart
// Dans lib/domain/models/app_theme_settings.dart
@freezed
class AppThemeSettings with _$AppThemeSettings {
  const factory AppThemeSettings({
    required ThemeMode themeMode, // light, dark, system
    required Color primaryColor,
    required Color secondaryColor,
    required Color accentColor,
    required String? backgroundPattern, // optionnel
  }) = _AppThemeSettings;
  
  // Couleurs par défaut (bleu kitesurf)
  static const defaultPrimary = Color(0xFF1976D2);
  static const defaultSecondary = Color(0xFF42A5F5);
  static const defaultAccent = Colors.cyanAccent;
}
```

### Architecture Riverpod

```
┌─────────────────────────────────────────┐
│           UI Layer (Widgets)            │
│  - SettingsScreen                       │
│  - ThemeSelector Widget                 │
│  - ColorPicker Widget                   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         StateNotifierProvider           │
│      themeNotifierProvider              │
│  - watch(): AppThemeSettings            │
│  - setThemeMode(ThemeMode)              │
│  - setPrimaryColor(Color)               │
│  - setSecondaryColor(Color)             │
│  - resetToDefaults()                    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         Repository Layer                │
│    ThemeSettingsRepository              │
│  - getSettings()                        │
│  - saveSettings(AppThemeSettings)       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         Data Source Layer               │
│  - LocalDataSource (SharedPreferences)  │
│  - RemoteDataSource (Firestore)         │
└─────────────────────────────────────────┘
```

---

## 🎨 PALETTES DE COULEURS

### Thème Clair (Light Mode)

```dart
LightThemeData(
  primary: Color(0xFF1976D2),      // Bleu principal
  secondary: Color(0xFF42A5F5),    // Bleu clair
  accent: Colors.cyanAccent,       // Cyan
  background: Colors.white,
  surface: Colors.grey.shade50,
  error: Colors.red.shade700,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onBackground: Colors.black87,
  onSurface: Colors.black87,
  onError: Colors.white,
)
```

### Thème Sombre (Dark Mode)

```dart
DarkThemeData(
  primary: Color(0xFF42A5F5),      // Bleu plus clair
  secondary: Color(0xFF1976D2),    // Bleu foncé
  accent: Colors.cyanAccent,       // Cyan (reste)
  background: Color(0xFF121212),   // Noir Material
  surface: Color(0xFF1E1E1E),      // Gris foncé
  error: Colors.red.shade400,
  onPrimary: Colors.black87,
  onSecondary: Colors.white,
  onBackground: Colors.white,
  onSurface: Colors.white,
  onError: Colors.black87,
)
```

### Thèmes prédéfinis (pour l'admin)

```dart
// Thème Kitesurf (défaut)
primary: Blue, accent: Cyan

// Thème Sunset
primary: Orange, accent: Yellow

// Thème Ocean
primary: Teal, accent: Blue

// Thème Tropical
primary: Green, accent: Yellow

// Thème Midnight
primary: Purple, accent: Pink
```

---

## 📝 SPÉCIFICATIONS FONCTIONNELLES

### 5.1 Gestion du mode sombre/clair

#### 🌙 Basculer le thème
- Settings Screen → Section "Apparence"
- 3 options :
  - ☀️ Clair
  - 🌙 Sombre
  - 📱 Système (suit le device)
- Changement instantané (animation fade)
- Sauvegarde automatique

#### 💾 Persistance
- SharedPreferences en local
- Firestore en backup (optionnel)
- Chargement au démarrage de l'app

---

### 5.2 Personnalisation des couleurs

#### 🎨 Sélecteur de couleur
- Settings Screen → Section "Couleurs de la marque"
- 5 presets (Kitesurf, Sunset, Ocean, Tropical, Midnight)
- Custom color picker (roue chromatique)
- Preview en temps réel
- Reset aux couleurs par défaut

#### 🔄 Application du thème
- Toutes les couleurs utilisent `Theme.of(context)`
- Les widgets existants sont mis à jour automatiquement
- Animation de transition (300ms)

---

### 5.3 Interface utilisateur

#### Écran Settings (à modifier)

```
┌─────────────────────────────────────────┐
│  Paramètres                             │
├─────────────────────────────────────────┤
│                                         │
│  ─── APPARENCE ───                      │
│                                         │
│  ☀️ Mode Clair                          │
│  🌙 Mode Sombre           [●]           │
│  📱 Système                             │
│                                         │
│  ─── COULEURS DE LA MARQUE ───          │
│                                         │
│  [Kitesurf] [Sunset] [Ocean]            │
│  [Tropical] [Midnight] [Custom...]      │
│                                         │
│  Couleur principale:  [■ Bleu]          │
│  Couleur secondaire:  [■ Cyan]          │
│  Couleur d'accent:    [■ Jaune]         │
│                                         │
│  [Aperçu]              [Réinitialiser]  │
│                                         │
└─────────────────────────────────────────┘
```

#### Widget ThemeSelector

```dart
ThemeSelector(
  selectedTheme: currentTheme,
  onThemeSelected: (theme) => ref.read(themeNotifierProvider.notifier).setTheme(theme),
)
```

#### Widget ColorPicker

```dart
ColorPicker(
  selectedColor: primaryColor,
  onColorSelected: (color) => ref.read(themeNotifierProvider.notifier).setPrimaryColor(color),
  presetColors: [/* 5 thèmes prédéfinis */],
)
```

---

## 🔧 IMPLÉMENTATION TECHNIQUE

### Fichiers à créer

| Fichier | Description | Priorité |
|---------|-------------|----------|
| `lib/domain/models/app_theme_settings.dart` | Modèle de thème | 🔴 Haute |
| `lib/domain/models/theme_preset.dart` | Préréglages de thème | 🟠 Moyenne |
| `lib/data/sources/theme_local_datasource.dart` | SharedPreferences | 🔴 Haute |
| `lib/data/repositories/theme_repository.dart` | Repository | 🔴 Haute |
| `lib/presentation/providers/theme_notifier.dart` | Provider Riverpod | 🔴 Haute |
| `lib/presentation/theme/app_theme.dart` | Thèmes Flutter | 🔴 Haute |
| `lib/presentation/widgets/theme_selector.dart` | Widget sélecteur | 🟠 Moyenne |
| `lib/presentation/widgets/color_picker.dart` | Widget couleurs | 🟠 Moyenne |
| `lib/presentation/widgets/theme_preview.dart` | Aperçu thème | 🟡 Basse |

### Fichiers à modifier

| Fichier | Modification | Priorité |
|---------|--------------|----------|
| `lib/main.dart` | Utiliser themeNotifier | 🔴 Haute |
| `lib/presentation/screens/settings_screen.dart` | Ajouter section thème | 🔴 Haute |
| `lib/l10n/app_*.arb` | Ajouter traductions | 🟡 Basse |
| Tous les écrans | Remplacer couleurs en dur | 🟡 Basse |

---

## 📋 TODO LIST

### 📌 PHASE 1 : MODÈLES DE DONNÉES

#### Tâche 1.1 : Créer le modèle `AppThemeSettings`
- [ ] Créer `lib/domain/models/app_theme_settings.dart`
- [ ] Définir les champs : themeMode, primaryColor, secondaryColor, accentColor
- [ ] Ajouter les méthodes `fromJson` / `toJson`
- [ ] Ajouter Freezed + JsonSerializable
- [ ] Lancer `flutter pub run build_runner build --delete-conflicting-outputs`

#### Tâche 1.2 : Créer le modèle `ThemePreset`
- [ ] Créer `lib/domain/models/theme_preset.dart`
- [ ] Définir les 5 thèmes prédéfinis (Kitesurf, Sunset, Ocean, Tropical, Midnight)
- [ ] Chaque thème a : id, name, icon, primaryColor, secondaryColor, accentColor
- [ ] Ajouter une méthode `getAllPresets()`

**✅ Phase 1 terminée quand :** [ ] 1.1 [ ] 1.2

---

### 📌 PHASE 2 : COUCHE DONNÉES

#### Tâche 2.1 : DataSource locale (SharedPreferences)
- [ ] Créer `lib/data/sources/theme_local_datasource.dart`
- [ ] Implémenter les méthodes :
  - [ ] `Future<AppThemeSettings?> getSettings()`
  - [ ] `Future<void> saveSettings(AppThemeSettings settings)`
  - [ ] `Future<void> clearSettings()`
- [ ] Sérialiser les couleurs en int (color.value)

#### Tâche 2.2 : Repository
- [ ] Créer `lib/data/repositories/theme_repository.dart`
- [ ] Implémenter les méthodes :
  - [ ] `Future<AppThemeSettings> getThemeSettings()`
  - [ ] `Future<void> updateThemeSettings(AppThemeSettings settings)`
  - [ ] `Future<void> resetToDefaults()`

**✅ Phase 2 terminée quand :** [ ] 2.1 [ ] 2.2

---

### 📌 PHASE 3 : PROVIDER RIVERPOD

#### Tâche 3.1 : ThemeNotifier
- [ ] Créer `lib/presentation/providers/theme_notifier.dart`
- [ ] Étendre `StateNotifier<AppThemeSettings>`
- [ ] Implémenter les actions :
  - [ ] `setThemeMode(ThemeMode mode)`
  - [ ] `setPrimaryColor(Color color)`
  - [ ] `setSecondaryColor(Color color)`
  - [ ] `setAccentColor(Color color)`
  - [ ] `applyPreset(ThemePreset preset)`
  - [ ] `resetToDefaults()`
- [ ] Sauvegarder automatiquement dans le repository

#### Tâche 3.2 : Provider d'initialisation
- [ ] Créer `themeSettingsProvider` (AsyncProvider)
- [ ] Charger les settings au démarrage
- [ ] Gérer les états : loading, data, error

**✅ Phase 3 terminée quand :** [ ] 3.1 [ ] 3.2

---

### 📌 PHASE 4 : THÈMES FLUTTER

#### Tâche 4.1 : Créer app_theme.dart
- [ ] Créer `lib/presentation/theme/app_theme.dart`
- [ ] Implémenter `AppTheme.createLightTheme(AppThemeSettings settings)`
- [ ] Implémenter `AppTheme.createDarkTheme(AppThemeSettings settings)`
- [ ] Utiliser `ColorScheme.fromSeed()` ou `ColorScheme.light/dark()`
- [ ] Définir tous les composants :
  - [ ] AppBarTheme
  - [ ] CardTheme
  - [ ] FloatingActionButtonTheme
  - [ ] BottomNavigationBarTheme
  - [ ] SwitchTheme
  - [ ] ElevatedButtonTheme
  - [ ] InputDecorationTheme

#### Tâche 4.2 : Intégration dans main.dart
- [ ] Modifier `main.dart` pour utiliser `themeNotifierProvider`
- [ ] Passer `themeMode` à `MaterialApp`
- [ ] Passer `theme` et `darkTheme`
- [ ] Tester le basculement

**✅ Phase 4 terminée quand :** [ ] 4.1 [ ] 4.2

---

### 📌 PHASE 5 : INTERFACE UTILISATEUR

#### Tâche 5.1 : Widget ThemeSelector
- [ ] Créer `lib/presentation/widgets/theme_selector.dart`
- [ ] Afficher les 3 options (Clair, Sombre, Système)
- [ ] Utiliser RadioListTile ou SegmentedButton
- [ ] Appeler `themeNotifierProvider.notifier.setThemeMode()`

#### Tâche 5.2 : Widget ColorPicker
- [ ] Créer `lib/presentation/widgets/color_picker.dart`
- [ ] Afficher les presets (boutons avec couleurs)
- [ ] Implémenter color picker custom (package : `flutter_colorpicker`)
- [ ] Preview en temps réel

#### Tâche 5.3 : Widget ThemePreview
- [ ] Créer `lib/presentation/widgets/theme_preview.dart`
- [ ] Afficher un mini aperçu du thème
- [ ] Montrer AppBar, Card, FAB, Switch

#### Tâche 5.4 : Modifier SettingsScreen
- [ ] Ajouter section "Apparence"
- [ ] Ajouter section "Couleurs de la marque"
- [ ] Intégrer ThemeSelector, ColorPicker, ThemePreview
- [ ] Ajouter bouton "Réinitialiser"

**✅ Phase 5 terminée quand :** [ ] 5.1 [ ] 5.2 [ ] 5.3 [ ] 5.4

---

### 📌 PHASE 6 : MIGRATION DES COULEURS

#### Tâche 6.1 : Identifier les couleurs en dur
- [ ] Rechercher `Colors.blue.shade` dans tout le projet
- [ ] Rechercher `Colors.indigo`, `Colors.cyanAccent`
- [ ] Rechercher `Color(0xFF...)`
- [ ] Lister tous les fichiers concernés

#### Tâche 6.2 : Remplacer par Theme.of(context)
- [ ] Remplacer `Colors.blue.shade800` → `Theme.of(context).primaryColor`
- [ ] Remplacer `Colors.cyanAccent` → `Theme.of(context).colorScheme.secondary`
- [ ] Remplacer `Colors.grey.shade100` → `Theme.of(context).cardColor`
- [ ] Utiliser `colorScheme` pour la cohérence

#### Tâche 6.3 : Tester tous les écrans
- [ ] PupilMainScreen
- [ ] PupilBookingScreen
- [ ] PupilDashboardTab
- [ ] PupilProgressTab
- [ ] MonitorMainScreen
- [ ] EquipmentAdminScreen
- [ ] SettingsScreen
- [ ] Tous les autres écrans

**✅ Phase 6 terminée quand :** [ ] 6.1 [ ] 6.2 [ ] 6.3

---

### 📌 PHASE 7 : INTERNATIONALISATION

#### Tâche 7.1 : Clés de traduction
- [ ] Ajouter dans les 5 fichiers `.arb` :
  - `appearanceSection` : "Apparence"
  - `themeMode` : "Mode du thème"
  - `lightMode` : "Clair"
  - `darkMode` : "Sombre"
  - `systemTheme` : "Système"
  - `brandColors` : "Couleurs de la marque"
  - `primaryColor` : "Couleur principale"
  - `secondaryColor` : "Couleur secondaire"
  - `accentColor` : "Couleur d'accent"
  - `themePresets` : "Thèmes prédéfinis"
  - `customColor` : "Personnalisé..."
  - `preview` : "Aperçu"
  - `resetToDefaults` : "Réinitialiser"
  - `themeApplied` : "Thème appliqué !"
  - `colorsReset` : "Couleurs réinitialisées"

#### Tâche 7.2 : Traductions
- [ ] Français (app_fr.arb)
- [ ] Anglais (app_en.arb)
- [ ] Espagnol (app_es.arb)
- [ ] Portugais (app_pt.arb)
- [ ] Chinois (app_zh.arb)
- [ ] Lancer `flutter gen-l10n`
- [ ] Tester dans les 5 langues

**✅ Phase 7 terminée quand :** [ ] 7.1 [ ] 7.2

---

### 📌 PHASE 8 : TESTS ET VALIDATION

#### Tâche 8.1 : Tests unitaires
- [ ] Tester le modèle `AppThemeSettings`
- [ ] Tester le repository
- [ ] Tester le notifier (états et actions)

#### Tâche 8.2 : Tests d'intégration
- [ ] Tester le basculement clair/sombre
- [ ] Tester la personnalisation des couleurs
- [ ] Tester la persistance (fermer/réouvrir l'app)
- [ ] Tester les presets

#### Tâche 8.3 : Tests manuels
- [ ] Tester dans les 5 langues
- [ ] Tester tous les écrans en mode clair
- [ ] Tester tous les écrans en mode sombre
- [ ] Tester avec différents presets
- [ ] Vérifier les contrastes (accessibilité)
- [ ] Tester sur iOS et Android

#### Tâche 8.4 : Validation finale
- [ ] `flutter analyze` - 0 erreur
- [ ] `flutter test` - Tous les tests passent
- [ ] Build release : `flutter build apk --release` (Android)
- [ ] Build release : `flutter build ios --release` (iOS)

**✅ Phase 8 terminée quand :** [ ] 8.1 [ ] 8.2 [ ] 8.3 [ ] 8.4

---

## 📈 SUIVI DE PROGRESSION

| Phase | Tâches | Statut | % |
|-------|--------|--------|---|
| Phase 1 : Modèles de données | 2 | 🔴 À faire | 0% |
| Phase 2 : Couche données | 2 | 🔴 À faire | 0% |
| Phase 3 : Provider Riverpod | 2 | 🔴 À faire | 0% |
| Phase 4 : Thèmes Flutter | 2 | 🔴 À faire | 0% |
| Phase 5 : Interface utilisateur | 4 | 🔴 À faire | 0% |
| Phase 6 : Migration des couleurs | 3 | 🔴 À faire | 0% |
| Phase 7 : Internationalisation | 2 | 🔴 À faire | 0% |
| Phase 8 : Tests et validation | 4 | 🔴 À faire | 0% |
| **TOTAL** | **21** | **🔴 À faire** | **0%** |

---

## 🚧 RISQUES IDENTIFIÉS

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Couleurs manquantes dans certains écrans | 🟡 Moyenne | 🟠 Moyenne | Audit complet + tests manuels |
| Contraste insuffisant en mode sombre | 🟡 Moyenne | 🟠 Moyenne | Utiliser Material Design guidelines |
| Performance (rebuilds fréquents) | 🟡 Moyenne | 🟢 Faible | Optimiser avec `Selector` ou `watch` ciblé |
| Perte des préférences | 🔴 Critique | 🟢 Faible | SharedPreferences + validation |
| Incompatibilité package colorpicker | 🟡 Moyenne | 🟢 Faible | Utiliser un package populaire et maintenu |

---

## 📦 DÉPENDANCES À AJOUTER

```yaml
dependencies:
  shared_preferences: ^2.2.2      # Pour la persistance locale
  flutter_colorpicker: ^1.0.3     # Pour le color picker (optionnel)

dev_dependencies:
  # Déjà présents pour Freezed et JsonSerializable
```

**Alternative :** Implémenter un color picker simple sans dépendance

---

## 🎯 CRITÈRES D'ACCEPTATION

### Fonctionnels
- [ ] L'utilisateur peut basculer entre mode clair et mode sombre
- [ ] L'utilisateur peut sélectionner le mode "Système"
- [ ] L'admin peut choisir parmi 5 presets de couleurs
- [ ] L'admin peut personnaliser chaque couleur individuellement
- [ ] Les préférences sont sauvegardées et persistantes
- [ ] Le thème s'applique instantanément (sans redémarrage)
- [ ] Tous les écrans utilisent les couleurs du thème

### Techniques
- [ ] 0 erreur `flutter analyze`
- [ ] Tous les tests unitaires passent
- [ ] Tous les tests d'intégration passent
- [ ] Build release Android et iOS fonctionnels
- [ ] Performances acceptables (< 16ms/frame)
- [ ] Contrastes conformes WCAG AA (accessibilité)

### UX
- [ ] Animations fluides pendant le basculement
- [ ] Feedback visuel clair (succès, erreur)
- [ ] Interface cohérente avec le reste de l'application
- [ ] Mode sombre vraiment confortable (pas de blanc pur)
- [ ] Couleurs personnalisables intuitives

---

## 📝 NOTES

- **Package recommandé :** `flutter_colorpicker` (léger et maintenu)
- **Alternative :** `material_color_utilities` pour générer des tons
- **Persistance :** Commencer par SharedPreferences, Firestore en option
- **Accessibilité :** Vérifier les contrastes (ratio 4.5:1 minimum)
- **Material 3 :** Utiliser `ColorScheme.fromSeed()` pour générer les tons
- **Thème système :** Écouter `MediaQuery.platformBrightness`

---

## ✅ HISTORIQUE DES MODIFICATIONS

| Date | Version | Description | Auteur |
|------|---------|-------------|--------|
| 2026-02-27 | 1.0 | Création du document | IA |

---

**🎯 Prochaine étape :** Commencer la Phase 1 (Modèles de données)

---
