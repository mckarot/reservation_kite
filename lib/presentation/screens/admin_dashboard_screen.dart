import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lesson_validation_screen.dart';
import '../providers/financial_notifier.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../providers/booking_notifier.dart';
import '../providers/staff_notifier.dart';
import '../providers/user_notifier.dart'; // Added for user data

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(financialStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pilotage École')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CHIFFRES CLÉS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _KpiCard(
                  label: 'Ventes Totales',
                  value: '${stats['totalSales']} crédits',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
                const SizedBox(width: 16),
                _KpiCard(
                  label: 'En engagement',
                  value: '${stats['totalEngagement']} crédits',
                  icon: Icons.account_balance_wallet,
                  color: Colors.blue,
                ),
              ],
            ),
            const _PendingRequestsSection(),
            const SizedBox(height: 32),
            const Text(
              'PLANNING À VENIR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _UpcomingSessionsCard(
              sessions: stats['upcomingSessions'] as List<Reservation>,
            ),
            const SizedBox(height: 32),
            const Text(
              'TOP CLIENTS (VOLUME)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _TopClientsCard(clients: stats['topClients'] as List<User>),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingRequestsSection extends ConsumerWidget {
  const _PendingRequestsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);

    return bookingsAsync.when(
      data: (bookings) {
        final pending = bookings
            .where((b) => b.status == ReservationStatus.pending)
            .toList();
        if (pending.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'DEMANDES EN ATTENTE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            ...pending.map(
              (res) => Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  title: Text(
                    res.clientName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${res.date.day}/${res.date.month} - ${res.slot == TimeSlot.morning ? "Matin" : "Après-midi"}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () =>
                            _confirm(context, ref, res, staffAsync.value),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => ref
                            .read(bookingNotifierProvider.notifier)
                            .updateBookingStatus(
                              res.id,
                              ReservationStatus.cancelled,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => const SizedBox(),
    );
  }

  void _confirm(
    BuildContext context,
    WidgetRef ref,
    Reservation res,
    List? staff,
  ) {
    if (staff == null) return;
    final activeStaff = staff.where((s) => s.isActive).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer & Assigner'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: activeStaff.length,
            itemBuilder: (context, index) {
              final s = activeStaff[index];
              return ListTile(
                title: Text(s.name),
                onTap: () {
                  ref
                      .read(bookingNotifierProvider.notifier)
                      .updateBookingStatus(
                        res.id,
                        ReservationStatus.confirmed,
                        staffId: s.id,
                      );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UpcomingSessionsCard extends ConsumerWidget {
  final List<Reservation> sessions;
  const _UpcomingSessionsCard({required this.sessions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sessions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Aucune session prévue'),
        ),
      );
    }

    final users = ref.watch(userNotifierProvider).value ?? [];

    return Column(
      children: sessions.map((s) {
        final pupil = users.any((u) => u.id == s.pupilId)
            ? users.firstWhere((u) => u.id == s.pupilId)
            : null;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.event, size: 20, color: Colors.blueGrey),
            title: Text(s.clientName),
            subtitle: Text(
              '${s.date.day}/${s.date.month} - ${s.slot.name.toUpperCase()}',
            ),
            trailing: pupil != null
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonValidationScreen(
                            reservation: s,
                            pupil: pupil,
                          ),
                        ),
                      );
                    },
                    child: const Text('Valider'),
                  )
                : const Icon(Icons.chevron_right, size: 16),
          ),
        );
      }).toList(),
    );
  }
}

class _TopClientsCard extends StatelessWidget {
  final List<User> clients;
  const _TopClientsCard({required this.clients});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: clients.asMap().entries.map((entry) {
          final client = entry.value;
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  radius: 12,
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                title: Text(
                  client.displayName,
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Text(
                  '${client.totalCreditsPurchased} achats',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (entry.key != clients.length - 1) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}
