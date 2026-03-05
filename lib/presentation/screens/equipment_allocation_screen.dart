import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/reservation.dart';
import '../../l10n/app_localizations.dart';
import '../providers/equipment_assignment_notifier.dart';
import '../providers/equipment_booking_notifier.dart';
import '../providers/equipment_category_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../providers/theme_notifier.dart';
import '../widgets/equipment_category_filter.dart';

/// Écran d'allocation de matériel pour une session de cours.
///
/// Permet d'assigner du matériel aux élèves en respectant les contraintes :
/// - Le matériel n'est indisponible que pour le créneau sélectionné
/// - Filtrage par catégorie d'équipement
/// - Affichage en temps réel de la disponibilité
class EquipmentAllocationScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String studentId;
  final String studentName;
  final DateTime date;
  final TimeSlot slot;

  const EquipmentAllocationScreen({
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.slot,
    super.key,
  });

  @override
  ConsumerState<EquipmentAllocationScreen> createState() =>
      _EquipmentAllocationScreenState();
}

class _EquipmentAllocationScreenState
    extends ConsumerState<EquipmentAllocationScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primaryColor != null
        ? Color(themeSettings!.primaryColor)
        : AppThemeSettings.defaultPrimary;

    // Convertir TimeSlot en EquipmentBookingSlot
    final bookingSlot = _convertToBookingSlot();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.allocateEquipment),
            Text(
              '${widget.studentName} - ${_formatDate(widget.date)} - ${_getSlotName(bookingSlot)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filtre par catégorie
          EquipmentCategoryFilter(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() => _selectedCategoryId = categoryId);
            },
          ),
          const Divider(),
          // Liste du matériel
          Expanded(child: _buildEquipmentList(primaryColor, bookingSlot)),
        ],
      ),
    );
  }

  Widget _buildEquipmentList(
    Color primaryColor,
    EquipmentBookingSlot bookingSlot,
  ) {
    final equipmentAsync = ref.watch(equipmentNotifierProvider);
    final categoriesAsync = ref.watch(equipmentCategoryNotifierProvider);

    return equipmentAsync.when(
      data: (equipmentList) {
        // Filtrer par statut disponible
        final availableEquipment = equipmentList
            .where((e) => e.status == EquipmentStatus.available)
            .toList();

        // Filtrer par catégorie si sélectionnée
        final filteredEquipment = _selectedCategoryId != null
            ? availableEquipment
                  .where((e) => e.categoryId == _selectedCategoryId)
                  .toList()
            : availableEquipment;

        if (filteredEquipment.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun équipement disponible',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        // Trier par catégorie puis par marque
        filteredEquipment.sort((a, b) {
          final categoryCompare = a.categoryId.compareTo(b.categoryId);
          if (categoryCompare != 0) return categoryCompare;
          return a.brand.compareTo(b.brand);
        });

        return categoriesAsync.when(
          data: (categories) {
            final categoryMap = {for (var cat in categories) cat.id: cat.name};

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredEquipment.length,
              itemBuilder: (context, index) {
                final equipment = filteredEquipment[index];
                final categoryName =
                    categoryMap[equipment.categoryId] ?? equipment.categoryId;

                return FutureBuilder<bool>(
                  future: _isEquipmentAvailable(
                    equipment.id,
                    widget.date,
                    bookingSlot,
                  ),
                  builder: (context, snapshot) {
                    final isAvailable = snapshot.data ?? false;
                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: isAvailable
                          ? primaryColor.withOpacity(0.05)
                          : Colors.grey.shade200,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isAvailable
                              ? primaryColor
                              : Colors.grey,
                          child: Icon(
                            _getCategoryIcon(categoryName),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${equipment.brand} ${equipment.model}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAvailable ? null : Colors.grey.shade600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${equipment.size}m² • $categoryName'),
                            if (!isAvailable && !isLoading)
                              Text(
                                'Déjà réservé pour ce créneau',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                        trailing: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: isAvailable
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: isAvailable
                                    ? () => _assignEquipment(equipment)
                                    : null,
                              ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Erreur: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erreur: $error')),
    );
  }

  /// Vérifie si un équipement est disponible pour la date et le créneau donnés.
  Future<bool> _isEquipmentAvailable(
    String equipmentId,
    DateTime date,
    EquipmentBookingSlot slot,
  ) async {
    // Formater la date comme dans le repository
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    // Vérifier les réservations pour cet équipement à cette date
    final bookings = await FirebaseFirestore.instance
        .collection('equipment_bookings')
        .where('equipment_id', isEqualTo: equipmentId)
        .where('date_string', isEqualTo: dateString)
        .where('status', whereIn: ['confirmed', 'pending'])
        .get();

    for (var doc in bookings.docs) {
      final bookingData = doc.data();
      final bookingSlotStr = bookingData['slot'] as String;

      // Convertir en EquipmentBookingSlot
      EquipmentBookingSlot? bookingSlot;
      if (bookingSlotStr == 'morning') {
        bookingSlot = EquipmentBookingSlot.morning;
      } else if (bookingSlotStr == 'afternoon') {
        bookingSlot = EquipmentBookingSlot.afternoon;
      } else if (bookingSlotStr == 'full_day') {
        bookingSlot = EquipmentBookingSlot.fullDay;
      }

      // Vérifier les conflits de créneau
      if (_hasSlotConflict(slot, bookingSlot)) {
        return false; // Équipement indisponible
      }
    }

    return true; // Équipement disponible
  }

  /// Vérifie s'il y a un conflit entre deux créneaux.
  bool _hasSlotConflict(
    EquipmentBookingSlot slot1,
    EquipmentBookingSlot? slot2,
  ) {
    if (slot2 == null) return false;

    // full_day est en conflit avec tout
    if (slot1 == EquipmentBookingSlot.fullDay ||
        slot2 == EquipmentBookingSlot.fullDay) {
      return true;
    }

    // morning et afternoon ne sont pas en conflit entre eux
    return slot1 == slot2;
  }

  Future<void> _assignEquipment(Equipment equipment) async {
    final l10n = AppLocalizations.of(context);
    final bookingSlot = _convertToBookingSlot();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'allocation'),
        content: Text(
          'Assigner ${equipment.brand} ${equipment.model} (${equipment.size}m²) à ${widget.studentName} pour le ${_formatDate(widget.date)} - ${_getSlotName(bookingSlot)} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Assigner'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      // Utiliser le notifier pour créer la réservation
      final notifier = ref.read(
        equipmentBookingNotifierProvider(widget.studentId).notifier,
      );

      await notifier.createBooking(
        equipmentId: equipment.id,
        equipmentType: equipment.categoryId,
        equipmentBrand: equipment.brand,
        equipmentModel: equipment.model,
        equipmentSize: equipment.size,
        date: widget.date,
        slot: bookingSlot,
        sessionId: widget.sessionId,
      );

      // Invalider le cache des assignations pour rafraîchir l'affichage
      ref.invalidate(equipmentAssignmentNotifierProvider(widget.sessionId));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Matériel assigné avec succès à ${widget.studentName}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
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

  EquipmentBookingSlot _convertToBookingSlot() {
    switch (widget.slot) {
      case TimeSlot.morning:
        return EquipmentBookingSlot.morning;
      case TimeSlot.afternoon:
        return EquipmentBookingSlot.afternoon;
      case TimeSlot.fullDay:
        return EquipmentBookingSlot.fullDay;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return "Aujourd'hui";
    } else if (dateOnly == tomorrow) {
      return 'Demain';
    } else {
      final months = [
        'janv.',
        'févr.',
        'mars',
        'avr.',
        'mai',
        'juin',
        'juil.',
        'août',
        'sept.',
        'oct.',
        'nov.',
        'déc.',
      ];
      return '${date.day} ${months[date.month - 1]}';
    }
  }

  String _getSlotName(EquipmentBookingSlot slot) {
    switch (slot) {
      case EquipmentBookingSlot.morning:
        return 'Matin';
      case EquipmentBookingSlot.afternoon:
        return 'Après-midi';
      case EquipmentBookingSlot.fullDay:
        return 'Journée complète';
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('kite')) return Icons.kitesurfing;
    if (name.contains('foil')) return Icons.surfing;
    if (name.contains('board')) return Icons.directions_bike;
    if (name.contains('harness')) return Icons.security;
    return Icons.inventory_2;
  }
}
