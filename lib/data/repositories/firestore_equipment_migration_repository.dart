import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/equipment_migration_repository.dart';

/// Implémentation Firestore du repository de migration Equipment.
class FirestoreEquipmentMigrationRepository
    implements EquipmentMigrationRepository {
  final FirebaseFirestore _firestore;

  FirestoreEquipmentMigrationRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _reservationsCollection =>
      _firestore.collection('reservations');

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('equipment_categories');

  CollectionReference<Map<String, dynamic>> get _equipmentCollection =>
      _firestore.collection('equipment_items');

  @override
  Future<int> migrateReservationsAddEquipmentFlag() async {
    // Récupérer toutes les réservations qui n'ont pas le champ
    final snapshot = await _reservationsCollection
        .where('equipment_assignment_required', isNull: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    // Mettre à jour par batch (max 500 opérations par batch)
    const batchSize = 500;
    var migratedCount = 0;
    var batch = _firestore.batch();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final doc = snapshot.docs[i];
      batch.update(doc.reference, {
        'equipment_assignment_required': false,
      });
      migratedCount++;

      // Commit du batch tous les 500 documents
      if ((i + 1) % batchSize == 0) {
        await batch.commit();
        batch = _firestore.batch();
      }
    }

    // Commit final
    if (migratedCount % batchSize != 0) {
      await batch.commit();
    }

    return migratedCount;
  }

  @override
  Future<int> initEquipmentCategories() async {
    // Catégories par défaut selon la spec v2.2
    final defaultCategories = [
      {
        'id': 'kite',
        'name_fr': 'Kites',
        'name_en': 'Kites',
        'icon': 'air',
        'color_hex': 4280391411, // Bleu
        'display_order': 1,
      },
      {
        'id': 'board',
        'name_fr': 'Planches',
        'name_en': 'Boards',
        'icon': 'surfing',
        'color_hex': 4294940672, // Vert
        'display_order': 2,
      },
      {
        'id': 'foil',
        'name_fr': 'Foils',
        'name_en': 'Foils',
        'icon': 'waves',
        'color_hex': 4283215696, // Cyan
        'display_order': 3,
      },
      {
        'id': 'harness',
        'name_fr': 'Harnais',
        'name_en': 'Harnesses',
        'icon': 'shield_outlined',
        'color_hex': 4288423856, // Orange
        'display_order': 4,
      },
      {
        'id': 'wing',
        'name_fr': 'Wings',
        'name_en': 'Wings',
        'icon': 'flight',
        'color_hex': 4294198070, // Violet
        'display_order': 5,
      },
      {
        'id': 'other',
        'name_fr': 'Autres',
        'name_en': 'Other',
        'icon': 'sports',
        'color_hex': 4284513675, // Gris
        'display_order': 6,
      },
    ];

    var createdCount = 0;
    final now = DateTime.now().toIso8601String();

    for (final category in defaultCategories) {
      final docRef = _categoriesCollection.doc(category['id'] as String);
      final doc = await docRef.get();

      // Créer seulement si n'existe pas
      if (!doc.exists) {
        await docRef.set({
          'id': category['id'],
          'name_fr': category['name_fr'],
          'name_en': category['name_en'],
          'icon': category['icon'],
          'color_hex': category['color_hex'],
          'display_order': category['display_order'],
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        });
        createdCount++;
      }
    }

    return createdCount;
  }

  /// Crée 4 équipements de test pour tester les fonctionnalités equipment.
  ///
  /// Équipements créés :
  /// 1. Kite - Kite Pro 12m² (disponible)
  /// 2. Board - Planche Twin Tip 135cm (disponible)
  /// 3. Foil - Foil Carbone 90cm (en maintenance)
  /// 4. Harness - Harnais Taille M (loué)
  ///
  /// Retourne le nombre d'équipements créés.
  @override
  Future<int> createSampleEquipment() async {
    final now = DateTime.now().toIso8601String();
    var createdCount = 0;

    // Équipement 1 : Kite
    final kiteData = {
      'id': '',
      'name': 'Kite Pro 12m²',
      'category': 'kite',
      'brand': 'North',
      'model': 'Evo',
      'size': 12.0,
      'color': 'Bleu',
      'serial_number': 'KITE-001',
      'purchase_price': 1500,
      'rental_price_morning': 25,
      'rental_price_afternoon': 25,
      'rental_price_full_day': 40,
      'is_active': true,
      'current_status': 'available',
      'condition': 'good',
      'total_rentals': 0,
      'purchase_date': Timestamp.fromDate(DateTime(2025, 1, 15)),
      'last_maintenance_date': Timestamp.fromDate(DateTime(2026, 2, 1)),
      'next_maintenance_date': Timestamp.fromDate(DateTime(2026, 5, 1)),
      'notes': 'Kite polyvalent pour tous niveaux',
      'created_at': now,
      'updated_at': now,
    };
    await _equipmentCollection.add(kiteData);
    createdCount++;

    // Équipement 2 : Board
    final boardData = {
      'id': '',
      'name': 'Planche Twin Tip 135cm',
      'category': 'board',
      'brand': 'Duotone',
      'model': 'Select',
      'size': 135.0,
      'color': 'Blanc/Rouge',
      'serial_number': 'BOARD-001',
      'purchase_price': 1200,
      'rental_price_morning': 20,
      'rental_price_afternoon': 20,
      'rental_price_full_day': 35,
      'is_active': true,
      'current_status': 'available',
      'condition': 'new',
      'total_rentals': 0,
      'purchase_date': Timestamp.fromDate(DateTime(2025, 3, 1)),
      'last_maintenance_date': null,
      'next_maintenance_date': null,
      'notes': 'Planche débutant/intermédiaire',
      'created_at': now,
      'updated_at': now,
    };
    await _equipmentCollection.add(boardData);
    createdCount++;

    // Équipement 3 : Foil
    final foilData = {
      'id': '',
      'name': 'Foil Carbone 90cm',
      'category': 'foil',
      'brand': 'Armstrong',
      'model': 'HA 900',
      'size': 90.0,
      'color': 'Noir',
      'serial_number': 'FOIL-001',
      'purchase_price': 1800,
      'rental_price_morning': 30,
      'rental_price_afternoon': 30,
      'rental_price_full_day': 50,
      'is_active': true,
      'current_status': 'maintenance',
      'condition': 'poor',
      'total_rentals': 15,
      'purchase_date': Timestamp.fromDate(DateTime(2024, 6, 1)),
      'last_maintenance_date': Timestamp.fromDate(DateTime(2026, 1, 15)),
      'next_maintenance_date': Timestamp.fromDate(DateTime(2026, 3, 15)),
      'notes': 'Vérifier le mât - rayures sur le stabilisateur',
      'created_at': now,
      'updated_at': now,
    };
    await _equipmentCollection.add(foilData);
    createdCount++;

    // Équipement 4 : Harness
    final harnessData = {
      'id': '',
      'name': 'Harnais Taille M',
      'category': 'harness',
      'brand': 'Dakine',
      'model': 'Missionsit',
      'size': 0.0,
      'color': 'Gris',
      'serial_number': 'HARN-001',
      'purchase_price': 150,
      'rental_price_morning': 10,
      'rental_price_afternoon': 10,
      'rental_price_full_day': 15,
      'is_active': true,
      'current_status': 'rented',
      'condition': 'good',
      'total_rentals': 8,
      'purchase_date': Timestamp.fromDate(DateTime(2025, 2, 1)),
      'last_maintenance_date': Timestamp.fromDate(DateTime(2026, 2, 20)),
      'next_maintenance_date': Timestamp.fromDate(DateTime(2026, 6, 1)),
      'notes': 'Sangles en bon état',
      'created_at': now,
      'updated_at': now,
    };
    await _equipmentCollection.add(harnessData);
    createdCount++;

    return createdCount;
  }
}
