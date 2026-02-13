import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_notifier.dart';
import '../../domain/models/user.dart';
import '../widgets/user_progress_tab.dart';
import '../widgets/user_notes_tab.dart';

class UserDetailScreen extends ConsumerWidget {
  final String userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userNotifierProvider);

    return usersAsync.when(
      data: (users) {
        final user = users.firstWhere((u) => u.id == userId);
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(user.displayName),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.person), text: 'Profil'),
                  Tab(icon: Icon(Icons.trending_up), text: 'Progrès'),
                  Tab(icon: Icon(Icons.history_edu), text: 'Notes'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _ProfileTab(user: user, userId: userId),
                UserProgressTab(user: user),
                UserNotesTab(user: user),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Erreur: $err'))),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  final User user;
  final String userId;
  const _ProfileTab({required this.user, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              child: Text(
                user.displayName.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _InfoTile(label: 'Nom', value: user.displayName),
          _InfoTile(label: 'Email', value: user.email),
          const Divider(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solde actuel',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${user.walletBalance} crédits',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: () =>
                    _showTopUpDialog(context, ref, user.walletBalance),
                icon: const Icon(Icons.add_card),
                label: const Text('Créditer'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTopUpDialog(
    BuildContext context,
    WidgetRef ref,
    int currentBalance,
  ) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter des crédits'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(labelText: 'Nombre de sessions'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                ref
                    .read(userNotifierProvider.notifier)
                    .updateBalance(userId, currentBalance + amount);
              }
              Navigator.pop(context);
            },
            child: const Text('Confirmer le paiement'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
