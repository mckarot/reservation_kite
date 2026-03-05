import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../l10n/app_localizations.dart';
import '../providers/theme_notifier.dart';
import '../widgets/equipment_category_filter.dart';

/// Écran de visualisation des réservations de matériel et des disponibilités.
///
/// Permet à l'admin de voir :
/// - Toutes les réservations de matériel par date
/// - Quel client/élève a réservé quel équipement
/// - Les disponibilités par catégorie
class EquipmentReservationsScreen extends ConsumerStatefulWidget {
  const EquipmentReservationsScreen({super.key});

  @override
  ConsumerState<EquipmentReservationsScreen> createState() =>
      _EquipmentReservationsScreenState();
}

class _EquipmentReservationsScreenState
    extends ConsumerState<EquipmentReservationsScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Réservations Matériel'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          // Utilise le même filtre de catégorie que EquipmentAdminScreen et EquipmentBookingScreen
          EquipmentCategoryFilter(
            selectedCategoryId: _selectedCategory,
            onCategorySelected: (categoryId) =>
                setState(() => _selectedCategory = categoryId),
          ),
          Expanded(
            child: _buildReservationsList(primaryColor, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy', 'fr_FR').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Aujourd\'hui',
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList(Color primaryColor, AppLocalizations l10n) {
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('equipment_bookings')
          .where('date_string', isEqualTo: dateString)
          .where('status', whereIn: ['confirmed', 'completed'])
          .orderBy('date_timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune réservation pour cette date',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        var bookings = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Filtrer par catégorie si sélectionnée (utilise les IDs de catégories Firestore)
        if (_selectedCategory != null) {
          bookings = bookings
              .where((b) => b['equipment_type'] == _selectedCategory)
              .toList();
        }

        // Grouper par type d'équipement
        final groupedByType = <String, List<Map<String, dynamic>>>{};
        for (var booking in bookings) {
          final type = booking['equipment_type'] as String;
          groupedByType.putIfAbsent(type, () => []).add(booking);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedByType.length,
          itemBuilder: (context, index) {
            final type = groupedByType.keys.elementAt(index);
            final typeBookings = groupedByType[type]!;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(type),
                          color: primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getCategoryName(type),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text('${typeBookings.length}'),
                          backgroundColor: primaryColor,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: typeBookings.map((booking) {
                        final slot = booking['slot'] as String;
                        final userName = booking['user_name'] as String? ?? 'Inconnu';
                        final equipmentBrand = booking['equipment_brand'] as String? ?? '';
                        final equipmentModel = booking['equipment_model'] as String? ?? '';
                        final equipmentSize = booking['equipment_size'] as String? ?? '';
                        final status = booking['status'] as String;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getSlotColor(slot).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getSlotColor(slot).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getSlotColor(slot),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _getSlotLabel(slot),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$equipmentBrand $equipmentModel - ${equipmentSize}m²',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildStatusChip(status),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'confirmed':
        color = Colors.green;
        label = 'Confirmé';
        break;
      case 'completed':
        color = Colors.blue;
        label = 'Terminé';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Annulé';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Color _getSlotColor(String slot) {
    switch (slot) {
      case 'morning':
        return Colors.orange;
      case 'afternoon':
        return Colors.blue;
      case 'full_day':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getSlotLabel(String slot) {
    switch (slot) {
      case 'morning':
        return 'MATIN';
      case 'afternoon':
        return 'APREM';
      case 'full_day':
        return 'JOUR';
      default:
        return slot.toUpperCase();
    }
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

  String _getCategoryName(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'kite':
        return 'Kites';
      case 'foil':
        return 'Foils';
      case 'board':
        return 'Planches';
      case 'harness':
        return 'Sièges';
      default:
        return categoryId.toUpperCase();
    }
  }
}
