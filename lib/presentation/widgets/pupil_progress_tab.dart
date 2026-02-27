import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user.dart';
import '../providers/staff_notifier.dart';
import '../../l10n/app_localizations.dart';

class PupilProgressTab extends ConsumerWidget {
  final User user;
  const PupilProgressTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final progress = user.progress ?? const UserProgress();
    final staffAsync = ref.watch(staffNotifierProvider);
    final staffList = staffAsync.value ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LevelCard(
            ikoLevel: progress.ikoLevel ?? l10n.defaultIkoLevel,
            checkedItemsCount: progress.checklist.length,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.myAcquisitions,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _ChecklistSection(checkedItems: progress.checklist),
          const SizedBox(height: 32),
          Text(
            l10n.instructorNotes,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          if (progress.notes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  l10n.noNotesYet,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...progress.notes.reversed.map((n) {
              final instructor = staffList
                  .where((s) => s.id == n.instructorId)
                  .firstOrNull;
              return _NoteCard(
                note: n,
                instructorName: instructor?.name ?? n.instructorId,
              );
            }),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String ikoLevel;
  final int checkedItemsCount;
  const _LevelCard({required this.ikoLevel, required this.checkedItemsCount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.currentLevel,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
              value: UserProgress.allIkoSkills.isEmpty
                  ? 0
                  : checkedItemsCount / UserProgress.allIkoSkills.length,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: UserProgress.ikoSkillsByLevel.entries.map((entry) {
        final levelName = entry.key;
        final skills = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                levelName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((item) {
                final isDone = checkedItems.contains(item);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDone
                          ? Colors.green.shade200
                          : Colors.grey.shade300,
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
                          fontSize: 11,
                          color: isDone
                              ? Colors.green.shade900
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final UserNote note;
  final String instructorName;
  const _NoteCard({required this.note, required this.instructorName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.byInstructor(instructorName),
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
