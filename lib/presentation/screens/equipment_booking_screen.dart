import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/equipment_with_availability.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/booking_conflict_utils.dart';
import '../providers/auth_state_provider.dart';
import '../providers/equipment_availability_notifier.dart';
import '../providers/equipment_booking_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../providers/theme_notifier.dart';
import '../widgets/equipment_category_filter.dart';
import '../../data/providers/repository_providers.dart';

/// Écran de réservation de matériel pour les élèves.
///
/// FLUX D'ATTRIBUTION : Attribution automatique (Option A)
/// - L'utilisateur choisit la catégorie et la taille
/// - Le système sélectionne automatiquement le premier équipement disponible
/// - La réservation est atomique pour éviter les race conditions
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

    // Grouper les équipements par taille et compter les disponibles
    final groupedBySize = <String, List<Equipment>>{};
    for (var eq in filtered) {
      final size = eq.size;
      if (!groupedBySize.containsKey(size)) {
        groupedBySize[size] = [];
      }
      groupedBySize[size]!.add(eq);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedBySize.length,
      itemBuilder: (context, index) {
        final size = groupedBySize.keys.elementAt(index);
        final equipmentList = groupedBySize[size]!;

        return StreamBuilder<_SizeAvailability>(
          stream: _watchSizeAvailability(equipmentList),
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

            final isAvailable = availability.availableCount > 0;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isAvailable
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.errorContainer,
                  child: Icon(
                    _getCategoryIcon(_selectedCategory ?? ''),
                    color: isAvailable
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                title: Text('${equipmentList.first.brand} ${equipmentList.first.model}'),
                subtitle: Text(
                  isAvailable
                      ? '${size}m² - ${availability.availableCount}/${equipmentList.length} ${l10n.available}'
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
                        onPressed: () => _bookEquipmentForSize(
                          equipmentList,
                          size,
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

  /// Watch la disponibilité pour une taille donnée (plusieurs équipements).
  ///
  /// CORRECTION AUDIT (5.1.3) : Récupère TOUTES les réservations de la date
  /// et utilise countConflictingBookings pour gérer les full_day correctement.
  Stream<_SizeAvailability> _watchSizeAvailability(List<Equipment> equipmentList) {
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Stream combiné : on écoute TOUTES les réservations pour cette date
    // (pas de filtre par slot pour voir les full_day)
    return FirebaseFirestore.instance
        .collection('equipment_bookings')
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .snapshots()
        .map((snapshot) {
      // Récupérer toutes les réservations groupées par équipement
      final bookingsByEquipment = <String, List<Map<String, dynamic>>>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final equipmentId = data['equipment_id'] as String;
        bookingsByEquipment.putIfAbsent(equipmentId, () => []).add(data);
      }

      // Compter les équipements disponibles
      final availableCount = equipmentList.where((eq) {
        // Un équipement est disponible si :
        // 1. Son statut est 'available'
        // 2. Pas de conflit de créneau avec les réservations existantes
        if (eq.status != EquipmentStatus.available) return false;

        final eqBookings = bookingsByEquipment[eq.id] ?? [];
        if (eqBookings.isEmpty) return true; // Pas de réservations → disponible

        // Vérifier les conflits avec le créneau demandé
        final conflicts = countConflictingBookings(eqBookings, _selectedSlot);
        return conflicts == 0; // Disponible si aucun conflit
      }).length;

      return _SizeAvailability(
        availableCount: availableCount,
        totalCount: equipmentList.length,
      );
    });
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

  /// Réserve un équipement pour une taille donnée.
  /// Le système sélectionne automatiquement le premier équipement disponible.
  // ignore_for_file: use_build_context_synchronously
  Future<void> _bookEquipmentForSize(
    List<Equipment> equipmentList,
    String size,
  ) async {
    final l10n = AppLocalizations.of(context);
    final currentUserId = ref.read(currentUserProvider).value?.id;
    
    if (currentUserId == null) {
      _showError('Utilisateur non connecté');
      return;
    }

    // Trouver le premier équipement disponible
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final slotString = _selectedSlot.name;

    // Récupérer les réservations existantes
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('equipment_bookings')
        .where('date_string', isEqualTo: dateString)
        .where('slot', isEqualTo: slotString)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    final reservedIds = bookingsSnapshot.docs
        .map((d) => d.data()['equipment_id'] as String)
        .toSet();

    // Trouver le premier équipement non réservé et disponible
    final availableEquipment = equipmentList.firstWhere(
      (eq) => eq.status == EquipmentStatus.available && !reservedIds.contains(eq.id),
      orElse: () => throw Exception('Aucun équipement disponible'),
    );

    // Stocker les données avant le showDialog pour éviter le BuildContext async gap
    final equipmentBrand = availableEquipment.brand;
    final equipmentModel = availableEquipment.model;
    final equipmentSerial = availableEquipment.serialNumber;
    final equipmentSize = size;
    final selectedDate = _selectedDate;
    final selectedSlot = _selectedSlot;

    // ignore: use_build_context_synchronously
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmBooking),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$equipmentBrand $equipmentModel'),
            if (equipmentSerial != null)
              Text(
                'S/N: $equipmentSerial',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            const SizedBox(height: 8),
            Text(
              '${equipmentSize}m² - ${DateFormat('dd/MM/yyyy').format(selectedDate)} - ${_getSlotNameForSlot(selectedSlot)}',
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
      final user = ref.read(currentUserProvider).value;
      final bookingData = {
        'user_id': currentUserId,
        'user_name': user?.displayName ?? '',
        'user_email': user?.email ?? '',
        'equipment_type': availableEquipment.categoryId,
        'equipment_brand': availableEquipment.brand,
        'equipment_model': availableEquipment.model,
        'equipment_size': size,
        'date_string': dateString,
        'date_timestamp': Timestamp.fromDate(_selectedDate),
        'slot': slotString,
        'created_by': currentUserId,
      };

      final success = await ref
          .read(equipmentRepositoryProvider)
          .bookEquipmentAtomically(
            equipmentId: availableEquipment.id,
            bookingData: bookingData,
          );

      if (!success) {
        throw Exception('Cet équipement vient d\'être réservé. Veuillez réessayer.');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.bookingConfirmed),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      // Rafraîchir la liste
      ref.invalidate(equipmentNotifierProvider);
    } catch (e) {
      if (!mounted) return;
      _showError('Erreur: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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

  String _getSlotNameForSlot(EquipmentBookingSlot slot) {
    switch (slot) {
      case EquipmentBookingSlot.morning:
        return 'Matin';
      case EquipmentBookingSlot.afternoon:
        return 'Après-midi';
      case EquipmentBookingSlot.fullDay:
        return 'Journée';
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

/// Modèle interne pour la disponibilité d'une taille.
class _SizeAvailability {
  final int availableCount;
  final int totalCount;

  _SizeAvailability({
    required this.availableCount,
    required this.totalCount,
  });
}
