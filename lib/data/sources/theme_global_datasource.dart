import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/theme_config.dart';

/// DataSource Firestore pour la configuration globale du thème
/// Gère les lectures/écritures avec cache et versioning
class ThemeGlobalDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'settings';
  static const String _doc = 'theme_config';

  ThemeGlobalDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Obtenir la configuration du thème (avec version pour cache)
  Future<ThemeConfig> getConfig() async {
    try {
      final doc = await _firestore.collection(_collection).doc(_doc).get();
      
      if (doc.exists && doc.data() != null) {
        return ThemeConfig.fromFirestore(doc.data()!);
      }
      
      // Retourner les défauts si pas de config
      return ThemeConfig.defaults;
    } catch (e) {
      debugPrint('Erreur lecture thème Firestore: $e');
      return ThemeConfig.defaults;
    }
  }

  /// Stream pour écouter les changements en temps réel
  Stream<ThemeConfig> watchConfig() {
    return _firestore.collection(_collection).doc(_doc).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return ThemeConfig.fromFirestore(doc.data()!);
      }
      return ThemeConfig.defaults;
    }).handleError((e) {
      debugPrint('Erreur stream thème Firestore: $e');
      return ThemeConfig.defaults;
    });
  }

  /// Mettre à jour la configuration (admin seulement)
  Future<void> updateConfig(ThemeConfig config) async {
    try {
      await _firestore.collection(_collection).doc(_doc).set(
        config.toJson(),
        SetOptions(merge: true),
      );
      debugPrint('Thème Firestore mis à jour (version ${config.version})');
    } catch (e) {
      debugPrint('Erreur écriture thème Firestore: $e');
      rethrow;
    }
  }

  /// Mettre à jour les couleurs (admin) - Incrémente automatiquement la version
  Future<void> updateColors({
    int? primaryColor,
    int? secondaryColor,
    int? accentColor,
    String? updatedBy,
  }) async {
    try {
      // Lire la version actuelle
      final currentConfig = await getConfig();
      
      // Créer nouvelle config avec version incrémentée
      final newConfig = currentConfig.copyWith(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        accentColor: accentColor,
        version: currentConfig.version + 1,
        updatedBy: updatedBy,
        updatedAt: DateTime.now(),
      );
      
      // Sauvegarder
      await updateConfig(newConfig);
      debugPrint('Couleurs mises à jour → Version ${newConfig.version}');
    } catch (e) {
      debugPrint('Erreur mise à jour couleurs: $e');
      rethrow;
    }
  }

  /// Réinitialiser aux couleurs par défaut
  Future<void> resetToDefaults({String? updatedBy}) async {
    try {
      final newConfig = ThemeConfig.defaults.copyWith(
        updatedBy: updatedBy,
        updatedAt: DateTime.now(),
      );
      await updateConfig(newConfig);
      debugPrint('Thème réinitialisé aux défauts');
    } catch (e) {
      debugPrint('Erreur réinitialisation thème: $e');
      rethrow;
    }
  }
}
