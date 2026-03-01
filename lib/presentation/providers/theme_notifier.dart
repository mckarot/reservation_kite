import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/theme_preset.dart';
import '../../data/repositories/theme_repository.dart';
import '../../data/sources/theme_local_datasource.dart';

/// Provider pour la DataSource locale
final themeLocalDataSourceProvider = Provider<ThemeLocalDataSource>((ref) {
  return ThemeLocalDataSource();
});

/// Provider pour le Repository
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final dataSource = ref.watch(themeLocalDataSourceProvider);
  return ThemeRepository(dataSource);
});

/// Provider pour le Notifier (StateNotifier)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AsyncValue<AppThemeSettings>>((ref) {
  final repository = ref.watch(themeRepositoryProvider);
  return ThemeNotifier(repository);
});

/// StateNotifier pour la gestion du thème
class ThemeNotifier extends StateNotifier<AsyncValue<AppThemeSettings>> {
  final ThemeRepository _repository;

  ThemeNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  /// Initialiser le thème
  Future<void> _init() async {
    try {
      final settings = await _repository.getThemeSettings();
      state = AsyncValue.data(settings);
    } catch (e) {
      debugPrint('Erreur lors du chargement du thème: $e');
      state = AsyncValue.data(AppThemeSettings.defaults());
    }
  }

  /// Définir le mode du thème (light, dark, system)
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final current = state.value;
      if (current == null) return;

      final newSettings = current.copyWith(themeMode: mode);
      state = AsyncValue.data(newSettings);
      await _repository.setThemeMode(mode);
    } catch (e) {
      debugPrint('Erreur lors de la définition du mode du thème: $e');
    }
  }

  /// Définir la couleur principale
  Future<void> setPrimaryColor(Color color) async {
    try {
      final current = state.value;
      if (current == null) return;

      final newSettings = current.copyWith(primaryColor: color.value);
      state = AsyncValue.data(newSettings);
      await _repository.setPrimaryColor(color);
    } catch (e) {
      debugPrint('Erreur lors de la définition de la couleur principale: $e');
    }
  }

  /// Définir la couleur secondaire
  Future<void> setSecondaryColor(Color color) async {
    try {
      final current = state.value;
      if (current == null) return;

      final newSettings = current.copyWith(secondaryColor: color.value);
      state = AsyncValue.data(newSettings);
      await _repository.setSecondaryColor(color);
    } catch (e) {
      debugPrint('Erreur lors de la définition de la couleur secondaire: $e');
    }
  }

  /// Définir la couleur d'accent
  Future<void> setAccentColor(Color color) async {
    try {
      final current = state.value;
      if (current == null) return;

      final newSettings = current.copyWith(accentColor: color.value);
      state = AsyncValue.data(newSettings);
      await _repository.setAccentColor(color);
    } catch (e) {
      debugPrint('Erreur lors de la définition de la couleur d\'accent: $e');
    }
  }

  /// Appliquer un préréglage de thème
  Future<void> applyPreset(ThemePreset preset) async {
    try {
      final current = state.value;
      if (current == null) return;

      final newSettings = current.copyWith(
        primaryColor: preset.primaryColor.value,
        secondaryColor: preset.secondaryColor.value,
        accentColor: preset.accentColor.value,
      );
      state = AsyncValue.data(newSettings);
      await _repository.applyPreset(preset);
    } catch (e) {
      debugPrint('Erreur lors de l\'application du préréglage: $e');
    }
  }

  /// Réinitialiser aux paramètres par défaut
  Future<void> resetToDefaults() async {
    try {
      await _repository.resetToDefaults();
      final defaults = AppThemeSettings.defaults();
      state = AsyncValue.data(defaults);
    } catch (e) {
      debugPrint('Erreur lors de la réinitialisation: $e');
      state = AsyncValue.data(AppThemeSettings.defaults());
    }
  }

  /// Recharger les paramètres depuis le storage
  Future<void> reload() async {
    state = const AsyncValue.loading();
    await _init();
  }
}
