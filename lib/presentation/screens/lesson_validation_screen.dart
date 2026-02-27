import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../providers/auth_state_provider.dart';
import '../providers/user_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../../domain/models/equipment.dart';
import '../../l10n/app_localizations.dart';

class LessonValidationScreen extends ConsumerStatefulWidget {
  final Reservation reservation;
  final User pupil;

  const LessonValidationScreen({
    super.key,
    required this.reservation,
    required this.pupil,
  });

  @override
  ConsumerState<LessonValidationScreen> createState() =>
      _LessonValidationScreenState();
}

class _LessonValidationScreenState
    extends ConsumerState<LessonValidationScreen> {
  final _noteController = TextEditingController();
  final List<String> _selectedItems = [];
  String _selectedLevel = UserProgress.ikoSkillsByLevel.keys.first;

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.pupil.progress?.checklist ?? []);
    _selectedLevel = widget.pupil.progress?.ikoLevel ?? UserProgress.ikoSkillsByLevel.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.validationTitle(widget.pupil.displayName))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.skillsValidatedToday,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...UserProgress.ikoSkillsByLevel.entries.map((entry) {
              final level = entry.key;
              final skills = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skills.map((item) {
                        final isSelected = _selectedItems.contains(item);
                        return FilterChip(
                          label: Text(item),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedItems.add(item);
                              } else {
                                _selectedItems.remove(item);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
            Text(
              l10n.ikoGlobalLevel,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedLevel,
              items: UserProgress.ikoSkillsByLevel.keys
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLevel = val!),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.pedagogicalNote,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: l10n.sessionNoteHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            Text(
              l10n.materialIncident,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _EquipmentIncidentSection(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.validateProgress),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final instructorId = ref.read(currentUserProvider).value?.id ?? 'unknown';

    // Sauvegarder tout en bloc pour éviter les race conditions
    await ref
        .read(userNotifierProvider.notifier)
        .saveLessonProgress(
          userId: widget.pupil.id,
          progress: UserProgress(
            ikoLevel: _selectedLevel,
            checklist: _selectedItems,
            notes: widget.pupil.progress?.notes ?? [],
          ),
          newNote: _noteController.text.isNotEmpty
              ? UserNote(
                  date: DateTime.now(),
                  content: _noteController.text,
                  instructorId: instructorId,
                )
              : null,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.progressSaved)),
      );
      Navigator.pop(context);
    }
  }
}

class _EquipmentIncidentSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_EquipmentIncidentSection> createState() =>
      __EquipmentIncidentSectionState();
}

class __EquipmentIncidentSectionState
    extends ConsumerState<_EquipmentIncidentSection> {
  String? _selectedEquipId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final equipAsync = ref.watch(equipmentNotifierProvider);

    return equipAsync.when(
      data: (items) {
        final available = items
            .where((e) => e.status == EquipmentStatus.available)
            .toList();

        return Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedEquipId,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: l10n.selectEquipmentIssue,
                border: const OutlineInputBorder(),
              ),
              items: available
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text('${e.brand} ${e.model} (${e.size})'),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedEquipId = val),
            ),
            if (_selectedEquipId != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateStatus(EquipmentStatus.maintenance),
                      icon: const Icon(Icons.build, size: 16),
                      label: Text(l10n.maintenance),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateStatus(EquipmentStatus.damaged),
                      icon: const Icon(Icons.report_problem, size: 16),
                      label: Text(l10n.damaged),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => Text(l10n.errorLoadingEquipment),
    );
  }

  void _updateStatus(EquipmentStatus status) {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedEquipId == null) return;
    ref
        .read(equipmentNotifierProvider.notifier)
        .updateStatus(_selectedEquipId!, status);
    setState(() => _selectedEquipId = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.equipmentStatusUpdated)),
    );
  }
}
