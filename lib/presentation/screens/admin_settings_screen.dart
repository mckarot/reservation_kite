import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/settings.dart';
import '../providers/settings_notifier.dart';
import '../providers/theme_notifier.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/theme_selector.dart';
import '../widgets/color_picker.dart';
import '../widgets/theme_preview.dart';
import '../../domain/models/app_theme_settings.dart';
import 'staff_admin_screen.dart';
import 'credit_pack_admin_screen.dart';
import 'equipment_admin_screen.dart';
import '../../l10n/app_localizations.dart';

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

  /// Affiche un dialog pour redémarrer l'application
  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.refresh, color: Colors.orange),
            SizedBox(width: 8),
            Text('Redémarrage nécessaire'),
          ],
        ),
        content: const Text(
          'Les couleurs ont été mises à jour pour TOUS les utilisateurs. '
          'Veuillez redémarrer l\'application pour voir les changements.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Plus tard'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Quitter et redémarrer (hot restart en dev)
              // En production, il faudrait utiliser un package comme restart_app
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '🔄 Veuillez faire un hot restart (R) en mode développement',
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            },
            icon: const Icon(Icons.info),
            label: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.schoolSettings)),
      body: settingsAsync.when(
        data: (settings) {
          if (settings == null) {
            return Center(child: Text(l10n.settingsNotFound));
          }

          if (_morningStartController.text.isEmpty) {
            _initFields(settings);
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    l10n.morningHours,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _morningStartController,
                        decoration: InputDecoration(labelText: l10n.startLabel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _morningEndController,
                        decoration: InputDecoration(labelText: l10n.endLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 48,
                ), // Plus d'espace entre matin et après-midi
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    l10n.afternoonHours,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _afternoonStartController,
                        decoration: InputDecoration(labelText: l10n.startLabel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _afternoonEndController,
                        decoration: InputDecoration(labelText: l10n.endLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<int>(
                  initialValue: _maxStudents,
                  decoration: InputDecoration(
                    labelText: l10n.maxStudentsPerInstructor,
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

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.settingsSaved)),
                      );
                    }
                  },
                  child: Text(l10n.saveButton),
                ),

                // Section Apparence / Thème
                const Divider(height: 48),
                Row(
                  children: [
                    const Text('🎨 ', style: TextStyle(fontSize: 20)),
                    Text(
                      l10n.appearanceSection,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Badge explicatif
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mode : Local à chaque appareil',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Couleurs : Globales (tous les utilisateurs)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sélecteur de mode (Clair/Sombre/Système) - LOCAL
                Row(
                  children: [
                    Text(
                      l10n.themeMode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text(
                        'LOCAL',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const ThemeSelector(),

                // Aperçu du thème
                const ThemePreview(),
                const SizedBox(height: 16),

                // Couleurs de la marque - GLOBAL
                Row(
                  children: [
                    Text(
                      l10n.brandColors,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Text(
                        'GLOBAL',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ces couleurs seront appliquées à TOUS les appareils',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final themeSettingsAsync = ref.watch(themeNotifierProvider);
                    final themeSettings = themeSettingsAsync.value;

                    if (themeSettings == null) {
                      return const CircularProgressIndicator();
                    }

                    final notifier = ref.read(themeNotifierProvider.notifier);

                    return Column(
                      children: [
                        ColorPicker(
                          title: l10n.primaryColor,
                          selectedColor: themeSettings.primary,
                          onColorSelected: (color) {
                            notifier.setPrimaryColor(color);
                            _showRestartDialog(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        ColorPicker(
                          title: l10n.secondaryColor,
                          selectedColor: themeSettings.secondary,
                          onColorSelected: (color) {
                            notifier.setSecondaryColor(color);
                            _showRestartDialog(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        ColorPicker(
                          title: l10n.accentColor,
                          selectedColor: themeSettings.accent,
                          onColorSelected: (color) {
                            notifier.setAccentColor(color);
                            _showRestartDialog(context);
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  notifier.resetToDefaults();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.colorsReset),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                                label: Text(l10n.resetToDefaults),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const Divider(height: 48),
                ListTile(
                  leading: const Icon(Icons.sell, color: Colors.purple),
                  title: Text(l10n.packCatalog),
                  subtitle: Text(l10n.packCatalogSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreditPackAdminScreen(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.people, color: Colors.blue),
                  title: Text(l10n.staffManagement),
                  subtitle: Text(l10n.staffManagementSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffAdminScreen()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory, color: Colors.orange),
                  title: Text(l10n.equipmentManagement),
                  subtitle: Text(l10n.equipmentManagementSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EquipmentAdminScreen(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.errorLabel}: $err')),
      ),
    );
  }
}
