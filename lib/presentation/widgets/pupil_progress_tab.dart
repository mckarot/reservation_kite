import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user.dart';

class PupilProgressTab extends ConsumerWidget {
  final User user;
  const PupilProgressTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = user.progress ?? const UserProgress();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LevelCard(ikoLevel: progress.ikoLevel ?? 'Niveau 1'),
          const SizedBox(height: 24),
          const Text(
            'MES ACQUISITIONS',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          _ChecklistSection(checkedItems: progress.checklist),
          const SizedBox(height: 32),
          const Text(
            'NOTES DU MONITEUR',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          if (progress.notes.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Aucune note pour le moment.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...progress.notes.reversed.map((n) => _NoteCard(note: n)),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String ikoLevel;
  const _LevelCard({required this.ikoLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Niveau Actuel',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            ikoLevel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.4, // TODO: Dynamiser selon la checklist
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.cyanAccent,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  final List<String> checkedItems;
  const _ChecklistSection({required this.checkedItems});

  @override
  Widget build(BuildContext context) {
    // Liste simplifiée IKO
    final allItems = [
      'Préparer son aile',
      'Systèmes de sécurité',
      'Pilotage zone neutre',
      'Décollage / Atterrissage',
      'Body drag',
      'Water start',
      'Remonter au vent',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allItems.map((item) {
        final isDone = checkedItems.contains(item);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDone ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDone ? Colors.green.shade200 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.circle_outlined,
                size: 16,
                color: isDone ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                item,
                style: TextStyle(
                  fontSize: 12,
                  color: isDone ? Colors.green.shade900 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final UserNote note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: Colors.indigo,
                  ),
                ),
                Text(
                  'Par ${note.instructorId}', // TODO: Mapper ID -> Nom
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(note.content, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}
