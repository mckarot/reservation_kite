import 'package:flutter/material.dart';
import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/theme_preset.dart';
import '../sources/theme_local_datasource.dart';

/// Repository pour la gestion des paramètres de thème
class ThemeRepository {
  final ThemeLocalDataSource _localDataSource;

  ThemeRepository(this._localDataSource);

  /// Obtenir les paramètres de thème actuels
  Future<AppThemeSettings> getThemeSettings() async {
    final settings = await _localDataSource.getSettings();
    return settings ?? AppThemeSettings.defaults();
  }

  /// Mettre à jour les paramètres de thème
  Future<void> updateThemeSettings(AppThemeSettings settings) async {
    await _localDataSource.saveSettings(settings);
  }

  /// Appliquer un préréglage de thème
  Future<void> applyPreset(ThemePreset preset) async {
    final currentSettings = await getThemeSettings();
    final newSettings = currentSettings.copyWith(
      primaryColor: preset.primaryColor.value,
      secondaryColor: preset.secondaryColor.value,
      accentColor: preset.accentColor.value,
    );
    await _localDataSource.saveSettings(newSettings);
  }

  /// Réinitialiser aux paramètres par défaut
  Future<void> resetToDefaults() async {
    await _localDataSource.clearSettings();
  }

  /// Définir le mode du thème
  Future<void> setThemeMode(ThemeMode mode) async {
    final currentSettings = await getThemeSettings();
    final newSettings = currentSettings.copyWith(themeMode: mode);
    await _localDataSource.saveSettings(newSettings);
  }

  /// Définir la couleur principale
  Future<void> setPrimaryColor(Color color) async {
    final currentSettings = await getThemeSettings();
    final newSettings = currentSettings.copyWith(primaryColor: color.value);
    await _localDataSource.saveSettings(newSettings);
  }

  /// Définir la couleur secondaire
  Future<void> setSecondaryColor(Color color) async {
    final currentSettings = await getThemeSettings();
    final newSettings = currentSettings.copyWith(secondaryColor: color.value);
    await _localDataSource.saveSettings(newSettings);
  }

  /// Définir la couleur d'accent
  Future<void> setAccentColor(Color color) async {
    final currentSettings = await getThemeSettings();
    final newSettings = currentSettings.copyWith(accentColor: color.value);
    await _localDataSource.saveSettings(newSettings);
  }
}
