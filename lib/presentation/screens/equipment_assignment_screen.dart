import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/reservation.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/equipment_slot_availability_service.dart';
import '../providers/auth_state_provider.dart';
import '../providers/booking_notifier.dart';
import '../providers/equipment_assignment_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../widgets/equipment_category_filter.dart';

/// Écran d'assignment d'équipement pour les séances.
///
/// Permet à l'admin/moniteur de :
/// - Voir les séances à venir
/// - Voir les élèves inscrits
/// - Assigner du matériel spécifique à chaque élève
class EquipmentAssignmentScreen extends ConsumerStatefulWidget {
  const EquipmentAssignmentScreen({super.key});

  @override
  ConsumerState<EquipmentAssignmentScreen> createState() =>
      _EquipmentAssignmentScreenState();
}

class _EquipmentAssignmentScreenState
    extends ConsumerState<EquipmentAssignmentScreen> {
  Reservation? _selectedSession;
  String? _selectedUserId;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    // Utiliser le même pattern que admin_dashboard_screen.dart
    final reservationsAsync = ref.watch(bookingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment de matériel'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          reservationsAsync.when(
            data: (reservations) => _buildSessionSelector(reservations),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Erreur: $e'),
            ),
          ),
          if (_selectedSession != null) ...[
            _buildStudentSelector(),
            if (_selectedUserId != null) Expanded(child: _buildEquipmentList()),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionSelector(List<Reservation> reservations) {
    // Filtrer les réservations confirmées avec instructeur
    final sessions = reservations
        .where(
          (r) =>
              r.status == ReservationStatus.confirmed &&
              (r.staffId?.isNotEmpty ?? false),
        )
        .where(
          (s) =>
              s.date.isAfter(DateTime.now().subtract(const Duration(days: 1))),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1. Sélectionnez une séance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (sessions.isEmpty)
            Column(
              children: [
                const Icon(Icons.event_busy, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  'Aucune séance à venir',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            )
          else
            DropdownButtonFormField<Reservation>(
              initialValue: _selectedSession,
              decoration: const InputDecoration(
                labelText: 'Séance',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Choisir une séance'),
              items: sessions.map((session) {
                return DropdownMenuItem(
                  value: session,
                  child: Text(
                    '${DateFormat('dd/MM/yyyy').format(session.date)} - ${session.slot == TimeSlot.morning ? 'Matin' : 'Après-midi'}',
                  ),
                );
              }).toList(),
              onChanged: (session) {
                setState(() {
                  _selectedSession = session;
                  _selectedUserId = null;
                  _selectedCategory = null;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    if (_selectedSession == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2. Sélectionnez un élève',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Pour l'instant, on utilise le pupil de la réservation
          // TODO: Afficher la liste des élèves inscrits à la séance
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(_selectedSession!.clientName),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedUserId = _selectedSession!.pupilId ?? '';
                  _selectedCategory = null;
                });
              },
              child: const Text('Sélectionner cet élève'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentList() {
    if (_selectedCategory == null) {
      return Column(
        children: [
          EquipmentCategoryFilter(
            selectedCategoryId: _selectedCategory,
            onCategorySelected: (categoryId) =>
                setState(() => _selectedCategory = categoryId),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Sélectionnez une catégorie pour voir les équipements',
              ),
            ),
          ),
        ],
      );
    }

    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return Column(
      children: [
        EquipmentCategoryFilter(
          selectedCategoryId: _selectedCategory,
          onCategorySelected: (categoryId) =>
              setState(() => _selectedCategory = categoryId),
        ),
        Expanded(
          child: equipmentAsync.when(
            data: (equipment) {
              final filtered = equipment
                  .where((e) => e.categoryId == _selectedCategory)
                  .toList();

              if (filtered.isEmpty) {
                return const Center(
                  child: Text('Aucun équipement dans cette catégorie'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final eq = filtered[index];
                  return _EquipmentTile(
                    equipment: eq,
                    sessionId: _selectedSession!.id,
                    userId: _selectedUserId!,
                    sessionDate: _selectedSession!.date,
                    sessionSlot: _selectedSession!.slot,
                    onAssign: () => _assignEquipment(eq),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _assignEquipment(Equipment eq) async {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.read(currentUserProvider).value;

    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Utilisateur non connecté')));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'assignment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Équipement : ${eq.brand} ${eq.model} - ${eq.size}m²'),
            if (eq.serialNumber != null) Text('S/N: ${eq.serialNumber}'),
            const SizedBox(height: 8),
            Text('Élève : ${_selectedSession!.clientName}'),
            Text(
              'Séance : ${DateFormat('dd/MM/yyyy').format(_selectedSession!.date)} - ${_selectedSession!.slot == TimeSlot.morning ? 'Matin' : 'Après-midi'}',
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
      final booking = EquipmentBooking(
        id: const Uuid().v4(),
        userId: _selectedSession!.pupilId ?? '',
        userName: _selectedSession!.clientName,
        userEmail: '',
        equipmentId: eq.id,
        equipmentType: eq.categoryId,
        equipmentBrand: eq.brand,
        equipmentModel: eq.model,
        equipmentSize: eq.size,
        dateString: DateFormat('yyyy-MM-dd').format(_selectedSession!.date),
        dateTimestamp: _selectedSession!.date,
        slot: _selectedSession!.slot == TimeSlot.morning
            ? EquipmentBookingSlot.morning
            : _selectedSession!.slot == TimeSlot.afternoon
            ? EquipmentBookingSlot.afternoon
            : EquipmentBookingSlot.fullDay,
        status: EquipmentBookingStatus.confirmed,
        type: EquipmentBookingType.assignment,
        assignedBy: currentUser.id,
        createdBy: currentUser.id,
        sessionId: _selectedSession!.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref
          .read(
            equipmentAssignmentNotifierProvider(_selectedSession!.id).notifier,
          )
          .assignEquipment(booking);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Équipement assigné et réservé avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _selectedSession = null;
        _selectedUserId = null;
        _selectedCategory = null;
      });
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
}

class _EquipmentTile extends ConsumerWidget {
  final Equipment equipment;
  final String sessionId;
  final String userId;
  final VoidCallback onAssign;
  final DateTime? sessionDate;
  final TimeSlot? sessionSlot;

  const _EquipmentTile({
    required this.equipment,
    required this.sessionId,
    required this.userId,
    required this.onAssign,
    this.sessionDate,
    this.sessionSlot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utiliser le service utilitaire pour vérifier la disponibilité
    // HARMONISATION : La disponibilité est calculée via les conflits, pas le statut
    // IMPORTANT : Utiliser la date et le créneau de la séance, pas DateTime.now()
    final slot = sessionSlot == TimeSlot.morning
        ? EquipmentBookingSlot.morning
        : sessionSlot == TimeSlot.afternoon
        ? EquipmentBookingSlot.afternoon
        : EquipmentBookingSlot.fullDay;

    return FutureBuilder<bool>(
      future: EquipmentSlotAvailabilityService.isEquipmentAvailable(
        equipmentId: equipment.id,
        date: sessionDate ?? DateTime.now(),
        slot: slot,
      ),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isAvailable ? Colors.green : Colors.grey,
              child: Icon(
                _getCategoryIcon(equipment.categoryId),
                color: Colors.white,
              ),
            ),
            title: Text('${equipment.brand} ${equipment.model}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${equipment.size}m²'),
                if (equipment.serialNumber != null)
                  Text(
                    'S/N: ${equipment.serialNumber}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                if (!isAvailable && !isLoading)
                  const Text(
                    'Indisponible (déjà réservé)',
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
              ],
            ),
            trailing: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : isAvailable
                ? ElevatedButton(
                    onPressed: onAssign,
                    child: const Text('Assigner'),
                  )
                : const Chip(
                    label: Text('Indisponible'),
                    backgroundColor: Colors.grey,
                  ),
          ),
        );
      },
    );
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
}
