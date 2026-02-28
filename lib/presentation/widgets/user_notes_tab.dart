import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_notifier.dart';
import '../../domain/models/user.dart';
import '../../domain/models/staff.dart';
import '../providers/staff_notifier.dart';
import '../../l10n/app_localizations.dart';

class UserNotesTab extends ConsumerWidget {
  final User user;
  const UserNotesTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notes = user.progress?.notes ?? [];

    return Column(
      children: [
        Expanded(
          child: notes.isEmpty
              ? Center(child: Text(l10n.noNotesYet))
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
                            name: l10n.unknownInstructor,
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
                          l10n.instructorLabel(instructorName),
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
            label: Text(l10n.addLessonNote),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contentController = TextEditingController();
    String? selectedStaffId;

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final staff = ref.watch(staffNotifierProvider).value ?? [];
          return AlertDialog(
            title: Text(l10n.sessionFeedback),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: l10n.instructor),
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
                  decoration: InputDecoration(
                    labelText: l10n.observations,
                    hintText: l10n.observationsHint,
                  ),
                  maxLines: 3,
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
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
