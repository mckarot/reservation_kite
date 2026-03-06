import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/equipment_item.dart';

/// Repository interface pour la gestion du parc matériel.
///
/// Toutes les opérations de lecture/écriture sur les équipements physiques.
abstract class EquipmentRepository {
  /// Expose Firestore pour les services d'initialisation.
  FirebaseFirestore get firestore;

  /// Récupère tous les équipements.
  Future<List<EquipmentItem>> getAllEquipment();

  /// Récupère un équipement par son ID.
  Future<EquipmentItem?> getEquipmentById(String id);

  /// Récupère les équipements par catégorie.
  Future<List<EquipmentItem>> getEquipmentByCategory(EquipmentCategoryType category);

  /// Stream pour observer les équipements actifs en temps réel.
  Stream<List<EquipmentItem>> watchActiveEquipment();

  /// Sauvegarde un équipement (création ou mise à jour).
  Future<void> saveEquipment(EquipmentItem equipment);

  /// Désactive un équipement (marque comme inactif).
  Future<void> deactivateEquipment(String id);

  /// Met à jour le statut physique d'un équipement.
  ///
  /// Utilisé par les transactions de check-out/check-in.
  Future<void> updateEquipmentStatus(String id, EquipmentCurrentStatus status);
}
