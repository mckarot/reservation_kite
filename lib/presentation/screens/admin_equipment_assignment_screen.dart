import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/equipment_item.dart';
import '../../domain/models/equipment_rental.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../providers/equipment_notifier.dart';
import '../providers/equipment_rental_notifier.dart';
import '../widgets/equipment_card.dart';

/// Écran d'assignment de matériel pour l'admin.
///
/// Permet d'assigner du matériel à un élève pour une réservation donnée.
class AdminEquipmentAssignmentScreen extends ConsumerStatefulWidget {
  final Reservation reservation;
  final User student;

  const AdminEquipmentAssignmentScreen({
    super.key,
    required this.reservation,
    required this.student,
  });

  @override
  ConsumerState<AdminEquipmentAssignmentScreen> createState() =>
      _AdminEquipmentAssignmentScreenState();
}

class _AdminEquipmentAssignmentScreenState
    extends ConsumerState<AdminEquipmentAssignmentScreen> {
  EquipmentCategoryType? _selectedCategory;
  bool _isAssigning = false;
  List<EquipmentRental> _existingRentals = [];
  bool _isLoadingRentals = false;

  @override
  void initState() {
    super.initState();
    _loadExistingRentals();
  }

  Future<void> _loadExistingRentals() async {
    setState(() {
      _isLoadingRentals = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('equipment_rentals')
          .where('reservation_id', isEqualTo: widget.reservation.id)
          .where('status', whereIn: ['pending', 'confirmed', 'active'])
          .get();

      setState(() {
        _existingRentals = snapshot.docs
            .map((doc) => EquipmentRental.fromJson(doc.data()..['id'] = doc.id))
            .toList();
      });
    } catch (e) {
      print('Erreur chargement rentals: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRentals = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigner du matériel'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          if (_existingRentals.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadExistingRentals,
              tooltip: 'Actualiser',
            ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec infos réservation
          _buildHeader(colorScheme),
          // Locations existantes
          if (_existingRentals.isNotEmpty) _buildExistingRentals(colorScheme),
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

  Widget _buildHeader(ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Réservation du ${DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(widget.reservation.date)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                widget.student.displayName,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                _getSlotLabel(widget.reservation.slot),
                style: theme.textTheme.bodyMedium,
              ),
            ],
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
              value: widget.student.displayName,
              theme: theme,
              colorScheme: colorScheme,
            ),
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat(
                'EEEE dd MMMM yyyy',
                'fr_FR',
              ).format(widget.reservation.date),
              theme: theme,
              colorScheme: colorScheme,
            ),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Créneau',
              value: _getSlotLabel(widget.reservation.slot),
              theme: theme,
              colorScheme: colorScheme,
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
                    onPressed: _isAssigning
                        ? null
                        : () => _assignEquipment(equipment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isAssigning
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Assigner'),
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

    setState(() {
      _isAssigning = true;
    });

    try {
      final rentalNotifier = ref.read(equipmentRentalNotifierProvider.notifier);

      await rentalNotifier.createAdminAssignment(
        reservationId: widget.reservation.id,
        studentId: widget.student.id,
        studentName: widget.student.displayName,
        studentEmail: widget.student.email ?? '',
        equipmentId: equipment.id,
        equipmentName: equipment.name,
        equipmentCategory: equipment.category.name,
        equipmentBrand: equipment.brand,
        equipmentModel: equipment.model,
        equipmentSize: equipment.size,
        date: widget.reservation.date,
        slot: widget.reservation.slot,
      );

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Matériel assigné avec succès'),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Retour à l'écran précédent
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
          _isAssigning = false;
        });
      }
    }
  }

  Widget _buildExistingRentals(ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Matériel assigné (${_existingRentals.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._existingRentals.map(
            (rental) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rental.equipmentName,
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(
                          _getSlotLabel(rental.slot),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _confirmCancelRental(rental),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Annuler'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancelRental(EquipmentRental rental) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Annuler la location'),
        content: Text(
          'Annuler la location de ${rental.equipmentName} pour ${rental.studentName} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Retour'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _cancelRental(rental);
            },
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelRental(EquipmentRental rental) async {
    final theme = Theme.of(context);

    try {
      final rentalNotifier = ref.read(equipmentRentalNotifierProvider.notifier);
      await rentalNotifier.cancelRental(rental.id);

      if (!context.mounted) return;

      // Rafraîchir la liste
      await _loadExistingRentals();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location annulée'),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
    }
  }
}
