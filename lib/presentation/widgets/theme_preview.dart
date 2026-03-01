import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_notifier.dart';
import '../../domain/models/app_theme_settings.dart';
import '../theme/app_theme.dart';

/// Widget d'aperçu du thème actuel
class ThemePreview extends ConsumerWidget {
  const ThemePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value ?? AppThemeSettings.defaults();

    final lightTheme = AppTheme.createLightTheme(themeSettings);
    final darkTheme = AppTheme.createDarkTheme(themeSettings);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = isDark ? darkTheme : lightTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aperçu du thème',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Mini AppBar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentTheme.appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: currentTheme.appBarTheme.foregroundColor,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Aperçu',
                    style: TextStyle(
                      color: currentTheme.appBarTheme.foregroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Mini Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentTheme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Titre de carte',
                    style: currentTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ceci est un exemple de contenu de carte.',
                    style: currentTheme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Action'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Switch et FAB
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    backgroundColor: currentTheme.floatingActionButtonTheme.backgroundColor,
                    foregroundColor: currentTheme.floatingActionButtonTheme.foregroundColor,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
