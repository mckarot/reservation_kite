import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/user.dart';
import '../providers/user_notifier.dart';
import '../providers/session_notifier.dart';
import '../providers/equipment_notifier.dart';
import '../../domain/models/equipment.dart';

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
  String _selectedLevel = 'Niveau 1';

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.pupil.progress?.checklist ?? []);
    _selectedLevel = widget.pupil.progress?.ikoLevel ?? 'Niveau 1';
  }

  @override
  Widget build(BuildContext context) {
    final allItems = [
      'Préparer son aile',
      'Systèmes de sécurité',
      'Pilotage zone neutre',
      'Décollage / Atterrissage',
      'Body drag',
      'Water start',
      'Remonter au vent',
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Validation : ${widget.pupil.displayName}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compétences validées aujourd\'hui',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allItems.map((item) {
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
            const SizedBox(height: 32),
            const Text(
              'Niveau IKO Global',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedLevel,
              items: [
                'Niveau 1',
                'Niveau 2',
                'Niveau 3',
                'Niveau 4',
              ].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (val) => setState(() => _selectedLevel = val!),
            ),
            const SizedBox(height: 32),
            const Text(
              'Note pédagogique',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Comment s\'est passée la séance ?',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            const Text(
              'Incident Matériel ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: const Text('Valider la progression'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final instructorId = ref.read(sessionNotifierProvider) ?? 'unknown';

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
        const SnackBar(content: Text('Progression enregistrée !')),
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
              decoration: const InputDecoration(
                hintText: 'Sélectionner le matériel avec un souci',
                border: OutlineInputBorder(),
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
                      label: const Text('Maintenance'),
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
                      label: const Text('HS'),
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
      error: (_, __) => const Text('Erreur chargement matériel'),
    );
  }

  void _updateStatus(EquipmentStatus status) {
    if (_selectedEquipId == null) return;
    ref
        .read(equipmentNotifierProvider.notifier)
        .updateStatus(_selectedEquipId!, status);
    setState(() => _selectedEquipId = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statut matériel mis à jour !')),
    );
  }
}
