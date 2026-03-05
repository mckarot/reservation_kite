import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';

/// Écran pour corriger les données equipment obsolètes
class FixEquipmentDataScreen extends ConsumerStatefulWidget {
  const FixEquipmentDataScreen({super.key});

  @override
  ConsumerState<FixEquipmentDataScreen> createState() =>
      _FixEquipmentDataScreenState();
}

class _FixEquipmentDataScreenState
    extends ConsumerState<FixEquipmentDataScreen> {
  bool _isFixing = false;
  String? _result;
  int _totalFound = 0;
  int _fixedCount = 0;
  int _errorCount = 0;

  Future<void> _fixEquipmentData() async {
    setState(() {
      _isFixing = true;
      _result = null;
      _fixedCount = 0;
      _errorCount = 0;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('equipment').get();

      setState(() {
        _totalFound = snapshot.docs.length;
      });

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          final updates = <String, dynamic>{};

          // Correction #1: status "active" → "available"
          if (data['status'] == 'active') {
            updates['status'] = 'available';
          }

          // Correction #2: size double → String
          if (data['size'] is double || data['size'] is int) {
            final sizeValue = data['size'];
            updates['size'] = sizeValue.toString().replaceAll('.0', '');
          }

          // Appliquer les corrections
          if (updates.isNotEmpty) {
            await doc.reference.update(updates);
            setState(() {
              _fixedCount++;
            });
          }
        } catch (e) {
          setState(() {
            _errorCount++;
          });
        }
      }

      setState(() {
        _isFixing = false;
        _result =
            '✅ Correction terminée !\n'
            '• Total: $_totalFound équipements\n'
            '• Corrigés: $_fixedCount\n'
            '• Erreurs: $_errorCount';
      });
    } catch (e) {
      setState(() {
        _isFixing = false;
        _result = '❌ Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Corriger Equipment'),
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
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Problèmes détectés',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ce script va corriger :\n'
                      '• status: "active" → "available"\n'
                      '• size: 0.0 (double) → "12" (String)',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton de correction
            ElevatedButton.icon(
              onPressed: _isFixing ? null : _fixEquipmentData,
              icon: _isFixing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.build),
              label: Text(
                _isFixing ? 'Correction en cours...' : 'Corriger les données',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Progression
            if (_isFixing || _result != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barre de progression
                      if (_isFixing) ...[
                        LinearProgressIndicator(
                          value: _totalFound > 0
                              ? _fixedCount / _totalFound
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
                            value: '$_totalFound',
                            color: primaryColor,
                          ),
                          _StatItem(
                            icon: Icons.check_circle,
                            label: 'Corrigés',
                            value: '$_fixedCount',
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

                      if (_result != null) ...[
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
                            _result!,
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
