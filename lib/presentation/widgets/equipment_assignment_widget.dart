import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/equipment_item.dart';
import '../../domain/models/reservation.dart';
import '../../utils/date_utils.dart';
import '../providers/equipment_notifier.dart';
import '../providers/equipment_rental_notifier.dart';
import '../widgets/equipment_card.dart';

/// Widget d'assignment de matériel pour les moniteurs.
///
/// À intégrer dans l'écran de validation de leçon.
/// Permet d'assigner du matériel aux élèves d'une réservation.
class EquipmentAssignmentWidget extends ConsumerStatefulWidget {
  const EquipmentAssignmentWidget({
    super.key,
    required this.reservationId,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.date,
    required this.slot,
    this.onEquipmentAssigned,
  });

  final String reservationId;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final DateTime date;
  final TimeSlot slot;
  final VoidCallback? onEquipmentAssigned;

  @override
  ConsumerState<EquipmentAssignmentWidget> createState() =>
      _EquipmentAssignmentWidgetState();
}

class _EquipmentAssignmentWidgetState
    extends ConsumerState<EquipmentAssignmentWidget> {
  EquipmentCategoryType? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              children: [
                Icon(Icons.inventory_2, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Assignment de matériel',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Sélectionnez le matériel à assigner à ${widget.studentName}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            // Filtre catégorie
            SingleChildScrollView(
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
            const SizedBox(height: 16),
            // Liste des équipements
            SizedBox(height: 300, child: _buildEquipmentList()),
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
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'Aucun équipement disponible',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final equipment = filtered[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EquipmentCard(
                equipment: equipment,
                isAvailable: true,
                showPrice: false,
                onTap: () => _confirmAssignment(equipment),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Erreur : $error',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }

  void _confirmAssignment(EquipmentItem equipment) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              'Confirmer l\'assignment',
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
                        '${equipment.brand} ${equipment.model}',
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
            // Détails
            _buildDetailRow(
              icon: Icons.person,
              label: 'Élève',
              value: widget.studentName,
            ),
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat(
                'EEEE dd MMMM yyyy',
                'fr_FR',
              ).format(widget.date),
            ),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Créneau',
              value: _getSlotLabel(widget.slot),
            ),
            const SizedBox(height: 24),
            // Boutons
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
                    onPressed: () => _assignEquipment(equipment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Assigner'),
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
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
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

  Future<void> _assignEquipment(EquipmentItem equipment) async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    try {
      final rentalNotifier = ref.read(equipmentRentalNotifierProvider.notifier);

      await rentalNotifier.createInstructorAssignment(
        reservationId: widget.reservationId,
        studentId: widget.studentId,
        studentName: widget.studentName,
        studentEmail: widget.studentEmail,
        equipmentId: equipment.id,
        equipmentName: equipment.name,
        equipmentCategory: equipment.category.name,
        equipmentBrand: equipment.brand,
        equipmentModel: equipment.model,
        equipmentSize: equipment.size,
        date: widget.date,
        slot: widget.slot,
      );

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Matériel assigné avec succès'),
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
