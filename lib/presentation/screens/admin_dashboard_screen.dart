import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/financial_notifier.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';

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

class _UpcomingSessionsCard extends StatelessWidget {
  final List<Reservation> sessions;
  const _UpcomingSessionsCard({required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Aucune session prévue'),
        ),
      );
    }

    return Column(
      children: sessions
          .map(
            (s) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                leading: const Icon(
                  Icons.event,
                  size: 20,
                  color: Colors.blueGrey,
                ),
                title: Text(s.clientName),
                subtitle: Text(
                  '${s.date.day}/${s.date.month} - ${s.slot.name.toUpperCase()}',
                ),
                trailing: const Icon(Icons.chevron_right, size: 16),
              ),
            ),
          )
          .toList(),
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
