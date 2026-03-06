import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/equipment_rental.dart';
import '../../domain/models/reservation.dart';

/// Widget tile pour afficher une location dans une liste.
class EquipmentRentalTile extends StatelessWidget {
  const EquipmentRentalTile({
    super.key,
    required this.rental,
    this.onTap,
    this.showActions = false,
    this.onCheckOut,
    this.onCheckIn,
    this.onCancel,
  });

  final EquipmentRental rental;
  final VoidCallback? onTap;
  final bool showActions;
  final VoidCallback? onCheckOut;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : date + slot
              Row(
                children: [
                  // Icône catégorie
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(rental.equipmentCategory),
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Infos équipement
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rental.equipmentName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${rental.equipmentBrand} ${rental.equipmentModel}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge statut
                  _StatusBadge(status: rental.status),
                ],
              ),
              const SizedBox(height: 12),
              // Détails : date, slot, prix
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('EEE dd MMM yyyy', 'fr_FR')
                        .format(rental.dateTimestamp),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSlotLabel(rental.slot),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (rental.totalPrice != null &&
                      rental.assignmentType == AssignmentType.studentRental)
                    Text(
                      _formatPrice(rental.totalPrice!),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Type d'affectation
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAssignmentTypeIcon(rental.assignmentType),
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getAssignmentTypeLabel(rental.assignmentType),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions (check-out/in)
              if (showActions) ...[
                const SizedBox(height: 12),
                Divider(color: colorScheme.outlineVariant),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (rental.status == RentalStatus.confirmed &&
                        onCheckOut != null)
                      ElevatedButton.icon(
                        onPressed: onCheckOut,
                        icon: const Icon(Icons.logout),
                        label: const Text('Check-out'),
                      ),
                    if (rental.status == RentalStatus.active &&
                        onCheckIn != null)
                      ElevatedButton.icon(
                        onPressed: onCheckIn,
                        icon: const Icon(Icons.login),
                        label: const Text('Check-in'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                      ),
                    if (rental.status == RentalStatus.pending &&
                        rental.assignmentType == AssignmentType.studentRental &&
                        onCancel != null)
                      TextButton.icon(
                        onPressed: onCancel,
                        icon: const Icon(Icons.close),
                        label: const Text('Annuler'),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
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

  IconData _getAssignmentTypeIcon(AssignmentType type) {
    switch (type) {
      case AssignmentType.studentRental:
        return Icons.person_outline;
      case AssignmentType.adminAssignment:
        return Icons.admin_panel_settings_outlined;
      case AssignmentType.instructorAssignment:
        return Icons.school_outlined;
    }
  }

  String _getAssignmentTypeLabel(AssignmentType type) {
    switch (type) {
      case AssignmentType.studentRental:
        return 'Location directe';
      case AssignmentType.adminAssignment:
        return 'Assignment admin';
      case AssignmentType.instructorAssignment:
        return 'Assignment moniteur';
    }
  }

  String _formatPrice(int price) {
    if (price < 100) {
      return '$price crédits';
    }
    return '€${(price / 100).toStringAsFixed(2)}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final RentalStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final config = _getStatusConfig(status, context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        config.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: config.onColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(RentalStatus status, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (status) {
      case RentalStatus.pending:
        return _StatusConfig(
          label: 'En attente',
          color: colorScheme.secondaryContainer,
          onColor: colorScheme.onSecondaryContainer,
        );
      case RentalStatus.confirmed:
        return _StatusConfig(
          label: 'Confirmé',
          color: colorScheme.primaryContainer,
          onColor: colorScheme.onPrimaryContainer,
        );
      case RentalStatus.active:
        return _StatusConfig(
          label: 'En cours',
          color: colorScheme.tertiaryContainer,
          onColor: colorScheme.onTertiaryContainer,
        );
      case RentalStatus.completed:
        return _StatusConfig(
          label: 'Terminé',
          color: colorScheme.surfaceContainerHighest,
          onColor: colorScheme.onSurfaceVariant,
        );
      case RentalStatus.cancelled:
        return _StatusConfig(
          label: 'Annulé',
          color: colorScheme.errorContainer,
          onColor: colorScheme.onErrorContainer,
        );
    }
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.color,
    required this.onColor,
  });

  final String label;
  final Color color;
  final Color onColor;
}
