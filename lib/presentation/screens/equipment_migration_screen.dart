import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/migrate_equipment_data.dart';

/// Écran d'administration pour exécuter la migration des équipements.
///
/// À utiliser UNE SEULE FOIS pour migrer les données de l'ancien format
/// (quantité globale) vers le nouveau format (équipements individuels).
class EquipmentMigrationScreen extends ConsumerStatefulWidget {
  const EquipmentMigrationScreen({super.key});

  @override
  ConsumerState<EquipmentMigrationScreen> createState() =>
      _EquipmentMigrationScreenState();
}

class _EquipmentMigrationScreenState
    extends ConsumerState<EquipmentMigrationScreen> {
  MigrationEstimate? _estimate;
  bool _isEstimating = false;
  bool _isMigrating = false;
  MigrationResult? _result;
  bool _confirmMigration = false;

  @override
  void initState() {
    super.initState();
    _loadEstimate();
  }

  Future<void> _loadEstimate() async {
    setState(() => _isEstimating = true);
    try {
      final estimate = await estimateMigration();
      setState(() => _estimate = estimate);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isEstimating = false);
    }
  }

  Future<void> _runMigration() async {
    if (!_confirmMigration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Veuillez cocher la case de confirmation'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isMigrating = true);
    try {
      final result = await migrateEquipmentData();
      setState(() => _result = result);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.hasErrors
                  ? '⚠️ Migration terminée avec ${result.errors} erreurs'
                  : '✅ Migration réussie !',
            ),
            backgroundColor: result.hasErrors
                ? Colors.orange
                : Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isMigrating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Migration des équipements'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWarningCard(),
            const SizedBox(height: 16),
            _buildEstimateCard(),
            if (_estimate != null && _estimate!.toMigrate > 0) ...[
              const SizedBox(height: 16),
              _buildConfirmationCard(),
              const SizedBox(height: 16),
              _buildMigrateButton(),
            ],
            if (_result != null) ...[
              const SizedBox(height: 16),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  '⚠️ ATTENTION - Opération critique',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Cette migration est IRRÉVERSIBLE sans backup. Avant de continuer :\n\n'
              '1. ✅ Faire un backup Firestore :\n'
              '   firebase firestore:export gs://reservation_kite/backups/equipment_backup_YYYYMMDD_HHMMSS\n\n'
              '2. ✅ Tester sur l\'émulateur local d\'abord\n\n'
              '3. ✅ Vérifier qu\'il y a des documents à migrer',
              style: TextStyle(color: Colors.orange.shade900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 8),
                Text(
                  'État actuel des données',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isEstimating)
              const Center(child: CircularProgressIndicator())
            else if (_estimate == null)
              Text(
                'Aucune estimation disponible. Cliquez sur "Actualiser".',
                style: TextStyle(color: Colors.grey.shade600),
              )
            else ...[
              _buildStatRow(
                'Groupes d\'équipements (ancien format)',
                '${_estimate!.toMigrate}',
                Icons.folder,
              ),
              const Divider(),
              _buildStatRow(
                'Déjà migrés (nouveau format)',
                '${_estimate!.alreadyMigrated}',
                Icons.check_circle,
                color: Colors.green,
              ),
              const Divider(),
              _buildStatRow(
                'Équipements individuels à créer',
                '${_estimate!.totalIndividualItems}',
                Icons.inventory_2,
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isEstimating ? null : _loadEstimate,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  'Confirmation requise',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _confirmMigration,
              onChanged: (value) => setState(() => _confirmMigration = value ?? false),
              title: const Text(
                'J\'ai fait un backup Firestore et je comprends que cette opération est irréversible sans backup.',
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMigrateButton() {
    return ElevatedButton(
      onPressed: _isMigrating ? null : _runMigration,
      style: ElevatedButton.styleFrom(
        backgroundColor: _confirmMigration ? Colors.green : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isMigrating
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Migration en cours...'),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 8),
                Text(
                  'LANCER LA MIGRATION',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  Widget _buildResultCard() {
    if (_result == null) return const SizedBox.shrink();

    final hasErrors = _result!.hasErrors;

    return Card(
      color: hasErrors ? Colors.orange.shade50 : Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasErrors ? Icons.warning : Icons.check_circle,
                  color: hasErrors ? Colors.orange.shade700 : Colors.green.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  hasErrors ? 'Migration terminée avec erreurs' : 'Migration réussie !',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: hasErrors ? Colors.orange.shade900 : Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildResultRow('Groupes migrés', '${_result!.migratedGroups}', Colors.blue),
            _buildResultRow('Déjà migrés/skip', '${_result!.skipped}', Colors.grey),
            _buildResultRow(
              'Erreurs',
              '${_result!.errors}',
              hasErrors ? Colors.red : Colors.green,
            ),
            if (hasErrors && _result!.errorMessages.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Détail des erreurs :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ..._result!.errorMessages.map(
                (error) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• $error', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
