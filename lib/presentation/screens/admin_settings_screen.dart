import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/settings.dart';
import '../providers/settings_notifier.dart';
import '../providers/theme_notifier.dart';
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
                Text(
                  l10n.morningHours,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                const SizedBox(height: 24),
                Text(
                  l10n.afternoonHours,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                Text(
                  '🎨 ${l10n.appearanceSection}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Sélecteur de mode (Clair/Sombre/Système)
                Text(
                  l10n.themeMode,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const ThemeSelector(),
                
                // Aperçu du thème
                const ThemePreview(),
                
                // Couleurs de la marque
                Text(
                  l10n.brandColors,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
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
                          onColorSelected: (color) => notifier.setPrimaryColor(color),
                        ),
                        const SizedBox(height: 16),
                        ColorPicker(
                          title: l10n.secondaryColor,
                          selectedColor: themeSettings.secondary,
                          onColorSelected: (color) => notifier.setSecondaryColor(color),
                        ),
                        const SizedBox(height: 16),
                        ColorPicker(
                          title: l10n.accentColor,
                          selectedColor: themeSettings.accent,
                          onColorSelected: (color) => notifier.setAccentColor(color),
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
