import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/equipment_with_availability.dart';
import '../../l10n/app_localizations.dart';
import '../providers/auth_state_provider.dart';
import '../providers/equipment_availability_notifier.dart';
import '../providers/equipment_booking_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../providers/theme_notifier.dart';
import '../widgets/equipment_category_filter.dart';

/// Écran de réservation de matériel pour les élèves.
class EquipmentBookingScreen extends ConsumerStatefulWidget {
  const EquipmentBookingScreen({super.key});

  @override
  ConsumerState<EquipmentBookingScreen> createState() =>
      _EquipmentBookingScreenState();
}

class _EquipmentBookingScreenState
    extends ConsumerState<EquipmentBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  EquipmentBookingSlot _selectedSlot = EquipmentBookingSlot.morning;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    // Utilise le même provider que EquipmentAdminScreen
    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.equipmentRental),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildDateSelector(l10n, primaryColor),
          _buildSlotSelector(l10n),
          EquipmentCategoryFilter(
            selectedCategoryId: _selectedCategory,
            onCategorySelected: (categoryId) =>
                setState(() => _selectedCategory = categoryId),
          ),
          Expanded(
            child: equipmentAsync.when(
              data: (equipment) =>
                  _buildEquipmentList(equipment, l10n, primaryColor),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(AppLocalizations l10n, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectDate,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('EEEE dd MMMM', 'fr_FR').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null && mounted) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlotSelector(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _SlotChip(
              label: l10n.morning,
              icon: Icons.wb_sunny,
              isSelected: _selectedSlot == EquipmentBookingSlot.morning,
              onTap: () =>
                  setState(() => _selectedSlot = EquipmentBookingSlot.morning),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SlotChip(
              label: l10n.afternoon,
              icon: Icons.nights_stay,
              isSelected: _selectedSlot == EquipmentBookingSlot.afternoon,
              onTap: () => setState(
                () => _selectedSlot = EquipmentBookingSlot.afternoon,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SlotChip(
              label: l10n.fullDay,
              icon: Icons.wb_sunny,
              isSelected: _selectedSlot == EquipmentBookingSlot.fullDay,
              onTap: () =>
                  setState(() => _selectedSlot = EquipmentBookingSlot.fullDay),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentList(
    List<Equipment> equipment,
    AppLocalizations l10n,
    Color primaryColor,
  ) {
    // Filtrer par catégorie si sélectionnée
    final filtered = _selectedCategory != null
        ? equipment.where((e) => e.categoryId == _selectedCategory).toList()
        : equipment;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noEquipmentAvailable,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final eq = filtered[index];

        final brand = eq.brand;
        final model = eq.model;
        final size = eq.size;
        final categoryId = eq.categoryId;
        final totalQuantity = eq.totalQuantity;
        final docId = eq.id;

        return StreamBuilder<EquipmentWithAvailability>(
          stream: ref
              .read(equipmentAvailabilityNotifierProvider.notifier)
              .watchEquipmentAvailability(
                equipmentId: docId,
                date: _selectedDate,
                slot: _selectedSlot,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Chargement...'),
              );
            }

            if (snapshot.hasError) {
              return ListTile(
                leading: const Icon(Icons.error, color: Colors.red),
                title: Text('Erreur: ${snapshot.error}'),
              );
            }

            final availability = snapshot.data;
            if (availability == null) {
              return const SizedBox.shrink();
            }

            final isAvailable = availability.isAvailable;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isAvailable
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.errorContainer,
                  child: Icon(
                    _getCategoryIcon(categoryId),
                    color: isAvailable
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                title: Text('$brand $model'),
                subtitle: Text(
                  isAvailable
                      ? '${size}m² - ${availability.availableQuantity}/$totalQuantity ${l10n.available}'
                      : '${size}m² - ${l10n.unavailable}',
                  style: TextStyle(
                    color: isAvailable
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: isAvailable
                    ? ElevatedButton(
                        onPressed: () => _confirmBooking(
                          docId,
                          availability,
                          brand,
                          model,
                          size,
                          categoryId,
                        ),
                        child: Text(l10n.rentButton),
                      )
                    : const Chip(
                        label: Text('Indisponible'),
                        backgroundColor: Colors.grey,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  String _parseSize(dynamic sizeValue) {
    if (sizeValue == null) return '0';
    if (sizeValue is String) return sizeValue;
    if (sizeValue is double || sizeValue is int) return sizeValue.toString();
    return sizeValue.toString();
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'kite':
        return Icons.kitesurfing;
      case 'foil':
        return Icons.surfing;
      case 'board':
        return Icons.directions_bike;
      case 'harness':
        return Icons.security;
      default:
        return Icons.inventory_2;
    }
  }

  Future<void> _confirmBooking(
    String docId,
    EquipmentWithAvailability availability,
    String brand,
    String model,
    String size,
    String categoryId,
  ) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmBooking),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$brand $model - ${size}m²'),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('dd/MM/yyyy').format(_selectedDate)} - ${_getSlotName(l10n)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirmButton),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final userId = ref.read(currentUserProvider).value?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      await ref
          .read(equipmentBookingNotifierProvider(userId).notifier)
          .createBooking(
            equipmentId: docId,
            equipmentType: categoryId,
            equipmentBrand: brand,
            equipmentModel: model,
            equipmentSize: size,
            date: _selectedDate,
            slot: _selectedSlot,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.bookingConfirmed),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _getSlotName(AppLocalizations l10n) {
    switch (_selectedSlot) {
      case EquipmentBookingSlot.morning:
        return l10n.morning;
      case EquipmentBookingSlot.afternoon:
        return l10n.afternoon;
      case EquipmentBookingSlot.fullDay:
        return l10n.fullDay;
    }
  }
}

class _SlotChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SlotChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
