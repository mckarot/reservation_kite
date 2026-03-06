import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/equipment_item.dart';
import '../../domain/models/reservation.dart';
import '../providers/equipment_notifier.dart';
import '../providers/equipment_rental_notifier.dart';
import '../widgets/equipment_card.dart';

/// Écran de location de matériel pour les élèves.
///
/// Permet de :
/// - Sélectionner une date et un slot
/// - Voir les équipements disponibles
/// - Confirmer une location (débit wallet immédiat)
class EquipmentRentalScreen extends ConsumerStatefulWidget {
  const EquipmentRentalScreen({super.key});

  @override
  ConsumerState<EquipmentRentalScreen> createState() =>
      _EquipmentRentalScreenState();
}

class _EquipmentRentalScreenState extends ConsumerState<EquipmentRentalScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot _selectedSlot = TimeSlot.morning;
  EquipmentCategoryType? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Louer du matériel'),
        backgroundColor: colorScheme.surface,
      ),
      body: Column(
        children: [
          // Sélecteur de date et slot
          _buildDateTimeSelector(colorScheme),
          const Divider(height: 1),
          // Filtre catégorie
          _buildCategoryFilter(colorScheme),
          const Divider(height: 1),
          // Liste des équipements
          Expanded(child: _buildEquipmentList()),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelector(ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sélecteur de date
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Text('Date : ', style: theme.textTheme.titleMedium),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  DateFormat(
                    'EEEE dd MMMM yyyy',
                    'fr_FR',
                  ).format(_selectedDate),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(
                      const Duration(days: 1),
                    );
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Sélecteur de slot
          SegmentedButton<TimeSlot>(
            segments: const [
              ButtonSegment(
                value: TimeSlot.morning,
                label: Text('Matin'),
                icon: Icon(Icons.wb_sunny_outlined),
              ),
              ButtonSegment(
                value: TimeSlot.afternoon,
                label: Text('Après-midi'),
                icon: Icon(Icons.wb_twilight_outlined),
              ),
              ButtonSegment(
                value: TimeSlot.fullDay,
                label: Text('Journée'),
                icon: Icon(Icons.calendar_today_outlined),
              ),
            ],
            selected: {_selectedSlot},
            onSelectionChanged: (Set<TimeSlot> selected) {
              setState(() {
                _selectedSlot = selected.first;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('Tous'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = null;
                });
              },
            ),
            const SizedBox(width: 8),
            ...EquipmentCategoryType.values.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_getCategoryLabel(category)),
                  avatar: Icon(
                    _getCategoryIcon(category),
                    size: 18,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentList() {
    final theme = Theme.of(context);
    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return equipmentAsync.when(
      data: (equipmentList) {
        // Filtrer par catégorie si sélectionnée
        var filtered = equipmentList;
        if (_selectedCategory != null) {
          filtered = equipmentList
              .where((e) => e.category == _selectedCategory)
              .toList();
        }

        // Filtrer uniquement les équipements actifs et disponibles
        filtered = filtered
            .where(
              (e) =>
                  e.isActive &&
                  e.currentStatus == EquipmentCurrentStatus.available,
            )
            .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun équipement disponible',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Essayez une autre date ou un autre créneau',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final equipment = filtered[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EquipmentCard(
                equipment: equipment,
                isAvailable: true,
                onTap: () => _showRentalConfirmation(equipment),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        final theme = Theme.of(context);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRentalConfirmation(EquipmentItem equipment) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final price = _getPriceForSlot(equipment);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmer la location',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Résumé équipement
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(equipment.category),
                    color: colorScheme.onPrimaryContainer,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        equipment.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${equipment.brand} ${equipment.model} • ${equipment.size} ${_getSizeUnit(equipment.category)}',
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
            // Détails location
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat(
                'EEEE dd MMMM yyyy',
                'fr_FR',
              ).format(_selectedDate),
              theme: theme,
              colorScheme: colorScheme,
            ),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Créneau',
              value: _getSlotLabel(_selectedSlot),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const Divider(height: 24),
            // Prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Prix total', style: theme.textTheme.titleMedium),
                Text(
                  _formatPrice(price),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Le montant sera débité de votre wallet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => _confirmRental(equipment, price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Confirmer et payer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  int _getPriceForSlot(EquipmentItem equipment) {
    switch (_selectedSlot) {
      case TimeSlot.morning:
        return equipment.rentalPriceMorning;
      case TimeSlot.afternoon:
        return equipment.rentalPriceAfternoon;
      case TimeSlot.fullDay:
        return equipment.rentalPriceFullDay;
    }
  }

  String _getSlotLabel(TimeSlot slot) {
    switch (slot) {
      case TimeSlot.morning:
        return 'Matin (08h-12h)';
      case TimeSlot.afternoon:
        return 'Après-midi (13h-18h)';
      case TimeSlot.fullDay:
        return 'Journée complète (08h-18h)';
    }
  }

  String _getCategoryLabel(EquipmentCategoryType category) {
    switch (category) {
      case EquipmentCategoryType.kite:
        return 'Kites';
      case EquipmentCategoryType.board:
        return 'Planches';
      case EquipmentCategoryType.foil:
        return 'Foils';
      case EquipmentCategoryType.harness:
        return 'Harnais';
      case EquipmentCategoryType.wing:
        return 'Wings';
      case EquipmentCategoryType.other:
        return 'Autres';
    }
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

  String _getSizeUnit(EquipmentCategoryType category) {
    return category == EquipmentCategoryType.board ? 'cm' : 'm²';
  }

  String _formatPrice(int price) {
    if (price < 100) {
      return '$price crédits';
    }
    return '€${(price / 100).toStringAsFixed(2)}';
  }

  Future<void> _confirmRental(EquipmentItem equipment, int price) async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    try {
      final rentalNotifier = ref.read(equipmentRentalNotifierProvider.notifier);

      await rentalNotifier.createStudentRental(
        equipmentId: equipment.id,
        equipmentName: equipment.name,
        equipmentCategory: equipment.category.name,
        equipmentBrand: equipment.brand,
        equipmentModel: equipment.model,
        equipmentSize: equipment.size,
        date: _selectedDate,
        slot: _selectedSlot,
        totalPrice: price,
      );

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location confirmée avec succès'),
          backgroundColor: primaryColor,
          // ignore: use_build_context_synchronously
          behavior: SnackBarBehavior.floating,
        ),
      );

      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
