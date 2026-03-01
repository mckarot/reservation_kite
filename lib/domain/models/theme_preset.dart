import 'package:flutter/material.dart';
import 'app_theme_settings.dart';

/// Préréglages de thèmes pour l'application
class ThemePreset {
  final String id;
  final String name;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const ThemePreset({
    required this.id,
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  /// Thème Kitesurf (défaut) - Bleu
  static const kitesurf = ThemePreset(
    id: 'kitesurf',
    name: 'Kitesurf',
    icon: Icons.waves,
    primaryColor: Color(0xFF1976D2),
    secondaryColor: Color(0xFF42A5F5),
    accentColor: Color(0xFF00BCD4),
  );

  /// Thème Sunset - Orange
  static const sunset = ThemePreset(
    id: 'sunset',
    name: 'Sunset',
    icon: Icons.sunny,
    primaryColor: Color(0xFFE65100),
    secondaryColor: Color(0xFFFF9800),
    accentColor: Color(0xFFFFEB3B),
  );

  /// Thème Ocean - Teal
  static const ocean = ThemePreset(
    id: 'ocean',
    name: 'Océan',
    icon: Icons.pool,
    primaryColor: Color(0xFF00796B),
    secondaryColor: Color(0xFF26A69A),
    accentColor: Color(0xFF4DD0E1),
  );

  /// Thème Tropical - Vert
  static const tropical = ThemePreset(
    id: 'tropical',
    name: 'Tropical',
    icon: Icons.grass,
    primaryColor: Color(0xFF2E7D32),
    secondaryColor: Color(0xFF4CAF50),
    accentColor: Color(0xFFCDDC39),
  );

  /// Thème Midnight - Violet
  static const midnight = ThemePreset(
    id: 'midnight',
    name: 'Minuit',
    icon: Icons.nightlight,
    primaryColor: Color(0xFF6A1B9A),
    secondaryColor: Color(0xFF9C27B0),
    accentColor: Color(0xFFE040FB),
  );

  /// Thème Flamingo - Rose
  static const flamingo = ThemePreset(
    id: 'flamingo',
    name: 'Flamant',
    icon: Icons.rocket_launch,
    primaryColor: Color(0xFFC2185B),
    secondaryColor: Color(0xFFE91E63),
    accentColor: Color(0xFFFF80AB),
  );

  /// Tous les préréglages disponibles
  static const List<ThemePreset> all = [
    kitesurf,
    sunset,
    ocean,
    tropical,
    midnight,
    flamingo,
  ];

  /// Créer un AppThemeSettings depuis ce preset
  AppThemeSettings toThemeSettings() {
    return AppThemeSettings(
      primaryColor: primaryColor.value,
      secondaryColor: secondaryColor.value,
      accentColor: accentColor.value,
    );
  }
}
