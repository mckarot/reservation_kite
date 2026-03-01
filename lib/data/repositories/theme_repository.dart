import 'package:flutter/material.dart';
import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/theme_preset.dart';
import '../../domain/models/theme_config.dart';
import '../sources/theme_local_datasource.dart';
import '../sources/theme_global_datasource.dart';

/// Repository pour la gestion des paramètres de thème
/// Combine thème global (Firestore) et local (SharedPreferences)
class ThemeRepository {
  final ThemeLocalDataSource _localDataSource;
  final ThemeGlobalDataSource _globalDataSource;

  ThemeRepository(this._localDataSource, this._globalDataSource);

  /// Obtenir les paramètres de thème COMPLETS
  /// Combine couleurs globales (Firestore) + mode local (SharedPreferences)
  Future<AppThemeSettings> getThemeSettings() async {
    try {
      // 1. Lire configuration globale (couleurs de la marque)
      final globalConfig = await _globalDataSource.getConfig();
      
      // 2. Lire préférences locales (mode)
      final localSettings = await _localDataSource.getSettings();
      final localMode = localSettings?.themeMode ?? ThemeMode.system;

      // 3. Combiner les deux
      return AppThemeSettings(
        themeMode: localMode, // Local
        primaryColor: globalConfig.primaryColor, // Global
        secondaryColor: globalConfig.secondaryColor, // Global
        accentColor: globalConfig.accentColor, // Global
      );
    } catch (e) {
      debugPrint('Erreur lecture thème: $e');
      return AppThemeSettings.defaults();
    }
  }

  /// Stream pour écouter les changements de thème global
  Stream<AppThemeSettings> watchThemeSettings() {
    return _globalDataSource.watchConfig().map((globalConfig) {
      // Combiner avec mode local (à améliorer avec une lecture séparée)
      return AppThemeSettings(
        themeMode: ThemeMode.system, // Sera mis à jour séparément
        primaryColor: globalConfig.primaryColor,
        secondaryColor: globalConfig.secondaryColor,
        accentColor: globalConfig.accentColor,
      );
    });
  }

  /// Mettre à jour le mode (LOCAL uniquement)
  Future<void> updateThemeMode(ThemeMode mode) async {
    await _localDataSource.saveSettings(
      AppThemeSettings.defaults().copyWith(themeMode: mode),
    );
  }

  /// Mettre à jour les couleurs (GLOBAL - Firestore, admin seulement)
  Future<void> updateColors({
    int? primaryColor,
    int? secondaryColor,
    int? accentColor,
    String? updatedBy,
  }) async {
    await _globalDataSource.updateColors(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      accentColor: accentColor,
      updatedBy: updatedBy,
    );
  }

  /// Réinitialiser les couleurs aux défauts (GLOBAL - Firestore)
  Future<void> resetColorsToDefaults({String? updatedBy}) async {
    await _globalDataSource.resetToDefaults(updatedBy: updatedBy);
  }

  /// Appliquer un preset (GLOBAL - Firestore, admin seulement)
  Future<void> applyPreset(ThemePreset preset, {String? updatedBy}) async {
    await _globalDataSource.updateColors(
      primaryColor: preset.primaryColor.value,
      secondaryColor: preset.secondaryColor.value,
      accentColor: preset.accentColor.value,
      updatedBy: updatedBy,
    );
  }
}
