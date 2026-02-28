import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lesson_validation_screen.dart';
import '../providers/financial_notifier.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../providers/booking_notifier.dart';
import '../providers/staff_notifier.dart';
import '../providers/unavailability_notifier.dart';
import '../../domain/models/staff_unavailability.dart';
import '../../domain/models/staff.dart';
import '../providers/user_notifier.dart';
import 'staff_admin_screen.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(financialStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.schoolDashboard)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.keyMetrics,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _KpiCard(
                  label: l10n.totalSales,
                  value: '${stats['totalSales']} crédits',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
                const SizedBox(width: 16),
                _KpiCard(
                  label: l10n.totalEngagement,
                  value: '${stats['totalEngagement']} crédits',
                  icon: Icons.account_balance_wallet,
                  color: Colors.blue,
                ),
              ],
            ),
            const _PendingAbstancesSection(),
            const _PendingRequestsSection(),
            const SizedBox(height: 32),
            Text(
              l10n.upcomingPlanning,
              style: const TextStyle(
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
            Text(
              l10n.topClientsVolume,
              style: const TextStyle(
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

class _PendingAbstancesSection extends ConsumerWidget {
  const _PendingAbstancesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unavailabilitiesAsync = ref.watch(unavailabilityNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);

    return unavailabilitiesAsync.when(
      data: (list) {
        final pending = list
            .where((u) => u.status == UnavailabilityStatus.pending)
            .toList();
        if (pending.isEmpty) return const SizedBox();

        final allStaff = staffAsync.value ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              children: [
                Text(
                  l10n.pendingAbsences,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${pending.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...pending.map((u) {
              final staff = allStaff.firstWhere(
                (s) => s.id == u.staffId,
                orElse: () => Staff(
                  id: '',
                  name: 'Inconnu',
                  bio: '',
                  photoUrl: '',
                  specialties: [],
                  updatedAt: DateTime.now(),
                ),
              );
              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffAdminScreen()),
                  ),
                  leading: const Icon(Icons.event_busy, color: Colors.red),
                  title: Text(
                    '${staff.name} - ${DateFormat('dd/MM').format(u.date)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${u.slot == TimeSlot.fullDay ? l10n.fullDay : (u.slot == TimeSlot.morning ? l10n.morning : l10n.afternoon)} - ${u.reason}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            }),
          ],
        );
      },
      loading: () => const SizedBox(),
      error: (e, _) => const SizedBox(),
    );
  }
}

class _PendingRequestsSection extends ConsumerWidget {
  const _PendingRequestsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
            Text(
              l10n.pendingRequests,
              style: const TextStyle(
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${res.date.day}/${res.date.month} - ${res.slot == TimeSlot.morning ? l10n.morning : l10n.afternoon}',
                      ),
                      if (res.notes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '${l10n.noteLabel}: ${res.notes}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                    ],
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
    final l10n = AppLocalizations.of(context);
    final activeStaff = staff.where((s) => s.isActive).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAndAssign),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (res.notes.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          res.notes,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                l10n.chooseInstructor,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Flexible(
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
            ],
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
    final l10n = AppLocalizations.of(context);
    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(l10n.noSessionsPlanned),
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
                    child: Text(l10n.validate),
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
