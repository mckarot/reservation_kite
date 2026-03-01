import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reservation_kite/domain/models/app_theme_settings.dart';

void main() {
  group('AppThemeSettings', () {
    test('devrait créer avec les valeurs par défaut', () {
      // Arrange & Act
      const settings = AppThemeSettings();

      // Assert
      expect(settings.themeMode, ThemeMode.system);
      expect(settings.primaryColor, AppThemeSettings.defaultPrimary.value);
      expect(settings.secondaryColor, AppThemeSettings.defaultSecondary.value);
      expect(settings.accentColor, AppThemeSettings.defaultAccent.value);
    });

    test('devrait créer avec des valeurs personnalisées', () {
      // Arrange
      const customSettings = AppThemeSettings(
        themeMode: ThemeMode.dark,
        primaryColor: 0xFFFF0000,
        secondaryColor: 0xFF00FF00,
        accentColor: 0xFF0000FF,
        backgroundColor: 0xFF121212,
        surfaceColor: 0xFF1E1E1E,
      );

      // Assert
      expect(customSettings.themeMode, ThemeMode.dark);
      expect(customSettings.primaryColor, 0xFFFF0000);
      expect(customSettings.secondaryColor, 0xFF00FF00);
      expect(customSettings.accentColor, 0xFF0000FF);
      expect(customSettings.backgroundColor, 0xFF121212);
      expect(customSettings.surfaceColor, 0xFF1E1E1E);
    });

    test('devrait utiliser les méthodes defaults()', () {
      // Arrange
      final defaults = AppThemeSettings.defaults();

      // Assert
      expect(defaults.themeMode, ThemeMode.system);
      expect(defaults.primary, AppThemeSettings.defaultPrimary);
      expect(defaults.secondary, AppThemeSettings.defaultSecondary);
      expect(defaults.accent, AppThemeSettings.defaultAccent);
    });

    test('devrait copier avec modification', () {
      // Arrange
      const original = AppThemeSettings(
        themeMode: ThemeMode.system,
        primaryColor: 0xFF1976D2,
        secondaryColor: 0xFF42A5F5,
        accentColor: 0xFF00BCD4,
      );

      // Act
      final modified = original.copyWith(
        themeMode: ThemeMode.dark,
        primaryColor: 0xFFFF5722,
      );

      // Assert
      expect(modified.themeMode, ThemeMode.dark);
      expect(modified.primaryColor, 0xFFFF5722);
      expect(modified.secondaryColor, original.secondaryColor); // Inchangé
      expect(modified.accentColor, original.accentColor); // Inchangé
    });

    // Test JSON skip - Freezed serialization tested elsewhere

    test('devrait utiliser l\'extension AppThemeSettingsExt', () {
      // Arrange
      const settings = AppThemeSettings(
        primaryColor: 0xFF1976D2,
        secondaryColor: 0xFF42A5F5,
        accentColor: 0xFF00BCD4,
        backgroundColor: 0xFFFFFFFF,
        surfaceColor: 0xFFF5F5F5,
      );

      // Assert - Extension
      expect(settings.primary, const Color(0xFF1976D2));
      expect(settings.secondary, const Color(0xFF42A5F5));
      expect(settings.accent, const Color(0xFF00BCD4));
      expect(settings.background, const Color(0xFFFFFFFF));
      expect(settings.surface, const Color(0xFFF5F5F5));
    });

    test('devrait retourner null pour background/surface non définis', () {
      // Arrange
      const settings = AppThemeSettings();

      // Assert
      expect(settings.background, isNull);
      expect(settings.surface, isNull);
    });
  });
}
