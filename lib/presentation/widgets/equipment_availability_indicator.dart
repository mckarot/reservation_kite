import 'package:flutter/material.dart';

import '../../domain/models/equipment_item.dart';

/// Widget indicateur de disponibilité pour un équipement.
class EquipmentAvailabilityIndicator extends StatelessWidget {
  const EquipmentAvailabilityIndicator({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  final EquipmentCurrentStatus status;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final config = _getStatusConfig(status, colorScheme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: config.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: config.borderColor,
              width: 2,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            config.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: config.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  _StatusConfig _getStatusConfig(
      EquipmentCurrentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return _StatusConfig(
          label: 'Disponible',
          color: colorScheme.primary,
          borderColor: colorScheme.onPrimary,
          textColor: colorScheme.onSurface,
        );
      case EquipmentCurrentStatus.rented:
        return _StatusConfig(
          label: 'Loué',
          color: colorScheme.tertiary,
          borderColor: colorScheme.onTertiary,
          textColor: colorScheme.onSurface,
        );
      case EquipmentCurrentStatus.maintenance:
        return _StatusConfig(
          label: 'Maintenance',
          color: colorScheme.error,
          borderColor: colorScheme.onError,
          textColor: colorScheme.error,
        );
    }
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;
}
