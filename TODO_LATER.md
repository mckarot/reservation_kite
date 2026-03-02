# 📝 TODO - Améliorations Restantes

**Date de création :** 1 mars 2026  
**Dernière mise à jour :** 1 mars 2026

---

## ✅ Déjà Corrigé

| # | Problème | Fichier | Statut |
|---|----------|---------|--------|
| 1 | BuildContext async gap | `admin_settings_screen.dart` | ✅ **CORRIGÉ** |
| 2 | Variables inutilisées | `login_screen.dart` | ✅ **CORRIGÉ** |
| 3 | Variables inutilisées | `user_detail_screen.dart` | ✅ **CORRIGÉ** |
| 4 | Méthode inutilisée | `registration_screen.dart` | ✅ **CORRIGÉ** |

---

## 🔴 PRIORITÉ 1 : Warnings JsonKey (9 warnings)

**Fichiers concernés :**
- [ ] `lib/domain/models/app_theme_settings.dart:12`
- [ ] `lib/domain/models/staff_unavailability.dart:14,19`
- [ ] `lib/domain/models/user.dart:11,14,16,17,20,21,33,69`

**Problème :** `@JsonKey` sur des classes au lieu de champs

**Solution :** C'est un problème connu avec `freezed` + `json_serializable`. Les warnings sont inoffensifs car le code généré fonctionne correctement.

**Action :** Ignorer ou mettre à jour les packages.

---

## 🟠 PRIORITÉ 2 : `withOpacity` déprécié (~80 occurrences)

**Message :** `'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss.`

**Fichiers concernés :**

### Screens (12 fichiers)
- [ ] `admin_dashboard_screen.dart` (~10 occurrences)
- [ ] `admin_screen.dart` (~3 occurrences)
- [ ] `booking_screen.dart` (~2 occurrences)
- [ ] `credit_pack_admin_screen.dart` (~2 occurrences)
- [ ] `equipment_admin_screen.dart` (~1 occurrence)
- [ ] `equipment_category_admin_screen.dart` (~2 occurrences)
- [ ] `login_screen.dart` (~6 occurrences)
- [ ] `monitor_main_screen.dart` (~4 occurrences)
- [ ] `notification_center_screen.dart` (~4 occurrences)
- [ ] `pupil_booking_screen.dart` (~8 occurrences)
- [ ] `registration_screen.dart` (~4 occurrences)
- [ ] `staff_admin_screen.dart` (~3 occurrences)
- [ ] `user_detail_screen.dart` (~2 occurrences)
- [ ] `user_directory_screen.dart` (~1 occurrence)

### Widgets (8 fichiers)
- [ ] `colored_input_decoration.dart` (~2 occurrences)
- [ ] `equipment_category_filter.dart` (~2 occurrences)
- [ ] `pupil_dashboard_tab.dart` (~7 occurrences)
- [ ] `pupil_history_tab.dart` (~4 occurrences)
- [ ] `pupil_progress_tab.dart` (~5 occurrences)
- [ ] `theme_selector.dart` (~6 occurrences - deprecated API)

### Models & Sources (5 fichiers)
- [ ] `theme_config.dart` (~6 occurrences)
- [ ] `theme_preset.dart` (~3 occurrences)
- [ ] `theme_repository.dart` (~3 occurrences)
- [ ] `theme_local_datasource.dart` (~3 occurrences)
- [ ] `theme_notifier.dart` (~3 occurrences)

### Tests (2 fichiers)
- [ ] `app_theme_settings_test.dart` (~3 occurrences)
- [ ] `theme_preset_test.dart` (~3 occurrences)

**Solution :** Remplacer `color.withOpacity(0.5)` par `color.withValues(alpha: 0.5)`

**Commande utile :**
```bash
# Trouver toutes les occurrences
grep -r "withOpacity" lib/ --include="*.dart"
```

---

## 🟡 PRIORITÉ 3 : `print()` en production (~30 occurrences)

**Message :** `Don't invoke 'print' in production code. Try using a logging framework.`

**Fichiers concernés :**

### Repositories
- [ ] `lib/data/repositories/equipment_category_repository.dart` (~6 print)
- [ ] `lib/presentation/providers/equipment_category_notifier.dart` (~12 print)

### Data Sources
- [ ] `lib/data/sources/equipment_category_firestore_datasource.dart` (~7 print)

### Screens
- [ ] `lib/presentation/screens/equipment_admin_screen.dart` (~4 print)
- [ ] `lib/presentation/screens/equipment_category_admin_screen.dart` (~2 print)

**Solution :** Remplacer par un logger (ex: `logger`, `logging`, ou `debugPrint`)

