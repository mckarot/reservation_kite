/// Repository pour les migrations liées à la feature Equipment.
///
/// Ce repository contient des méthodes de migration pour :
/// - Mettre à jour les anciennes réservations avec le flag equipment_assignment_required
/// - Initialiser les catégories d'équipements par défaut
/// - Créer des locations de test pour le développement
abstract class EquipmentMigrationRepository {
  /// Migre toutes les réservations existantes pour ajouter le champ
  /// `equipment_assignment_required` (default: false).
  ///
  /// Cette migration est nécessaire pour les réservations créées avant
  /// l'ajout de la feature equipment rental.
  ///
  /// Retourne le nombre de réservations migrées.
  Future<int> migrateReservationsAddEquipmentFlag();

  /// Initialise les catégories d'équipements par défaut si elles n'existent pas.
  ///
  /// Catégories créées :
  /// - kite (Kites)
  /// - board (Planches)
  /// - foil (Foils)
  /// - harness (Harnais)
  /// - wing (Wings)
  /// - other (Autres)
  ///
  /// Retourne le nombre de catégories créées.
  Future<int> initEquipmentCategories();

  /// Crée 4 équipements de test pour tester les fonctionnalités equipment.
  ///
  /// Équipements créés :
  /// 1. Kite - Kite Pro 12m² (disponible)
  /// 2. Board - Planche Twin Tip 135cm (disponible)
  /// 3. Foil - Foil Carbone 90cm (en maintenance)
  /// 4. Harness - Harnais Taille M (loué)
  ///
  /// Retourne le nombre d'équipements créés.
  Future<int> createSampleEquipment();
}
