import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/staff.dart';
import '../providers/staff_notifier.dart';

class StaffAdminScreen extends ConsumerWidget {
  const StaffAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du Staff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStaffDialog(context, ref),
          ),
        ],
      ),
      body: staffAsync.when(
        data: (staffList) => ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: staff.photoUrl.isNotEmpty
                    ? NetworkImage(staff.photoUrl)
                    : null,
                child: staff.photoUrl.isEmpty ? const Icon(Icons.person) : null,
              ),
              title: Text(
                staff.id,
              ), // En attendant un champ 'name' ou 'displayName'
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
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  void _showStaffDialog(BuildContext context, WidgetRef ref, {Staff? staff}) {
    final isEditing = staff != null;
    final bioController = TextEditingController(text: staff?.bio);
    final specialtiesController = TextEditingController(
      text: staff?.specialties.join(', '),
    );
    final photoController = TextEditingController(text: staff?.photoUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Modifier Moniteur' : 'Ajouter Moniteur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              TextField(
                controller: specialtiesController,
                decoration: const InputDecoration(
                  labelText: 'Spécialités (virgule)',
                ),
              ),
              TextField(
                controller: photoController,
                decoration: const InputDecoration(labelText: 'Photo URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStaff = Staff(
                id: staff?.id ?? const Uuid().v4(),
                bio: bioController.text,
                photoUrl: photoController.text,
                specialties: specialtiesController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                updatedAt: DateTime.now(),
              );

              if (isEditing) {
                ref.read(staffNotifierProvider.notifier).updateStaff(newStaff);
              } else {
                ref.read(staffNotifierProvider.notifier).addStaff(newStaff);
              }
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Enregistrer' : 'Ajouter'),
          ),
        ],
      ),
    );
  }
}
