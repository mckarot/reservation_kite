import 'package:cloud_firestore/cloud_firestore.dart';

/// Service d'initialisation des collections Equipment.
///
/// À exécuter une fois pour initialiser les catégories de base.
class EquipmentInitializationService {
  final FirebaseFirestore _firestore;

  EquipmentInitializationService(this._firestore);

  /// Initialise les catégories d'équipements par défaut.
  ///
  /// Crée les documents dans `equipment_categories` si ils n'existent pas.
  Future<InitializationResult> initializeCategories() async {
    try {
      final categories = _getDefaultCategories();
      int createdCount = 0;
      int skippedCount = 0;

      for (final category in categories) {
        final docRef = _firestore.collection('equipment_categories').doc(category['id']);
        final docSnap = await docRef.get();

        if (!docSnap.exists) {
          await docRef.set(category);
          createdCount++;
        } else {
          skippedCount++;
        }
      }

      return InitializationResult(
        success: true,
        message: 'Initialisation terminée : $createdCount créées, $skippedCount existantes',
        createdCount: createdCount,
        skippedCount: skippedCount,
      );
    } catch (e) {
      return InitializationResult(
        success: false,
        message: 'Erreur : ${e.toString()}',
        createdCount: 0,
        skippedCount: 0,
      );
    }
  }

  /// Vérifie si les catégories sont déjà initialisées.
  Future<bool> isInitialized() async {
    final snapshot = await _firestore
        .collection('equipment_categories')
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  List<Map<String, dynamic>> _getDefaultCategories() {
    final now = FieldValue.serverTimestamp();
    return [
      {
        'id': 'kite',
        'name_fr': 'Kites',
        'name_en': 'Kites',
        'icon': 'air',
        'color_hex': 0xFF2196F3, // Bleu
        'display_order': 1,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'board',
        'name_fr': 'Planches',
        'name_en': 'Boards',
        'icon': 'surfing',
        'color_hex': 0xFFFF9800, // Orange
        'display_order': 2,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'foil',
        'name_fr': 'Foils',
        'name_en': 'Foils',
        'icon': 'waves',
        'color_hex': 0xFF4CAF50, // Vert
        'display_order': 3,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'harness',
        'name_fr': 'Harnais',
        'name_en': 'Harnesses',
        'icon': 'shield_outlined',
        'color_hex': 0xFF9C27B0, // Violet
        'display_order': 4,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'wing',
        'name_fr': 'Wings',
        'name_en': 'Wings',
        'icon': 'flight',
        'color_hex': 0xFFF44336, // Rouge
        'display_order': 5,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'other',
        'name_fr': 'Autres',
        'name_en': 'Other',
        'icon': 'sports',
        'color_hex': 0xFF607D8B, // Gris bleuté
        'display_order': 6,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
      },
    ];
  }
}

/// Résultat de l'initialisation.
class InitializationResult {
  final bool success;
  final String message;
  final int createdCount;
  final int skippedCount;

  InitializationResult({
    required this.success,
    required this.message,
    required this.createdCount,
    required this.skippedCount,
  });
}
