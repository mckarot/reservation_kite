import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/equipment_rental.dart';
import '../../domain/models/reservation.dart';
import '../providers/equipment_rental_notifier.dart';

/// Écran de check-out/check-in pour le suivi du matériel.
///
/// Permet aux moniteurs de :
/// - Faire le check-out (sortie du matériel)
/// - Faire le check-in (retour du matériel)
/// - Signaler d'éventuels dégâts
class EquipmentCheckoutScreen extends ConsumerStatefulWidget {
  final EquipmentRental rental;

  const EquipmentCheckoutScreen({super.key, required this.rental});

  @override
  ConsumerState<EquipmentCheckoutScreen> createState() =>
      _EquipmentCheckoutScreenState();
}

class _EquipmentCheckoutScreenState
    extends ConsumerState<EquipmentCheckoutScreen> {
  String? _selectedCondition;
  final _damageNotesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _selectedCondition = null;
  }

  @override
  void dispose() {
    _damageNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCheckOut = widget.rental.status == RentalStatus.confirmed;
    final isCheckIn = widget.rental.status == RentalStatus.active;

    return Scaffold(
      appBar: AppBar(
        title: Text(isCheckOut ? 'Check-out matériel' : 'Check-in matériel'),
        backgroundColor: isCheckOut
            ? colorScheme.primary
            : colorScheme.tertiary,
        foregroundColor: isCheckOut
            ? colorScheme.onPrimary
            : colorScheme.onTertiary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Résumé de la location
            _buildRentalSummary(colorScheme),
            const SizedBox(height: 24),

            // Section condition du matériel
            _buildConditionSection(theme, colorScheme, isCheckOut),
            const SizedBox(height: 24),

            // Section notes de dégâts (seulement pour check-in)
            if (!isCheckOut) ...[
              _buildDamageNotesSection(theme, colorScheme),
              const SizedBox(height: 24),
            ],

            // Bouton d'action
            _buildActionButton(theme, colorScheme, isCheckOut || isCheckIn),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalSummary(ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Card(
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(widget.rental.equipmentCategory),
                    color: colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rental.equipmentName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.rental.equipmentBrand} ${widget.rental.equipmentModel}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.person,
              label: 'Élève',
              value: widget.rental.studentName,
            ),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat(
                'EEEE dd MMMM yyyy',
                'fr_FR',
              ).format(widget.rental.dateTimestamp),
            ),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Créneau',
              value: _getSlotLabel(widget.rental.slot),
            ),
            _buildInfoRow(
              icon: Icons.info_outline,
              label: 'Statut',
              value: _getStatusLabel(widget.rental.status),
              valueColor: _getStatusColor(widget.rental.status, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSection(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isCheckOut,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCheckOut ? Icons.logout : Icons.login,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isCheckOut ? 'État avant sortie' : 'État au retour',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isCheckOut
                  ? 'Vérifiez l\'état du matériel avant de le remettre à l\'élève.'
                  : 'Vérifiez l\'état du matériel lors de la restitution.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildConditionChip('Neuf', theme, colorScheme),
                _buildConditionChip('Bon état', theme, colorScheme),
                _buildConditionChip('État moyen', theme, colorScheme),
                _buildConditionChip('Usé', theme, colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionChip(
    String condition,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedCondition == condition;

    return FilterChip(
      label: Text(condition),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedCondition = condition.toLowerCase();
          });
        }
      },
      checkmarkColor: colorScheme.onPrimary,
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildDamageNotesSection(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                const SizedBox(width: 8),
                Text(
                  'Dégâts constatés',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _damageNotesController,
              decoration: const InputDecoration(
                hintText: 'Décrivez les éventuels dégâts...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    ColorScheme colorScheme,
    bool canProcess,
  ) {
    final isCheckOut = widget.rental.status == RentalStatus.confirmed;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canProcess && _selectedCondition != null && !_isProcessing
            ? () => _processCheckout(isCheckOut)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCheckOut
              ? colorScheme.primary
              : colorScheme.tertiary,
          foregroundColor: isCheckOut
              ? colorScheme.onPrimary
              : colorScheme.onTertiary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                isCheckOut ? 'Valider le check-out' : 'Valider le check-in',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _processCheckout(bool isCheckOut) async {
    final theme = Theme.of(context);

    setState(() {
      _isProcessing = true;
    });

    try {
      final rentalNotifier = ref.read(equipmentRentalNotifierProvider.notifier);

      if (isCheckOut) {
        await rentalNotifier.checkOut(
          rentalId: widget.rental.id,
          condition: _selectedCondition!,
        );
      } else {
        await rentalNotifier.checkIn(
          rentalId: widget.rental.id,
          condition: _selectedCondition!,
          damageNotes: _damageNotesController.text.isEmpty
              ? null
              : _damageNotesController.text,
        );
      }

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCheckOut ? 'Check-out effectué' : 'Check-in effectué',
          ),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'kite':
        return Icons.air;
      case 'board':
        return Icons.surfing;
      case 'foil':
        return Icons.waves;
      case 'harness':
        return Icons.shield_outlined;
      case 'wing':
        return Icons.flight;
      default:
        return Icons.sports;
    }
  }

  String _getSlotLabel(TimeSlot slot) {
    switch (slot) {
      case TimeSlot.morning:
        return 'Matin (08h-12h)';
      case TimeSlot.afternoon:
        return 'Après-midi (13h-18h)';
      case TimeSlot.fullDay:
        return 'Journée (08h-18h)';
    }
  }

  String _getStatusLabel(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return 'En attente';
      case RentalStatus.confirmed:
        return 'Confirmé';
      case RentalStatus.active:
        return 'En cours (sorti)';
      case RentalStatus.completed:
        return 'Terminé';
      case RentalStatus.cancelled:
        return 'Annulé';
    }
  }

  Color _getStatusColor(RentalStatus status, ColorScheme colorScheme) {
    switch (status) {
      case RentalStatus.pending:
        return colorScheme.secondary;
      case RentalStatus.confirmed:
        return colorScheme.primary;
      case RentalStatus.active:
        return colorScheme.tertiary;
      case RentalStatus.completed:
        return colorScheme.onSurfaceVariant;
      case RentalStatus.cancelled:
        return colorScheme.error;
    }
  }
}
