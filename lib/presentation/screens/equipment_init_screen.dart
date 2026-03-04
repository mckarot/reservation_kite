import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/theme_notifier.dart';
import '../../domain/models/app_theme_settings.dart';

/// Écran d'initialisation des données Firebase pour la location de matériel.
///
/// Permet de :
/// 1. Migrer les équipements existants vers le nouveau schéma (v2)
/// 2. Initialiser les quantités totales
/// 3. Convertir les status et tailles
class EquipmentInitScreen extends ConsumerStatefulWidget {
  const EquipmentInitScreen({super.key});

  @override
  ConsumerState<EquipmentInitScreen> createState() =>
      _EquipmentInitScreenState();
}

class _EquipmentInitScreenState extends ConsumerState<EquipmentInitScreen> {
  bool _isMigrating = false;
  String? _migrationResult;
  int _totalEquipment = 0;
  int _migratedCount = 0;
  int _errorCount = 0;

  Future<void> _migrateEquipment() async {
    setState(() {
      _isMigrating = true;
      _migrationResult = null;
      _migratedCount = 0;
      _errorCount = 0;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Récupérer tous les équipements
      final equipmentSnapshot = await firestore.collection('equipment').get();
      setState(() {
        _totalEquipment = equipmentSnapshot.docs.length;
      });

      var updated = 0;
      var alreadyMigrated = 0;

      for (final doc in equipmentSnapshot.docs) {
        try {
          final data = doc.data();
          final updates = <String, dynamic>{};

          // 1. Migration de total_quantity
          if (!data.containsKey('total_quantity')) {
            updates['total_quantity'] = 1;
          } else {
            alreadyMigrated++;
            continue; // Déjà migré
          }

          // 2. Migration du status
          if (data.containsKey('status')) {
            final oldStatus = data['status'] as String;
            if (oldStatus == 'available') {
              updates['status'] = 'active';
            } else if (oldStatus == 'damaged') {
              updates['status'] = 'retired';
            }
          }

          // 3. Conversion de size String → double
          if (data.containsKey('size')) {
            final sizeValue = data['size'];
            if (sizeValue is String) {
              final doubleSize = double.tryParse(sizeValue) ?? 0.0;
              updates['size'] = doubleSize;
            }
          }

          // 4. Ajout de updated_at
          updates['updated_at'] = FieldValue.serverTimestamp();

          if (updates.isNotEmpty) {
            await doc.reference.update(updates);
            updated++;
          }

          setState(() {
            _migratedCount = updated + alreadyMigrated;
          });
        } catch (e) {
          setState(() {
            _errorCount++;
          });
        }
      }

      setState(() {
        _isMigrating = false;
        _migrationResult =
            '✅ Migration terminée !\n'
            '• Total: $_totalEquipment équipements\n'
            '• Migrés: $updated\n'
            '• Déjà à jour: $alreadyMigrated\n'
            '• Erreurs: $_errorCount';
      });
    } catch (e) {
      setState(() {
        _isMigrating = false;
        _migrationResult = '❌ Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialisation Matériel'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte d'information
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Migration vers v2',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ce script va :\n'
                      '• Ajouter total_quantity: 1 par défaut\n'
                      '• Convertir status: available → active\n'
                      '• Convertir status: damaged → retired\n'
                      '• Convertir size: String → double',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton de migration
            ElevatedButton.icon(
              onPressed: _isMigrating ? null : _migrateEquipment,
              icon: _isMigrating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(
                _isMigrating ? 'Migration en cours...' : 'Lancer la migration',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Progression
            if (_isMigrating || _migrationResult != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barre de progression
                      if (_isMigrating) ...[
                        LinearProgressIndicator(
                          value: _totalEquipment > 0
                              ? _migratedCount / _totalEquipment
                              : 0,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Statistiques
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.inventory_2,
                            label: 'Total',
                            value: '$_totalEquipment',
                            color: primaryColor,
                          ),
                          _StatItem(
                            icon: Icons.check_circle,
                            label: 'Migrés',
                            value: '$_migratedCount',
                            color: Colors.green,
                          ),
                          _StatItem(
                            icon: Icons.error_outline,
                            label: 'Erreurs',
                            value: '$_errorCount',
                            color: Colors.red,
                          ),
                        ],
                      ),

                      if (_migrationResult != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _errorCount > 0
                                ? Colors.orange.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _errorCount > 0
                                  ? Colors.orange.shade200
                                  : Colors.green.shade200,
                            ),
                          ),
                          child: Text(
                            _migrationResult!,
                            style: TextStyle(
                              color: _errorCount > 0
                                  ? Colors.orange.shade700
                                  : Colors.green.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Avertissement
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'À exécuter une seule fois après le déploiement. Sauvegardez vos données avant.',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
