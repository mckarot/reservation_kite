import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

/// Widget de sélection du mode du thème (Clair, Sombre, Système)
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final currentThemeMode = themeSettings?.themeMode ?? ThemeMode.system;
    final notifier = ref.read(themeNotifierProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.orange),
                const SizedBox(width: 12),
                Text(l10n.lightMode),
              ],
            ),
            value: ThemeMode.light,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                notifier.setThemeMode(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ ${l10n.themeApplied}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                Icon(Icons.nightlight, color: Colors.indigo),
                const SizedBox(width: 12),
                Text(l10n.darkMode),
              ],
            ),
            value: ThemeMode.dark,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                notifier.setThemeMode(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ ${l10n.themeApplied}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                Icon(Icons.phone_android, color: Colors.blue),
                const SizedBox(width: 12),
                Text(l10n.systemTheme),
              ],
            ),
            value: ThemeMode.system,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                notifier.setThemeMode(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ ${l10n.themeApplied}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
