import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_notifier.dart';
import '../../domain/models/user.dart';
import '../../domain/models/staff.dart';
import '../providers/staff_notifier.dart';

class UserNotesTab extends ConsumerWidget {
  final User user;
  const UserNotesTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = user.progress?.notes ?? [];

    return Column(
      children: [
        Expanded(
          child: notes.isEmpty
              ? const Center(child: Text('Aucune note pour le moment'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note =
                        notes[notes.length -
                            1 -
                            index]; // Inverser pour voir les plus récentes

                    final staff = ref.watch(staffNotifierProvider).value ?? [];
                    final instructorName = staff
                        .firstWhere(
                          (s) => s.id == note.instructorId,
                          orElse: () => Staff(
                            id: note.instructorId,
                            name: 'Moniteur Inconnu',
                            bio: '',
                            photoUrl: '',
                            updatedAt: DateTime.now(),
                          ),
                        )
                        .name;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          '${note.date.day}/${note.date.month}/${note.date.year}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(note.content),
                        trailing: Text(
                          'Moniteur: $instructorName',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _showAddNoteDialog(context, ref),
            icon: const Icon(Icons.add_comment),
            label: const Text('Ajouter une note de cours'),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final contentController = TextEditingController();
    String? selectedStaffId;

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final staff = ref.watch(staffNotifierProvider).value ?? [];
          return AlertDialog(
            title: const Text('Feedback de session'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Moniteur'),
                  items: staff
                      .map(
                        (s) =>
                            DropdownMenuItem(value: s.id, child: Text(s.name)),
                      )
                      .toList(),
                  onChanged: (val) => selectedStaffId = val,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Observations',
                    hintText: 'ex: Bonne progression waterstart...',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedStaffId != null &&
                      contentController.text.isNotEmpty) {
                    final note = UserNote(
                      date: DateTime.now(),
                      content: contentController.text,
                      instructorId: selectedStaffId!,
                    );
                    ref
                        .read(userNotifierProvider.notifier)
                        .addNote(user.id, note);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          );
        },
      ),
    );
  }
}
