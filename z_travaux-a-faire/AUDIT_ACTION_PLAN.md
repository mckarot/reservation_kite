# 📋 Plan d'Amélioration Qualité - Reservation Kite

**Date de création :** 1 mars 2026  
**Score actuel :** 8.25/10  
**Objectif :** 9.5/10

---

## 🎯 Priorité 1 : Constructeurs `const` (Impact: 10-15% perf)

### Fichiers à modifier

- [ ] `lib/main.dart`
  - [ ] Ligne 73 : `Scaffold(body: Center(child: CircularProgressIndicator()))` → ajouter `const`
  - [ ] Ligne 74 : `Scaffold(body: Center(child: Text('Erreur: $e')))` → ajouter `const`

- [ ] `lib/presentation/screens/login_screen.dart`
  - [ ] Ligne 12 : `ConsumerState<LoginScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/booking_screen.dart`
  - [ ] Ligne 12 : `ConsumerState<BookingScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/monitor_main_screen.dart`
  - [ ] Ligne 16 : `ConsumerState<MonitorMainScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/pupil_main_screen.dart`
  - [ ] Ligne 12 : `ConsumerState<PupilMainScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/registration_screen.dart`
  - [ ] Ligne 12 : `ConsumerState<RegistrationScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/admin_settings_screen.dart`
  - [ ] Ligne 16 : `ConsumerState<AdminSettingsScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/equipment_admin_screen.dart`
  - [ ] Ligne 12 : `ConsumerState<EquipmentAdminScreen>` → constructeur de la State en `const`

- [ ] `lib/presentation/screens/admin_dashboard_screen.dart`
  - [ ] Ligne 155 : Widgets mappés dans `pending.map()` → ajouter `const`

- [ ] `lib/presentation/screens/user_directory_screen.dart`
  - [ ] Ligne 56 : `ListView.builder` items → ajouter `const` où possible

- [ ] `lib/presentation/screens/staff_admin_screen.dart`
  - [ ] Ligne 67 : `ListView.builder` items → ajouter `const` où possible

- [ ] `lib/presentation/screens/equipment_category_admin_screen.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/screens/credit_pack_admin_screen.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/screens/lesson_validation_screen.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/screens/pupil_booking_screen.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/widgets/pupil_dashboard_tab.dart`
  - [ ] Ligne 176 : `_CurrentWeatherCard()` → déjà `const` ✅
  - [ ] Ligne 267 : `_WeatherInfoItem()` → déjà `const` ✅
  - [ ] Ligne 289 : `_StatItem()` → déjà `const` ✅
  - [ ] Vérifier autres widgets

- [ ] `lib/presentation/widgets/pupil_progress_tab.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/widgets/pupil_history_tab.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/widgets/color_picker.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/widgets/theme_selector.dart`
  - [ ] Vérifier tous les widgets non-`const`

- [ ] `lib/presentation/widgets/theme_preview.dart`
  - [ ] Vérifier tous les widgets non-`const`

---

## 🎯 Priorité 2 : Keys dans les listes (Prévention bugs)

### Fichiers à modifier

- [ ] `lib/presentation/screens/staff_admin_screen.dart`
  - [ ] Ligne 67-80 : `ListView.builder` → ajouter `key: ValueKey(staff.id)` sur Container/ListTile

- [ ] `lib/presentation/screens/equipment_admin_screen.dart`
  - [ ] Ligne 89 : `ListView.builder` → ajouter `key: ValueKey(equipment.id)` sur `_EquipmentTile`

- [ ] `lib/presentation/screens/user_directory_screen.dart`
  - [ ] Ligne 56 : `ListView.builder` → ajouter `key: ValueKey(user.id)` sur ListTile

- [ ] `lib/presentation/screens/admin_dashboard_screen.dart`
  - [ ] Ligne 155 : `pending.map((u) => Card(...))` → ajouter `key: ValueKey(u.id)`