**Exemple de remplacement :**
```dart
// ❌ Avant
print('Error: $e');

// ✅ Après
import 'package:flutter/foundation.dart';
debugPrint('Error: $e');

// Ou avec un vrai logger
import 'package:logger/logger.dart';
final logger = Logger();
logger.e('Error: $e');
```

---

## 🟢 PRIORITÉ 4 : Autres infos (~40 occurrences)

### 1. `.value` déprécié sur Color
**Fichiers :**
- [ ] `theme_config.dart`
- [ ] `theme_preset.dart`
- [ ] `theme_repository.dart`
- [ ] `theme_local_datasource.dart`
- [ ] `theme_notifier.dart`
- [ ] `app_theme_settings_test.dart`
- [ ] `theme_preset_test.dart`

**Solution :** Utiliser `.r`, `.g`, `.b` ou `toARGB32()`

### 2. `directives_ordering`
**Fichiers :**
- [ ] `repository_providers.dart`
- [ ] `equipment_category_repository.dart`
- [ ] `firebase_auth_repository.dart`
- [ ] `theme_repository.dart`
- [ ] `main.dart`
- [ ] Et plusieurs providers...

**Solution :** Trier les imports (Dart, Flutter, packages, app)

### 3. `always_put_required_named_parameters_first`
**Fichiers :**
- [ ] `domain/entities/user.dart`
- [ ] `domain/models/equipment.dart`
- [ ] `domain/models/product.dart`
- [ ] `domain/models/reservation.dart`
- [ ] `domain/models/session.dart`
- [ ] `domain/models/settings.dart`
- [ ] `domain/models/staff.dart`
- [ ] `domain/models/staff_unavailability.dart`
- [ ] `domain/models/transaction.dart`
- [ ] `domain/models/user.dart`

**Solution :** Placer les paramètres requis avant les optionnels

### 4. `unawaited_futures`
- [ ] `pupil_booking_screen.dart:138`

**Solution :** Ajouter `await` ou `unawaited()`

### 5. `cascade_invocations`
- [ ] `pupil_history_tab.dart:40`

**Solution :** Utiliser `..` pour les cascades

### 6. `unnecessary_underscores`
- [ ] `lesson_validation_screen.dart:264`

**Solution :** Utiliser `_` au lieu de `___`

### 7. `deprecated_member_use` (Flutter 3.32+)
- [ ] `theme_selector.dart` - `groupValue`, `onChanged` sur Radio
- [ ] `pupil_history_tab.dart` - duplication de receiver
- [ ] `app_theme.dart` - `background` (utiliser `surface`)

---

## 📊 Statistiques

| Priorité | Type | Count | Temps estimé |
|----------|------|-------|--------------|
| 🔴 | Warnings JsonKey | 9 | 10 min (ou ignorer) |
| 🟠 | withOpacity déprécié | ~80 | 1-2 heures |
| 🟡 | print() production | ~30 | 30 min |
| 🟢 | Autres infos | ~40 | 1 heure |
| **TOTAL** | **Tous** | **~159** | **3-4 heures** |

---

## 🎯 Prochaines Étapes

1. **Ignorer les warnings JsonKey** (problème connu freezed)
2. **Corriger `withOpacity`** avec find/replace
3. **Remplacer `print()`** par `debugPrint`
4. **Trier les imports** automatiquement

---

## 🛠️ Commandes Utiles

```bash
# Analyser le projet
dart analyze

# Flutter analyze
flutter analyze

# Formater le code
dart format lib/

# Générer les fichiers freezed/json
flutter pub run build_runner build --delete-conflicting-outputs

# Voir les occurrences de withOpacity
grep -r "withOpacity" lib/ --include="*.dart" -n

# Voir les print
grep -r "print(" lib/ --include="*.dart" -n | grep -v "debugPrint"
```

---

## 📚 Ressources

- [Flutter Color.withValues()](https://api.flutter.dev/flutter/dart-ui/Color/withValues.html)
- [Logger package](https://pub.dev/packages/logger)
- [Freezed documentation](https://pub.dev/packages/freezed)
- [Dart analysis options](https://dart.dev/guides/language/analysis-options)

---

## 📅 Historique

| Date | Action | Résultat |
|------|--------|----------|
| 1 mars 2026 | Correction BuildContext async gap | ✅ 1 error → 0 |
| 1 mars 2026 | Suppression variables inutilisées | ✅ 13 warnings → 9 |
| 1 mars 2026 | Nettoyage registration_screen | ✅ Code simplifié |

---

**Score actuel :** 0 errors, 9 warnings, ~130 infos  
**Objectif :** 0 errors, 0 warnings, <50 infos
