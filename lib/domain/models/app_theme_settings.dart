import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_settings.freezed.dart';
part 'app_theme_settings.g.dart';

/// Modèle de configuration du thème de l'application
@freezed
class AppThemeSettings with _$AppThemeSettings {
  const factory AppThemeSettings({
    /// Mode du thème : light, dark, ou system
    @JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// Couleur principale (primaire)
    @Default(0xFF1976D2) int primaryColor,

    /// Couleur secondaire
    @Default(0xFF42A5F5) int secondaryColor,

    /// Couleur d'accent
    @Default(0xFF00BCD4) int accentColor,

    /// Couleur de fond personnalisée (optionnelle)
    int? backgroundColor,

    /// Couleur de surface personnalisée (optionnelle)
    int? surfaceColor,
  }) = _AppThemeSettings;

  /// Couleurs par défaut (thème Kitesurf - Bleu)
  static const defaultPrimary = Color(0xFF1976D2);
  static const defaultSecondary = Color(0xFF42A5F5);
  static const defaultAccent = Color(0xFF00BCD4);

  /// Factory pour créer les paramètres par défaut
  static AppThemeSettings defaults() {
    return const AppThemeSettings();
  }

  /// Factory pour créer depuis JSON
  factory AppThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$AppThemeSettingsFromJson(json);
}

/// Extension pour obtenir les couleurs depuis AppThemeSettings
extension AppThemeSettingsExt on AppThemeSettings {
  /// Couleur principale
  Color get primary => Color(primaryColor);
  
  /// Couleur secondaire
  Color get secondary => Color(secondaryColor);
  
  /// Couleur d'accent
  Color get accent => Color(accentColor);
  
  /// Couleur de fond (ou null)
  Color? get background => backgroundColor != null ? Color(backgroundColor!) : null;
  
  /// Couleur de surface (ou null)
  Color? get surface => surfaceColor != null ? Color(surfaceColor!) : null;
}
