import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/equipment_assignment.dart';
import '../../domain/models/equipment_booking.dart';
import '../../domain/models/equipment_with_availability.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../providers/auth_state_provider.dart';
import '../providers/equipment_assignment_notifier.dart';
import '../providers/equipment_availability_notifier.dart';
import '../providers/equipment_booking_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../providers/theme_notifier.dart';
import '../providers/user_notifier.dart';
import '../widgets/equipment_category_filter.dart';

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
  final List<String> _selectedEquipmentIds = [];
  String? _selectedCategory;
  AsyncValue<List<EquipmentAssignment>>? _assignmentsAsync;

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.pupil.progress?.checklist ?? []);

    final uniqueLevels = UserProgress.ikoSkillsByLevel.keys.toSet().toList();
    _selectedLevel = widget.pupil.progress?.ikoLevel ?? uniqueLevels.first;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Affiche l'équipement assigné dans un dialog
  void _showAssignedEquipment() {
    final l10n = AppLocalizations.of(context);

    _assignmentsAsync?.whenData((assignments) {
      final studentAssignments = assignments
          .where((a) => a.studentId == widget.pupil.id)
          .toList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.inventory_2),
              SizedBox(width: 8),
              Text('Matériel assigné'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: studentAssignments.isEmpty
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Aucun matériel assigné pour cet élève'),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...studentAssignments.map((assignment) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(_getCategoryIcon(assignment.equipmentType)),
                          ),
                          title: Text('${assignment.equipmentBrand} ${assignment.equipmentModel}'),
                          subtitle: Text('${assignment.equipmentSize}m²'),
                          trailing: Chip(
                            label: Text(
                              assignment.status.name,
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                            backgroundColor: _getStatusColor(assignment.status),
                          ),
                        ),
                      )),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
          ],
        ),
      );
    });
  }

  // Libère le matériel après la séance
  void _releaseEquipment(EquipmentAssignment assignment) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Libérer le matériel'),
        content: Text(
          'Confirmer la libération de :\n${assignment.equipmentBrand} ${assignment.equipmentModel} - ${assignment.equipmentSize}m² ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Libérer'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(equipmentAssignmentNotifierProvider(widget.reservation.id).notifier)
          .completeAssignment(assignment.id, widget.reservation.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matériel libéré avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Color _getStatusColor(EquipmentAssignmentStatus status) {
    switch (status) {
      case EquipmentAssignmentStatus.pending:
        return Colors.orange;
      case EquipmentAssignmentStatus.confirmed:
        return Colors.green;
      case EquipmentAssignmentStatus.cancelled:
        return Colors.grey;
      case EquipmentAssignmentStatus.completed:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'kite':
        return Icons.kitesurfing;
      case 'foil':
        return Icons.surfing;
      case 'board':
        return Icons.directions_bike;
      case 'harness':
        return Icons.security;
      default:
        return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    // Watch equipment assignments for this session
    _assignmentsAsync = ref.watch(
      equipmentAssignmentNotifierProvider(widget.reservation.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.validationTitle(widget.pupil.displayName)),
        actions: [
          // Bouton pour voir/modifier l'équipement assigné
          IconButton(
            icon: const Icon(Icons.inventory_2),
            tooltip: 'Équipement assigné',
            onPressed: () => _showAssignedEquipment(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Équipement assigné (visible directement)
            _assignmentsAsync!.when(
              data: (assignments) {
                if (assignments.isEmpty) return const SizedBox.shrink();
                
                final studentAssignments = assignments
                    .where((a) => a.studentId == widget.pupil.id)
                    .toList();
                
                if (studentAssignments.isEmpty) return const SizedBox.shrink();

                return Card(
                  color: primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.inventory_2, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Matériel assigné',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...studentAssignments.map((assignment) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${assignment.equipmentBrand} ${assignment.equipmentModel} - ${assignment.equipmentSize}m²',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (assignment.status == EquipmentAssignmentStatus.confirmed)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  tooltip: 'Libérer le matériel',
                                  onPressed: () => _releaseEquipment(assignment),
                                ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

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
            // Filtre par catégorie
            EquipmentCategoryFilter(
              selectedCategoryId: _selectedCategory,
              onCategorySelected: (categoryId) {
                setState(() => _selectedCategory = categoryId);
              },
            ),
            const SizedBox(height: 16),
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
              selectedCategory: _selectedCategory,
              selectedDate: widget.reservation.date,
              selectedSlot: EquipmentBookingSlot.morning,
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

    if (_selectedEquipmentIds.isNotEmpty) {
      try {
        final currentUserId = ref.read(currentUserProvider).value?.id;
        if (currentUserId != null) {
          for (final equipmentId in _selectedEquipmentIds) {
            final equipment = ref
                .read(equipmentNotifierProvider)
                .value
                ?.firstWhere((e) => e.id == equipmentId);

            if (equipment != null) {
              await ref
                  .read(
                    equipmentBookingNotifierProvider(currentUserId).notifier,
                  )
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
        final uniqueAvailable = items
            .where((e) => e.status == EquipmentStatus.available)
            .fold<Map<String, Equipment>>(
              {},
              (map, equipment) {
                map[equipment.id] = equipment;
                return map;
              },
            ).values.toList();

        return Column(
          children: [
            Builder(
              builder: (context) {
                return DropdownButtonFormField<String>(
                  value: _selectedEquipId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: l10n.selectEquipmentIssue,
                    border: const OutlineInputBorder(),
                  ),
                  items: uniqueAvailable
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text('${e.brand} ${e.model} (${e.size})'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedEquipId = val),
                );
              },
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
/// Module similaire à EquipmentBookingScreen (ligne ~194)
class _EquipmentReservationSection extends ConsumerWidget {
  final List<String> selectedEquipmentIds;
  final ValueChanged<String> onEquipmentSelected;
  final ValueChanged<String> onEquipmentRemoved;
  final String? selectedCategory;
  final DateTime selectedDate;
  final EquipmentBookingSlot selectedSlot;

  const _EquipmentReservationSection({
    required this.selectedEquipmentIds,
    required this.onEquipmentSelected,
    required this.onEquipmentRemoved,
    this.selectedCategory,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return equipmentAsync.when(
      data: (equipment) {
        // Filtrer par catégorie si sélectionnée
        final filtered = selectedCategory != null
            ? equipment.where((e) => e.categoryId == selectedCategory).toList()
            : equipment;

        final available = filtered
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
                        final eq = available.firstWhere(
                          (e) => e.id == equipId,
                          orElse: () => equipment.first,
                        );
                        return Chip(
                          label: Text(
                            '${eq.brand} ${eq.model}',
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
            ...available.map((eq) {
              return StreamBuilder<EquipmentWithAvailability>(
                stream: ref
                    .read(equipmentAvailabilityNotifierProvider.notifier)
                    .watchEquipmentAvailability(
                      equipmentId: eq.id,
                      date: selectedDate,
                      slot: selectedSlot,
                    ),
                builder: (context, snapshot) {
                  IconData categoryIcon(String categoryId) {
                    switch (categoryId.toLowerCase()) {
                      case 'kite': return Icons.kitesurfing;
                      case 'foil': return Icons.surfing;
                      case 'board': return Icons.directions_bike;
                      case 'harness': return Icons.security;
                      default: return Icons.inventory_2;
                    }
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Chargement...'),
                    );
                  }

                  if (snapshot.hasError) {
                    return ListTile(
                      leading: const Icon(Icons.error, color: Colors.red),
                      title: Text('Erreur: ${snapshot.error}'),
                    );
                  }

                  final availability = snapshot.data;
                  if (availability == null) {
                    return const SizedBox.shrink();
                  }

                  final isAvailable = availability.isAvailable;
                  final alreadySelected = selectedEquipmentIds.contains(eq.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isAvailable
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.errorContainer,
                        child: Icon(
                          categoryIcon(eq.categoryId),
                          color: isAvailable
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      title: Text('${eq.brand} ${eq.model}'),
                      subtitle: Text(
                        isAvailable
                            ? '${eq.size}m² - ${l10n.available}'
                            : '${eq.size}m² - ${l10n.unavailable}',
                        style: TextStyle(
                          color: isAvailable
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: isAvailable && !alreadySelected
                          ? IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: primaryColor,
                              onPressed: () => onEquipmentSelected(eq.id),
                            )
                          : alreadySelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : null,
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Text(l10n.errorLoadingEquipment),
    );
  }
}
