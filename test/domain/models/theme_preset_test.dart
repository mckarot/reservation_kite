import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reservation_kite/domain/models/theme_preset.dart';
import 'package:reservation_kite/domain/models/app_theme_settings.dart';

void main() {
  group('ThemePreset', () {
    test('devrait avoir 6 presets définis', () {
      // Assert
      expect(ThemePreset.all.length, 6);
    });

    test('devrait avoir le preset Kitesurf avec les bonnes couleurs', () {
      // Assert
      expect(ThemePreset.kitesurf.id, 'kitesurf');
      expect(ThemePreset.kitesurf.name, 'Kitesurf');
      expect(ThemePreset.kitesurf.icon, Icons.waves);
      expect(ThemePreset.kitesurf.primaryColor, const Color(0xFF1976D2));
      expect(ThemePreset.kitesurf.secondaryColor, const Color(0xFF42A5F5));
      expect(ThemePreset.kitesurf.accentColor, const Color(0xFF00BCD4));
    });

    test('devrait avoir le preset Sunset avec les bonnes couleurs', () {
      // Assert
      expect(ThemePreset.sunset.id, 'sunset');
      expect(ThemePreset.sunset.name, 'Sunset');
      expect(ThemePreset.sunset.icon, Icons.sunny);
      expect(ThemePreset.sunset.primaryColor, const Color(0xFFE65100));
      expect(ThemePreset.sunset.secondaryColor, const Color(0xFFFF9800));
      expect(ThemePreset.sunset.accentColor, const Color(0xFFFFEB3B));
    });

    test('devrait avoir le preset Ocean avec les bonnes couleurs', () {
      // Assert
      expect(ThemePreset.ocean.id, 'ocean');
      expect(ThemePreset.ocean.name, 'Océan');
      expect(ThemePreset.ocean.icon, Icons.pool);
      expect(ThemePreset.ocean.primaryColor, const Color(0xFF00796B));
      expect(ThemePreset.ocean.secondaryColor, const Color(0xFF26A69A));
      expect(ThemePreset.ocean.accentColor, const Color(0xFF4DD0E1));
    });

    test('devrait avoir le preset Tropical avec les bonnes couleurs', () {
      // Assert
      expect(ThemePreset.tropical.id, 'tropical');
      expect(ThemePreset.tropical.name, 'Tropical');
      expect(ThemePreset.tropical.icon, Icons.grass);
      expect(ThemePreset.tropical.primaryColor, const Color(0xFF2E7D32));
      expect(ThemePreset.tropical.secondaryColor, const Color(0xFF4CAF50));
      expect(ThemePreset.tropical.accentColor, const Color(0xFFCDDC39));
    });

    test('devrait avoir le preset Midnight avec les bonnes couleurs', () {
      // Assert
      expect(ThemePreset.midnight.id, 'midnight');
      expect(ThemePreset.midnight.name, 'Minuit');
      expect(ThemePreset.midnight.icon, Icons.nightlight);
      expect(ThemePreset.midnight.primaryColor, const Color(0xFF6A1B9A));
      expect(ThemePreset.midnight.secondaryColor, const Color(0xFF9C27B0));
      expect(ThemePreset.midnight.accentColor, const Color(0xFFE040FB));
    });

    test('devrait avoir le preset Flamingo avec les bonnes couleurs', () {
      // Assert
      expect(ThemePreset.flamingo.id, 'flamingo');
      expect(ThemePreset.flamingo.name, 'Flamant');
      expect(ThemePreset.flamingo.icon, Icons.rocket_launch);
      expect(ThemePreset.flamingo.primaryColor, const Color(0xFFC2185B));
      expect(ThemePreset.flamingo.secondaryColor, const Color(0xFFE91E63));
      expect(ThemePreset.flamingo.accentColor, const Color(0xFFFF80AB));
    });

    test('devrait convertir en AppThemeSettings', () {
      // Arrange
      final preset = ThemePreset.kitesurf;

      // Act
      final settings = preset.toThemeSettings();

      // Assert
      expect(settings.primaryColor, preset.primaryColor.value);
      expect(settings.secondaryColor, preset.secondaryColor.value);
      expect(settings.accentColor, preset.accentColor.value);
      expect(settings, isA<AppThemeSettings>());
    });

    test('devrait avoir tous les presets avec des IDs uniques', () {
      // Arrange
      final ids = ThemePreset.all.map((p) => p.id).toList();

      // Assert
      expect(ids.length, 6);
      expect(ids.toSet().length, 6); // Tous uniques
    });

    test('devrait avoir tous les presets avec des noms non vides', () {
      // Assert
      for (final preset in ThemePreset.all) {
        expect(preset.name.isNotEmpty, isTrue,
            reason: '${preset.id} ne doit pas avoir un nom vide');
      }
    });
  });
}
