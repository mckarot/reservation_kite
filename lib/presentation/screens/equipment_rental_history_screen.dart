import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/equipment_rental.dart';
import '../providers/equipment_rental_notifier.dart';
import '../widgets/equipment_rental_tile.dart';
import 'equipment_checkout_screen.dart';

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
                    ? () => _navigateToCheckout(ref, rental)
                    : null,
                onCheckIn: rental.status == RentalStatus.active
                    ? () => _navigateToCheckout(ref, rental)
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

  void _navigateToCheckout(WidgetRef ref, EquipmentRental rental) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentCheckoutScreen(rental: rental),
      ),
    ).then((_) {
      // Rafraîchir les données après retour
      ref.invalidate(equipmentRentalNotifierProvider);
    });
  }
}
