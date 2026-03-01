import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/app_theme_settings.dart';

/// DataSource locale pour les paramètres de thème
/// Utilise SharedPreferences pour la persistance
class ThemeLocalDataSource {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyPrimaryColor = 'primary_color';
  static const String _keySecondaryColor = 'secondary_color';
  static const String _keyAccentColor = 'accent_color';
  static const String _keyBackgroundColor = 'background_color';
  static const String _keySurfaceColor = 'surface_color';

  /// Charger les paramètres de thème depuis SharedPreferences
  Future<AppThemeSettings?> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Si aucune préférence n'existe, retourner null (utilisa les défauts)
      if (!prefs.containsKey(_keyThemeMode)) {
        return null;
      }

      final themeModeInt = prefs.getInt(_keyThemeMode) ?? ThemeMode.system.index;
      final themeMode = ThemeMode.values.isNotEmpty 
          ? ThemeMode.values[themeModeInt.clamp(0, ThemeMode.values.length - 1)]
          : ThemeMode.system;

      return AppThemeSettings(
        themeMode: themeMode,
        primaryColor: prefs.getInt(_keyPrimaryColor) ?? AppThemeSettings.defaultPrimary.value,
        secondaryColor: prefs.getInt(_keySecondaryColor) ?? AppThemeSettings.defaultSecondary.value,
        accentColor: prefs.getInt(_keyAccentColor) ?? AppThemeSettings.defaultAccent.value,
        backgroundColor: prefs.getInt(_keyBackgroundColor),
        surfaceColor: prefs.getInt(_keySurfaceColor),
      );
    } catch (e) {
      debugPrint('Erreur lors du chargement des paramètres de thème: $e');
      return null;
    }
  }

  /// Sauvegarder les paramètres de thème dans SharedPreferences
  Future<void> saveSettings(AppThemeSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setInt(_keyThemeMode, settings.themeMode.index);
      await prefs.setInt(_keyPrimaryColor, settings.primaryColor);
      await prefs.setInt(_keySecondaryColor, settings.secondaryColor);
      await prefs.setInt(_keyAccentColor, settings.accentColor);
      
      if (settings.backgroundColor != null) {
        await prefs.setInt(_keyBackgroundColor, settings.backgroundColor!);
      } else {
        await prefs.remove(_keyBackgroundColor);
      }
      
      if (settings.surfaceColor != null) {
        await prefs.setInt(_keySurfaceColor, settings.surfaceColor!);
      } else {
        await prefs.remove(_keySurfaceColor);
      }
      
      debugPrint('Paramètres de thème sauvegardés');
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des paramètres de thème: $e');
      rethrow;
    }
  }

  /// Effacer les paramètres de thème
  Future<void> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_keyThemeMode);
      await prefs.remove(_keyPrimaryColor);
      await prefs.remove(_keySecondaryColor);
      await prefs.remove(_keyAccentColor);
      await prefs.remove(_keyBackgroundColor);
      await prefs.remove(_keySurfaceColor);
      
      debugPrint('Paramètres de thème effacés');
    } catch (e) {
      debugPrint('Erreur lors de l\'effacement des paramètres de thème: $e');
      rethrow;
    }
  }
}