- [ ] `lib/presentation/widgets/pupil_progress_tab.dart`
  - [ ] Ligne 120 : `Wrap` children → ajouter `key: ValueKey(...)` sur chaque enfant

- [ ] `lib/presentation/screens/equipment_category_admin_screen.dart`
  - [ ] Ligne 85 : Déjà `key: ValueKey(category.id)` ✅

- [ ] `lib/presentation/screens/booking_screen.dart`
  - [ ] Vérifier toutes les listes dynamiques

- [ ] `lib/presentation/screens/monitor_main_screen.dart`
  - [ ] Vérifier toutes les listes dynamiques

- [ ] `lib/presentation/screens/lesson_validation_screen.dart`
  - [ ] Vérifier toutes les listes dynamiques

---

## 🎯 Priorité 3 : RepaintBoundary (Optimisation paint)

### Fichiers à modifier

- [ ] `lib/presentation/widgets/pupil_dashboard_tab.dart`
  - [ ] Ligne 52-90 : `_CurrentWeatherCard` → entourer avec `RepaintBoundary`
  - [ ] Progress indicators → entourer avec `RepaintBoundary`

- [ ] `lib/presentation/screens/monitor_main_screen.dart`
  - [ ] Ligne 180-200 : `_DateSelector` → entourer avec `RepaintBoundary`
  - [ ] Sections avec animations → entourer avec `RepaintBoundary`

- [ ] `lib/presentation/screens/pupil_booking_screen.dart`
  - [ ] Ligne 100-150 : Weather info section → entourer avec `RepaintBoundary`

- [ ] `lib/presentation/widgets/pupil_progress_tab.dart`
  - [ ] Progress bars → entourer avec `RepaintBoundary`

- [ ] `lib/presentation/widgets/color_picker.dart`
  - [ ] Preview de couleur → entourer avec `RepaintBoundary`

---

## 🎯 Priorité 4 : Selecteurs ciblés (Réduction rebuilds)

### Fichiers à modifier

- [ ] `lib/presentation/screens/login_screen.dart`
  - [ ] Ligne 67-73 : Remplacer watch complet par `ref.watch(themeNotifierProvider.select(...))`

- [ ] `lib/presentation/screens/admin_screen.dart`
  - [ ] Ligne 30-35 : Remplacer watch complet par `ref.watch(themeNotifierProvider.select(...))`

- [ ] `lib/presentation/screens/monitor_main_screen.dart`
  - [ ] Ligne 36-40 : Remplacer watch complet par `ref.watch(themeNotifierProvider.select(...))`

- [ ] `lib/presentation/screens/pupil_main_screen.dart`
  - [ ] Ligne 24-28 : Remplacer watch complet par `ref.watch(themeNotifierProvider.select(...))`

- [ ] `lib/presentation/screens/booking_screen.dart`
  - [ ] Ligne 30-34 : Remplacer watch complet par `ref.watch(themeNotifierProvider.select(...))`

- [ ] `lib/presentation/screens/registration_screen.dart`
  - [ ] Vérifier usage de `themeNotifierProvider`

- [ ] `lib/presentation/screens/admin_settings_screen.dart`
  - [ ] Vérifier usage de `themeNotifierProvider`

- [ ] `lib/presentation/screens/equipment_admin_screen.dart`
  - [ ] Vérifier usage de `themeNotifierProvider`

- [ ] `lib/presentation/screens/user_directory_screen.dart`
  - [ ] Vérifier usage de `themeNotifierProvider`

- [ ] `lib/presentation/screens/credit_pack_admin_screen.dart`
  - [ ] Vérifier usage de `themeNotifierProvider`

---

## 🎯 Priorité 5 : Contraintes de layout (RelayoutBoundary)

### Fichiers à modifier

- [ ] `lib/presentation/screens/monitor_main_screen.dart`
  - [ ] Ligne 174 : Déjà `height: 90` ✅
  - [ ] Autres sections → ajouter `SizedBox` ou `ConstrainedBox`

