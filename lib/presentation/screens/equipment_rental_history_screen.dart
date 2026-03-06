import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/equipment_rental.dart';
import '../providers/equipment_rental_notifier.dart';
import '../widgets/equipment_rental_tile.dart';

/// Écran d'historique des locations de matériel pour les élèves.
class EquipmentRentalHistoryScreen extends ConsumerStatefulWidget {
  const EquipmentRentalHistoryScreen({super.key});

  @override
  ConsumerState<EquipmentRentalHistoryScreen> createState() =>
      _EquipmentRentalHistoryScreenState();
}

class _EquipmentRentalHistoryScreenState
    extends ConsumerState<EquipmentRentalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final rentalsAsync = ref.watch(equipmentRentalNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des locations'),
        backgroundColor: colorScheme.surface,
      ),
      body: rentalsAsync.when(
        data: (rentals) {
          if (rentals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune location',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vous n\'avez pas encore loué de matériel',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Trier par date décroissante
          final sortedRentals = List<EquipmentRental>.from(rentals)
            ..sort((a, b) => b.dateTimestamp.compareTo(a.dateTimestamp));

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: sortedRentals.length,
            itemBuilder: (context, index) {
              final rental = sortedRentals[index];
              return EquipmentRentalTile(
                rental: rental,
                showActions: rental.status == RentalStatus.pending ||
                    rental.status == RentalStatus.confirmed ||
                    rental.status == RentalStatus.active,
                onCancel: rental.status == RentalStatus.pending
                    ? () => _confirmCancel(ref, rental.id)
                    : null,
                onCheckOut: rental.status == RentalStatus.confirmed
                    ? () => _showCheckOutDialog(ref, rental)
                    : null,
                onCheckIn: rental.status == RentalStatus.active
                    ? () => _showCheckInDialog(ref, rental)
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.error,
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
        ),
      ),
    );
  }

  void _confirmCancel(WidgetRef ref, String rentalId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final colorScheme = theme.colorScheme;
        
        return AlertDialog(
          title: const Text('Annuler la location'),
          content: const Text(
            'Êtes-vous sûr de vouloir annuler cette location ? '
            'Le montant sera remboursé sur votre wallet.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Retour'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _cancelRental(ref, rentalId);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelRental(WidgetRef ref, String rentalId) async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    
    try {
      await ref.read(equipmentRentalNotifierProvider.notifier).cancelRental(rentalId);

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location annulée'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  void _showCheckOutDialog(WidgetRef ref, EquipmentRental rental) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        
        return AlertDialog(
          title: const Text('Check-out du matériel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vérifiez l\'état du matériel avant de le remettre à l\'élève.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Text('État du matériel :'),
              const SizedBox(height: 8),
              ...['Neuf', 'Bon état', 'État moyen', 'Usé'].map((condition) {
                return ListTile(
                  dense: true,
                  title: Text(condition),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _checkOut(ref, rental.id, condition.toLowerCase());
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _checkOut(WidgetRef ref, String rentalId, String condition) async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    
    try {
      await ref.read(equipmentRentalNotifierProvider.notifier).checkOut(
            rentalId: rentalId,
            condition: condition,
          );

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Check-out effectué'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  void _showCheckInDialog(WidgetRef ref, EquipmentRental rental) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        
        return AlertDialog(
          title: const Text('Check-in du matériel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vérifiez l\'état du matériel lors de la restitution.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Text('État du matériel :'),
              const SizedBox(height: 8),
              ...['Neuf', 'Bon état', 'État moyen', 'Usé'].map((condition) {
                return ListTile(
                  dense: true,
                  title: Text(condition),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _checkIn(ref, rental.id, condition.toLowerCase());
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _checkIn(WidgetRef ref, String rentalId, String condition) async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    
    try {
      await ref.read(equipmentRentalNotifierProvider.notifier).checkIn(
            rentalId: rentalId,
            condition: condition,
          );

      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Check-in effectué'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: errorColor,
        ),
      );
    }
  }
}
