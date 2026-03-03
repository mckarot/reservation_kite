import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../providers/auth_state_provider.dart';
import '../providers/equipment_booking_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../providers/theme_notifier.dart';
import '../providers/user_notifier.dart';

class LessonValidationScreen extends ConsumerStatefulWidget {
  final Reservation reservation;
  final User pupil;

  const LessonValidationScreen({
    required this.reservation, required this.pupil, super.key,
  });

  @override
  ConsumerState<LessonValidationScreen> createState() =>
      _LessonValidationScreenState();
}

class _LessonValidationScreenState
    extends ConsumerState<LessonValidationScreen> {
  final _noteController = TextEditingController();
  final List<String> _selectedItems = [];
  String? _selectedLevel; // ← Nullable pour éviter le doublon
  final List<String> _selectedEquipmentIds = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.pupil.progress?.checklist ?? []);
    
    // Utiliser la première clé UNIQUE (sans doublons)
    final uniqueLevels = UserProgress.ikoSkillsByLevel.keys.toSet().toList();
    _selectedLevel = widget.pupil.progress?.ikoLevel ?? uniqueLevels.first;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Récupérer les couleurs du thème dynamique
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.validationTitle(widget.pupil.displayName)),
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
            Text(
              l10n.ikoGlobalLevel,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Remplacer le Dropdown par des Radio pour éviter les doublons
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
            }).toList(),
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
            
            // Section réservation de matériel pour la séance
            const SizedBox(height: 32),
            Text(
              l10n.reserveEquipment,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _EquipmentReservationSection(
              selectedEquipmentIds: _selectedEquipmentIds,
              onEquipmentSelected: (equipmentId) {
                setState(() {
                  if (!_selectedEquipmentIds.contains(equipmentId)) {
                    _selectedEquipmentIds.add(equipmentId);
                  }
                });
              },
              onEquipmentRemoved: (equipmentId) {
                setState(() {
                  _selectedEquipmentIds.remove(equipmentId);
                });
              },
            ),
            
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
    final l10n = AppLocalizations.of(context);
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

    // Réserver le matériel sélectionné pour cette séance
    if (_selectedEquipmentIds.isNotEmpty) {
      try {
        final currentUserId = ref.read(currentUserProvider).value?.id;
        if (currentUserId != null) {
          for (final equipmentId in _selectedEquipmentIds) {
            // Récupérer les détails de l'équipement
            final equipment = ref
                .read(equipmentNotifierProvider)
                .value
                ?.firstWhere((e) => e.id == equipmentId);

            if (equipment != null) {
              await ref
                  .read(equipmentBookingNotifierProvider(currentUserId).notifier)
                  .createBooking(
                    equipmentId: equipment.id,
                    equipmentType: equipment.categoryId,
                    equipmentBrand: equipment.brand,
                    equipmentModel: equipment.model,
                    equipmentSize: equipment.size,
                    date: widget.reservation.date,
                    slot: EquipmentBookingSlot.morning,
                  );
            }
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.equipmentReserved),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.equipmentReservationFailed}: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.progressSaved)));
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
    final l10n = AppLocalizations.of(context);
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
    final l10n = AppLocalizations.of(context);
    if (_selectedEquipId == null) return;
    ref
        .read(equipmentNotifierProvider.notifier)
        .updateStatus(_selectedEquipId!, status);
    setState(() => _selectedEquipId = null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.equipmentStatusUpdated)));
  }
}

/// Section pour réserver du matériel lors de la validation d'une séance
class _EquipmentReservationSection extends ConsumerWidget {
  final List<String> selectedEquipmentIds;
  final ValueChanged<String> onEquipmentSelected;
  final ValueChanged<String> onEquipmentRemoved;

  const _EquipmentReservationSection({
    required this.selectedEquipmentIds,
    required this.onEquipmentSelected,
    required this.onEquipmentRemoved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final equipAsync = ref.watch(equipmentNotifierProvider);

    return equipAsync.when(
      data: (items) {
        final available = items
            .where((e) => e.status == EquipmentStatus.available)
            .toList();

        if (available.isEmpty) {
          return Text(
            l10n.noEquipmentAvailable,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Équipements sélectionnés
            if (selectedEquipmentIds.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectedEquipment,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedEquipmentIds.map((equipId) {
                        final equipment = available.firstWhere(
                          (e) => e.id == equipId,
                          orElse: () => items.first,
                        );
                        return Chip(
                          label: Text(
                            '${equipment.brand} ${equipment.model}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => onEquipmentRemoved(equipId),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Dropdown pour sélectionner du matériel
            DropdownButtonFormField<String>(
              value: null,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: l10n.selectEquipmentForSession,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.add_circle_outline),
              ),
              items: available
                  .where((e) => !selectedEquipmentIds.contains(e.id))
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text('${e.brand} ${e.model} (${e.size})'),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  onEquipmentSelected(val);
                }
              },
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => Text(l10n.errorLoadingEquipment),
    );
  }
}
