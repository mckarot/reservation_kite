import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_notifier.dart';
import '../../domain/models/user.dart';
import '../widgets/user_progress_tab.dart';
import '../widgets/user_notes_tab.dart';
import '../providers/credit_pack_notifier.dart';

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
                onPressed: () => _showTopUpOptions(context, ref),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Vendre un Pack'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTopUpOptions(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créditer le compte'),
        content: Consumer(
          builder: (context, ref, child) {
            final packsAsync = ref.watch(creditPackNotifierProvider);
            final customController = TextEditingController();

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  packsAsync.when(
                    data: (packs) {
                      if (packs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Aucun pack standard trouvé.\nUtilisez la saisie sur mesure ci-dessous.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        );
                      }
                      return Column(
                        children: packs.map((pack) {
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 8),
                            color: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.blue.shade100),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.inventory_2,
                                color: Colors.blue,
                              ),
                              title: Text(
                                pack.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${pack.credits} séances • ${pack.price}€',
                              ),
                              onTap: () {
                                ref
                                    .read(userNotifierProvider.notifier)
                                    .updateBalance(
                                      userId,
                                      user.walletBalance + pack.credits,
                                    );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Pack ${pack.name} ajouté !'),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('Erreur: $e'),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Saisie sur mesure',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: customController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de séances',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final count = int.tryParse(customController.text);
                          if (count != null && count > 0) {
                            ref
                                .read(userNotifierProvider.notifier)
                                .updateBalance(
                                  userId,
                                  user.walletBalance + count,
                                );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$count séances ajoutées !'),
                              ),
                            );
                          }
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => _showManualDialog(context, ref),
            child: const Text(
              'Ajuster le total (Admin)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: user.walletBalance.toString(),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier solde (Manuel)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nombre de séances'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBalance = int.tryParse(controller.text);
              if (newBalance == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veuillez saisir un nombre valide'),
                  ),
                );
                return;
              }
              ref
                  .read(userNotifierProvider.notifier)
                  .updateBalance(userId, newBalance);
              Navigator.pop(context); // Close manual
              Navigator.pop(context); // Close options
            },
            child: const Text('Valider'),
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
