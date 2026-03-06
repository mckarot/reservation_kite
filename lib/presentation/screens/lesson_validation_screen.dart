import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../providers/auth_state_provider.dart';
import '../providers/theme_notifier.dart';
import '../providers/user_notifier.dart';
import '../widgets/equipment_assignment_widget.dart';

class LessonValidationScreen extends ConsumerStatefulWidget {
  final Reservation reservation;
  final User pupil;

  const LessonValidationScreen({
    required this.reservation,
    required this.pupil,
    super.key,
  });

  @override
  ConsumerState<LessonValidationScreen> createState() =>
      _LessonValidationScreenState();
}

class _LessonValidationScreenState
    extends ConsumerState<LessonValidationScreen> {
  final _noteController = TextEditingController();
  final List<String> _selectedItems = [];
  String? _selectedLevel;
  bool _equipmentAssigned = false;

  Color get primaryColor {
    final themeSettings = ref.read(themeNotifierProvider).value;
    return themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
  }

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.pupil.progress?.checklist ?? []);

    final uniqueLevels = UserProgress.ikoSkillsByLevel.keys.toSet().toList();
    _selectedLevel = widget.pupil.progress?.ikoLevel ?? uniqueLevels.first;

    // Vérifier si le matériel est déjà assigné
    _equipmentAssigned = !widget.reservation.equipmentAssignmentRequired;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    // Vérifier si le matériel est requis mais non assigné
    final equipmentRequired = widget.reservation.equipmentAssignmentRequired;
    final canValidate = !equipmentRequired || _equipmentAssigned;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.validationTitle(widget.pupil.displayName)),
            if (equipmentRequired && !_equipmentAssigned) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Matériel requis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
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
                        color: primaryColor,
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
            }),
            const SizedBox(height: 32),
            // Section assignment de matériel
            if (equipmentRequired || !_equipmentAssigned) ...[
              EquipmentAssignmentWidget(
                reservationId: widget.reservation.id,
                studentId: widget.pupil.id,
                studentName: widget.pupil.displayName,
                studentEmail: widget.pupil.email ?? '',
                date: widget.reservation.date,
                slot: widget.reservation.slot,
                onEquipmentAssigned: () {
                  setState(() {
                    _equipmentAssigned = true;
                  });
                },
              ),
              const SizedBox(height: 24),
            ],
            Text(
              l10n.ikoGlobalLevel,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...UserProgress.ikoSkillsByLevel.keys.toSet().map((level) {
              return RadioListTile<String>(
                title: Text(level),
                value: level,
                groupValue: _selectedLevel,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedLevel = val);
                  }
                },
              );
            }),
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
            const SizedBox(height: 40),
            if (!canValidate)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Vous devez assigner un matériel avant de valider cette session.',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: canValidate ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canValidate
                      ? Colors.green.shade700
                      : Colors.grey,
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
    final l10n = AppLocalizations.of(context);
    final instructorId = ref.read(currentUserProvider).value?.id ?? 'unknown';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.progressSaved)));
      Navigator.pop(context);
    }
  }
}
