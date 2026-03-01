import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/user.dart';
import '../providers/user_notifier.dart';
import 'user_detail_screen.dart';
import '../../l10n/app_localizations.dart';

class UserDirectoryScreen extends ConsumerWidget {
  const UserDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final usersAsync = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.studentDirectory),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddUserDialog(context, ref),
          ),
        ],
      ),
      body: usersAsync.when(
        data: (allUsers) {
          final users = allUsers.where((u) => u.role == 'student').toList();

          if (users.isEmpty) {
            return Center(child: Text(l10n.noStudentsRegistered));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1.5),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user.displayName.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(user.displayName),
                  subtitle: Text(
                    '${l10n.balanceLabel}: ${user.walletBalance} ${l10n.credits}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserDetailScreen(userId: user.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${l10n.errorLabel}: $err')),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newStudent),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.fullNameLabel),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: l10n.emailLabel),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              final newUser = User(
                id: const Uuid().v4(),
                displayName: nameController.text,
                email: emailController.text,
                createdAt: DateTime.now(),
                lastSeen: DateTime.now(),
                walletBalance: 0,
              );
              ref.read(userNotifierProvider.notifier).addUser(newUser);
              Navigator.pop(context);
            },
            child: Text(l10n.createButton),
          ),
        ],
      ),
    );
  }
}
