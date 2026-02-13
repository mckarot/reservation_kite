import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/settings.dart';
import '../providers/settings_notifier.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _morningStartController;
  late TextEditingController _morningEndController;
  late TextEditingController _afternoonStartController;
  late TextEditingController _afternoonEndController;
  late int _maxStudents;

  @override
  void initState() {
    super.initState();
    _morningStartController = TextEditingController();
    _morningEndController = TextEditingController();
    _afternoonStartController = TextEditingController();
    _afternoonEndController = TextEditingController();
  }

  @override
  void dispose() {
    _morningStartController.dispose();
    _morningEndController.dispose();
    _afternoonStartController.dispose();
    _afternoonEndController.dispose();
    super.dispose();
  }

  void _initFields(SchoolSettings settings) {
    _morningStartController.text = settings.hours.morning.start;
    _morningEndController.text = settings.hours.morning.end;
    _afternoonStartController.text = settings.hours.afternoon.start;
    _afternoonEndController.text = settings.hours.afternoon.end;
    _maxStudents = settings.maxStudentsPerInstructor;
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages École')),
      body: settingsAsync.when(
        data: (settings) {
          if (settings == null) {
            return const Center(child: Text('Erreur : Paramètres non trouvés'));
          }

          // On n'initialise qu'une fois si les champs sont vides
          if (_morningStartController.text.isEmpty) {
            _initFields(settings);
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Horaires Matin',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _morningStartController,
                        decoration: const InputDecoration(labelText: 'Début'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _morningEndController,
                        decoration: const InputDecoration(labelText: 'Fin'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Horaires Après-midi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _afternoonStartController,
                        decoration: const InputDecoration(labelText: 'Début'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _afternoonEndController,
                        decoration: const InputDecoration(labelText: 'Fin'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<int>(
                  initialValue: _maxStudents,
                  decoration: const InputDecoration(
                    labelText: 'Max élèves par moniteur',
                  ),
                  items: List.generate(10, (i) => i + 1)
                      .map(
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(i.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _maxStudents = val!),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newSettings = settings.copyWith(
                        hours: OpeningHours(
                          morning: TimeSlot(
                            start: _morningStartController.text,
                            end: _morningEndController.text,
                          ),
                          afternoon: TimeSlot(
                            start: _afternoonStartController.text,
                            end: _afternoonEndController.text,
                          ),
                        ),
                        maxStudentsPerInstructor: _maxStudents,
                      );
                      await ref
                          .read(settingsNotifierProvider.notifier)
                          .updateSettings(newSettings);

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Réglages enregistrés !')),
                      );
                    }
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}
