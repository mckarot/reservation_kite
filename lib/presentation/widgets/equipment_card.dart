import 'package:flutter/material.dart';

import '../../domain/models/equipment_item.dart';

/// Widget carte pour afficher un équipement disponible à la location.
class EquipmentCard extends StatelessWidget {
  const EquipmentCard({
    super.key,
    required this.equipment,
    this.onTap,
    this.isAvailable = true,
    this.showPrice = true,
  });

  final EquipmentItem equipment;
  final VoidCallback? onTap;
  final bool isAvailable;
  final bool showPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isAvailable ? 2 : 0,
      color: isAvailable ? colorScheme.surface : colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : catégorie + nom
              Row(
                children: [
                  // Icône catégorie
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(equipment.category),
                      color: colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nom et détails
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          equipment.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${equipment.brand} ${equipment.model} • ${_formatSize(equipment)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Statut
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(equipment.currentStatus, colorScheme),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(equipment.currentStatus),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusOnColor(equipment.currentStatus, colorScheme),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Caractéristiques
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (equipment.color != null && equipment.color!.isNotEmpty)
                    _ChipWithIcon(
                      icon: Icons.palette_outlined,
                      label: equipment.color!,
                    ),
                  if (equipment.serialNumber != null &&
                      equipment.serialNumber!.isNotEmpty)
                    _ChipWithIcon(
                      icon: Icons.tag_outlined,
                      label: 'S/N: ${equipment.serialNumber}',
                    ),
                  _ChipWithIcon(
                    icon: Icons.star_outline,
                    label: _getConditionText(equipment.condition),
                  ),
                  if (equipment.totalRentals > 0)
                    _ChipWithIcon(
                      icon: Icons.history,
                      label: '${equipment.totalRentals} locations',
                    ),
                ],
              ),
              // Prix
              if (showPrice) ...[
                const SizedBox(height: 12),
                Divider(color: colorScheme.outlineVariant),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PriceLabel(
                      label: 'Matin',
                      price: equipment.rentalPriceMorning,
                    ),
                    _PriceLabel(
                      label: 'Après-midi',
                      price: equipment.rentalPriceAfternoon,
                    ),
                    _PriceLabel(
                      label: 'Journée',
                      price: equipment.rentalPriceFullDay,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ],
              // Indisponibilité
              if (!isAvailable) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Actuellement indisponible',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(EquipmentCategoryType category) {
    switch (category) {
      case EquipmentCategoryType.kite:
        return Icons.air;
      case EquipmentCategoryType.board:
        return Icons.surfing;
      case EquipmentCategoryType.foil:
        return Icons.waves;
      case EquipmentCategoryType.harness:
        return Icons.shield_outlined;
      case EquipmentCategoryType.wing:
        return Icons.flight;
      case EquipmentCategoryType.other:
        return Icons.sports;
    }
  }

  String _formatSize(EquipmentItem equipment) {
    final unit = equipment.category == EquipmentCategoryType.board ? 'cm' : 'm²';
    return '${equipment.size} $unit';
  }

  Color _getStatusColor(EquipmentCurrentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return colorScheme.primaryContainer;
      case EquipmentCurrentStatus.rented:
        return colorScheme.tertiaryContainer;
      case EquipmentCurrentStatus.maintenance:
        return colorScheme.errorContainer;
    }
  }

  Color _getStatusOnColor(EquipmentCurrentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return colorScheme.onPrimaryContainer;
      case EquipmentCurrentStatus.rented:
        return colorScheme.onTertiaryContainer;
      case EquipmentCurrentStatus.maintenance:
        return colorScheme.onErrorContainer;
    }
  }

  String _getStatusText(EquipmentCurrentStatus status) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return 'Dispo';
      case EquipmentCurrentStatus.rented:
        return 'Loué';
      case EquipmentCurrentStatus.maintenance:
        return 'Maintenance';
    }
  }

  String _getConditionText(EquipmentCondition condition) {
    switch (condition) {
      case EquipmentCondition.newCondition:
        return 'Neuf';
      case EquipmentCondition.good:
        return 'Bon état';
      case EquipmentCondition.fair:
        return 'État moyen';
      case EquipmentCondition.poor:
        return 'Usé';
    }
  }
}

class _ChipWithIcon extends StatelessWidget {
  const _ChipWithIcon({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({
    required this.label,
    required this.price,
    this.isHighlighted = false,
  });

  final String label;
  final int price;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatPrice(price),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isHighlighted ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    // Si le prix est en crédits (valeur faible), afficher sans devise
    if (price < 100) {
      return '$price crédits';
    }
    // Sinon, afficher en euros (prix en centimes)
    return '€${(price / 100).toStringAsFixed(2)}';
  }
}
