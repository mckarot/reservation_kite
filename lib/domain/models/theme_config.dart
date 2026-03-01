import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Configuration globale du thème stockée dans Firestore
/// Définie par l'admin pour TOUS les utilisateurs
class ThemeConfig {
  final int primaryColor;
  final int secondaryColor;
  final int accentColor;
  final int version;
  final String? updatedBy;
  final DateTime? updatedAt;

  const ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.version = 1,
    this.updatedBy,
    this.updatedAt,
  });

  /// Couleurs par défaut (thème Kitesurf - Bleu)
  static const defaultPrimary = Color(0xFF1976D2);
  static const defaultSecondary = Color(0xFF42A5F5);
  static const defaultAccent = Color(0xFF00BCD4);

  /// Configuration par défaut
  static const defaults = ThemeConfig(
    primaryColor: 0xFF1976D2,
    secondaryColor: 0xFF42A5F5,
    accentColor: 0xFF00BCD4,
    version: 1,
  );

  /// Créer depuis Firestore
  factory ThemeConfig.fromFirestore(Map<String, dynamic> data) {
    return ThemeConfig(
      primaryColor: data['primaryColor'] ?? defaultPrimary.value,
      secondaryColor: data['secondaryColor'] ?? defaultSecondary.value,
      accentColor: data['accentColor'] ?? defaultAccent.value,
      version: data['version'] ?? 1,
      updatedBy: data['updatedBy'],
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  /// Créer depuis JSON
  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primaryColor: json['primaryColor'] ?? defaultPrimary.value,
      secondaryColor: json['secondaryColor'] ?? defaultSecondary.value,
      accentColor: json['accentColor'] ?? defaultAccent.value,
      version: json['version'] ?? 1,
      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  /// Convertir en JSON pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'accentColor': accentColor,
      'version': version,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Copier avec modifications
  ThemeConfig copyWith({
    int? primaryColor,
    int? secondaryColor,
    int? accentColor,
    int? version,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return ThemeConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      version: version ?? this.version,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Obtenir la couleur principale
  Color get primary => Color(primaryColor);
  
  /// Obtenir la couleur secondaire
  Color get secondary => Color(secondaryColor);
  
  /// Obtenir la couleur d'accent
  Color get accent => Color(accentColor);
}