- [ ] `lib/presentation/widgets/pupil_dashboard_tab.dart`
  - [ ] Ligne 45-55 : `_CurrentWeatherCard` → ajouter contraintes explicites

- [ ] `lib/presentation/widgets/pupil_progress_tab.dart`
  - [ ] Sections de progression → ajouter contraintes

- [ ] `lib/presentation/screens/pupil_booking_screen.dart`
  - [ ] Sections fixes → ajouter `SizedBox`

---

## ✅ Déjà Conforme (Vérification)

### Memory Management
- [x] `lib/presentation/screens/login_screen.dart` - Controllers disposés ✅
- [x] `lib/presentation/screens/booking_screen.dart` - Controllers disposés ✅
- [x] `lib/presentation/screens/registration_screen.dart` - Controllers disposés ✅
- [x] `lib/presentation/screens/admin_settings_screen.dart` - Controllers disposés ✅
- [x] `lib/presentation/providers/theme_notifier.dart` - Subscription cancellée ✅

### Mounted Checks
- [x] `lib/presentation/screens/login_screen.dart` - `if (!mounted)` checks ✅
- [x] `lib/presentation/screens/registration_screen.dart` - `if (!mounted)` checks ✅
- [x] `lib/presentation/screens/pupil_booking_screen.dart` - `if (context.mounted)` checks ✅

### Opacity Optimization
- [x] `lib/presentation/screens/admin_screen.dart` - `withOpacity()` utilisé ✅
- [x] `lib/presentation/widgets/pupil_dashboard_tab.dart` - `withOpacity()` utilisé ✅
- [x] Aucun widget `Opacity` inutile ✅

### State Management
- [x] Riverpod correctement implémenté ✅
- [x] Freezed pour immutabilité ✅
- [x] Séparation domain/data/presentation ✅
- [x] BookingValidator pour logique métier ✅

---

## 📊 Suivi de Progression

| Priorité | Total Items | Terminé | En cours | Restant | % |
|----------|-------------|---------|----------|---------|---|
| 1. const constructors | ~50 | 0 | 0 | 50 | 0% |
| 2. Keys dans listes | ~15 | 1 | 0 | 14 | 7% |
| 3. RepaintBoundary | ~10 | 0 | 0 | 10 | 0% |
| 4. Selecteurs ciblés | ~10 | 0 | 0 | 10 | 0% |
| 5. Contraintes layout | ~8 | 1 | 0 | 7 | 12% |
| **TOTAL** | **~93** | **2** | **0** | **91** | **2%** |

---

## 📝 Notes de Développement

### Avant de commencer
```bash
# S'assurer que le projet est propre
flutter clean
flutter pub get

# Lancer les tests pour avoir une baseline
flutter test

# Lancer l'analyseur
flutter analyze
```

### Après chaque modification
```bash
# Vérifier que le code compile
flutter pub run build_runner build --delete-conflicting-outputs

# Vérifier l'analyse statique
flutter analyze

# Tester l'application manuellement
flutter run
```

### Commandes utiles
```bash
# Voir les widgets qui rebuild
flutter run --profile
# Puis utiliser Flutter DevTools

# Vérifier les const constructors manquants
flutter analyze --fatal-infos

# Générer les fichiers Freezed/JSON
flutter pub run build_runner build
```

---

## 🏆 Objectifs de Qualité

| Métrique | Actuel | Cible |
|----------|--------|-------|
| Const constructors | ~30% | 95% |
| Keys dans listes | ~60% | 100% |
| RepaintBoundary | 0 | 5+ |
| Selecteurs ciblés | ~40% | 90% |
| Score global | 8.25/10 | 9.5/10 |

---

## 📅 Historique des Modifications

| Date | Fichier | Modification | Impact |
|------|---------|--------------|--------|
| - | - | - | - |

---

## 🔗 Références

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/rendering/performance)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Flutter Keys Documentation](https://docs.flutter.dev/ui/advanced/layout#keys)
