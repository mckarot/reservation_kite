import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_notifier.dart';
import '../../domain/models/user.dart';

class UserProgressTab extends ConsumerWidget {
  final User user;
  const UserProgressTab({super.key, required this.user});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = user.progress ?? const UserProgress();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Niveau IKO actuel : ${progress.ikoLevel ?? "Non défini"}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          const Text(
            'Checklist de progression',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ...ikoSkills.map((skill) {
            final isChecked = progress.checklist.contains(skill);
            return CheckboxListTile(
              title: Text(skill),
              value: isChecked,
              onChanged: (val) {
                final newChecklist = List<String>.from(progress.checklist);
                if (val == true) {
                  newChecklist.add(skill);
                } else {
                  newChecklist.remove(skill);
                }
                ref
                    .read(userNotifierProvider.notifier)
                    .updateProgress(
                      user.id,
                      progress.copyWith(checklist: newChecklist),
                    );
              },
            );
          }),
        ],
      ),
    );
  }
}
