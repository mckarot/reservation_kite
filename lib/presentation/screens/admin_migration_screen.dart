import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firestore_equipment_migration_repository.dart';

/// Écran de migration pour la feature Equipment.
///
/// Permet à l'administrateur d'exécuter les migrations nécessaires :
/// 1. Migrer les réservations avec equipment_assignment_required
/// 2. Initialiser les catégories d'équipements
class AdminMigrationScreen extends ConsumerStatefulWidget {
  const AdminMigrationScreen({super.key});

  @override
  ConsumerState<AdminMigrationScreen> createState() =>
      _AdminMigrationScreenState();
}

class _AdminMigrationScreenState extends ConsumerState<AdminMigrationScreen> {
  bool _isMigratingReservations = false;
  bool _isMigratingCategories = false;
  bool _isCreatingSamples = false;
  String? _migrationResult;
  bool _isSuccess = false;

  Future<void> _createSampleEquipment() async {
    setState(() {
      _isCreatingSamples = true;
      _migrationResult = null;
    });

    try {
      final repository = FirestoreEquipmentMigrationRepository(
          FirebaseFirestore.instance);
      final count = await repository.createSampleEquipment();

      setState(() {
        _migrationResult =
            '$count équipement(s) de test créé(s) avec succès !';
        _isSuccess = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $count équipement(s) de test créé(s)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _migrationResult = 'Erreur : ${e.toString()}';
        _isSuccess = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isCreatingSamples = false;
      });
    }
  }

  Future<void> _migrateReservations() async {
    setState(() {
      _isMigratingReservations = true;
      _migrationResult = null;
    });

    try {
      final repository = FirestoreEquipmentMigrationRepository(
          FirebaseFirestore.instance);
      final count = await repository.migrateReservationsAddEquipmentFlag();

      setState(() {
        _migrationResult =
            '$count réservation(s) migrée(s) avec succès !';
        _isSuccess = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $count réservation(s) migrée(s)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _migrationResult = 'Erreur : ${e.toString()}';
        _isSuccess = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isMigratingReservations = false;
      });
    }
  }

  Future<void> _initCategories() async {
    setState(() {
      _isMigratingCategories = true;
      _migrationResult = null;
    });

    try {
      final repository = FirestoreEquipmentMigrationRepository(
          FirebaseFirestore.instance);
      final count = await repository.initEquipmentCategories();

      setState(() {
        if (count == 0) {
          _migrationResult =
              'Les catégories existent déjà. Aucune migration nécessaire.';
        } else {
          _migrationResult = '$count catégorie(s) créée(s) avec succès !';
        }
        _isSuccess = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(count == 0
                ? 'ℹ️ Catégories déjà existantes'
                : '✅ $count catégorie(s) créée(s)'),
            backgroundColor: count == 0 ? Colors.blue : Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _migrationResult = 'Erreur : ${e.toString()}';
        _isSuccess = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isMigratingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrations Equipment'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Migrations Equipment Rental',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Exécutez les migrations nécessaires pour la feature Equipment Rental.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⚠️ Important',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ces migrations sont à exécuter une seule fois lors du déploiement de la feature.',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Migration 1 : Réservations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.folder_copy,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1. Migrer les réservations',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Ajoute le champ equipment_assignment_required',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cette migration ajoute le flag `equipment_assignment_required` (false) à toutes les réservations existantes qui ne l\'ont pas.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isMigratingReservations
                            ? null
                            : _migrateReservations,
                        icon: _isMigratingReservations
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isMigratingReservations
                            ? 'Migration en cours...'
                            : 'Exécuter la migration'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Migration 2 : Catégories
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.category,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2. Initialiser les catégories',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Crée les 6 catégories par défaut',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cette migration crée les catégories d\'équipements par défaut si elles n\'existent pas :\n'
                      '• Kites, Planches, Foils, Harnais, Wings, Autres',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _isMigratingCategories ? null : _initCategories,
                        icon: _isMigratingCategories
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isMigratingCategories
                            ? 'Initialisation en cours...'
                            : 'Initialiser les catégories'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Migration 3 : Locations de test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3. Créer locations de test',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Crée 4 locations pour tester',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cette action crée 4 équipements de test avec différents statuts :\n'
                      '• Kite Pro 12m² (available, good)\n'
                      '• Planche Twin Tip 135cm (available, new)\n'
                      '• Foil Carbone 90cm (maintenance, poor)\n'
                      '• Harnais Taille M (rented, good)',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isCreatingSamples ? null : _createSampleEquipment,
                        icon: _isCreatingSamples
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sports_kabaddi),
                        label: Text(_isCreatingSamples
                            ? 'Création en cours...'
                            : 'Créer 4 équipements de test'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Résultat
            if (_migrationResult != null) ...[
              const SizedBox(height: 24),
              Card(
                color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error,
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _migrationResult!,
                          style: TextStyle(
                            color: _isSuccess ? Colors.green.shade900 : Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Footer
            Text(
              '💡 Conseil : Après les migrations, vérifiez les données dans la console Firebase.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
