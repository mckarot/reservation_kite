import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/staff.dart';
import '../providers/staff_notifier.dart';
import '../providers/unavailability_notifier.dart';
import '../../domain/models/staff_unavailability.dart';
import '../../domain/models/reservation.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class StaffAdminScreen extends ConsumerWidget {
  const StaffAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final staffAsync = ref.watch(staffNotifierProvider);
    final unavailabilitiesAsync = ref.watch(unavailabilityNotifierProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.staffManagement),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.group), text: l10n.staffTab),
              Tab(icon: const Icon(Icons.event_busy), text: l10n.absencesTab),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showStaffDialog(context, ref),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1: Staff List
            staffAsync.when(
              data: (staffList) => ListView.builder(
                itemCount: staffList.length,
                itemBuilder: (context, index) {
                  final staff = staffList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: staff.photoUrl.isNotEmpty
                          ? NetworkImage(staff.photoUrl)
                          : null,
                      child: staff.photoUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(staff.name),
                    subtitle: Text(staff.specialties.join(', ')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showStaffDialog(context, ref, staff: staff),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => ref
                              .read(staffNotifierProvider.notifier)
                              .deleteStaff(staff.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('${l10n.errorLabel}: $err')),
            ),
            // Tab 2: Absence Requests
            unavailabilitiesAsync.when(
              data: (list) {
                final pending = list
                    .where((u) => u.status == UnavailabilityStatus.pending)
                    .toList();
                final others = list
                    .where((u) => u.status != UnavailabilityStatus.pending)
                    .toList();

                final allStaff = staffAsync.value ?? [];

                return ListView(
                  children: [
                    if (pending.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          l10n.pendingHeader,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
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
                        return ListTile(
                          title: Text(
                            '${staff.name} - ${DateFormat('dd/MM').format(u.date)} (${u.slot == TimeSlot.fullDay ? l10n.slotFullDay : (u.slot == TimeSlot.morning ? l10n.slotMorning : l10n.slotAfternoon)})',
                          ),
                          subtitle: Text('${l10n.reasonLabel}: ${u.reason}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () => ref
                                    .read(
                                      unavailabilityNotifierProvider.notifier,
                                    )
                                    .updateStatus(
                                      u.id,
                                      UnavailabilityStatus.approved,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () => ref
                                    .read(
                                      unavailabilityNotifierProvider.notifier,
                                    )
                                    .updateStatus(
                                      u.id,
                                      UnavailabilityStatus.rejected,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    if (others.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          l10n.historyHeader,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ...others.map((u) {
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
                        return ListTile(
                          title: Text(
                            '${staff.name} - ${DateFormat('dd/MM').format(u.date)} (${u.slot == TimeSlot.fullDay ? l10n.slotFullDay : (u.slot == TimeSlot.morning ? l10n.slotMorning : l10n.slotAfternoon)})',
                          ),
                          subtitle: Text(u.reason),
                          trailing: _StatusBadge(status: u.status),
                        );
                      }),
                    ],
                    if (pending.isEmpty && others.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(l10n.noRequests),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
            ),
          ],
        ),
      ),
    );
  }

  void _showStaffDialog(BuildContext context, WidgetRef ref, {Staff? staff}) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = staff != null;
    final nameController = TextEditingController(text: staff?.name);
    final bioController = TextEditingController(text: staff?.bio);
    final specialtiesController = TextEditingController(
      text: staff?.specialties.join(', '),
    );
    final photoController = TextEditingController(text: staff?.photoUrl);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? l10n.editInstructor : l10n.addInstructor),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.fullName),
              ),
              TextField(
                controller: bioController,
                decoration: InputDecoration(labelText: l10n.bio),
                maxLines: 3,
              ),
              TextField(
                controller: specialtiesController,
                decoration: InputDecoration(
                  labelText: l10n.specialtiesHint,
                ),
              ),
              TextField(
                controller: photoController,
                decoration: InputDecoration(labelText: l10n.photoUrl),
              ),
              if (!isEditing) ...[
                const Divider(height: 32),
                Text(
                  l10n.loginCredentials,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: l10n.emailLabel),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.passwordHint6,
                  ),
                  obscureText: true,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!isEditing) {
                // Création complète
                await ref
                    .read(staffNotifierProvider.notifier)
                    .addStaffWithAccount(
                      name: nameController.text,
                      email: emailController.text.trim(),
                      password: passwordController.text,
                      bio: bioController.text,
                      photoUrl: photoController.text,
                      specialties: specialtiesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                    );
              } else {
                // Mise à jour profil uniquement
                final newStaff = staff.copyWith(
                  name: nameController.text,
                  bio: bioController.text,
                  photoUrl: photoController.text,
                  specialties: specialtiesController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  updatedAt: DateTime.now(),
                );
                await ref
                    .read(staffNotifierProvider.notifier)
                    .updateStaff(newStaff);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEditing ? l10n.saveButton : l10n.addButton),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final UnavailabilityStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    switch (status) {
      case UnavailabilityStatus.pending:
        color = Colors.orange;
        label = l10n.statusPending;
        break;
      case UnavailabilityStatus.approved:
        color = Colors.green;
        label = l10n.statusApproved;
        break;
      case UnavailabilityStatus.rejected:
        color = Colors.red;
        label = l10n.statusRejected;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
