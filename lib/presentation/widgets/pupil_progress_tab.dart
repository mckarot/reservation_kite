import 'package:flutter/material.dart';
import '../../domain/models/user.dart';

class PupilProgressTab extends StatelessWidget {
  final User user;
  const PupilProgressTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final notes = user.progress?.notes ?? [];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Checklist IKO'),
              Tab(text: 'Feedbacks Sessions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _IKOListView(user: user),
            _NotesListView(notes: notes),
          ],
        ),
      ),
    );
  }
}

class _IKOListView extends StatelessWidget {
  final User user;
  const _IKOListView({required this.user});

  static const List<String> ikoSkills = [
    'Découverte (Niveau 1)',
    'Pilotage de base',
    'Décollage / Atterrissage',
    'Nage tractée (Niveau 2)',
    'Waterstart',
    'Navigation (Niveau 3)',
    'Remontée au vent',
    'Transitions / Sauts',
  ];

  @override
  Widget build(BuildContext context) {
    final checked = user.progress?.checklist ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ikoSkills.length,
      itemBuilder: (context, index) {
        final skill = ikoSkills[index];
        final isCompleted = checked.contains(skill);
        return ListTile(
          leading: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          title: Text(
            skill,
            style: TextStyle(color: isCompleted ? Colors.black : Colors.grey),
          ),
        );
      },
    );
  }
}

class _NotesListView extends StatelessWidget {
  final List<UserNote> notes;
  const _NotesListView({required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(
        child: Text('Tes moniteurs n\'ont pas encore posté de notes.'),
      );
    }

    // Plus récentes en premier
    final sortedNotes = List<UserNote>.from(notes)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedNotes.length,
      itemBuilder: (context, index) {
        final note = sortedNotes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${note.date.day}/${note.date.month}/${note.date.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Instructor: ${note.instructorId}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(note.content, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        );
      },
    );
  }
}
