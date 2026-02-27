import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeNotifierProvider);
    final currentLocale = localeAsync.value ?? const Locale('fr');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButton<Locale>(
              value: currentLocale,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: Locale('fr'), child: Text('🇫🇷 Français')),
                DropdownMenuItem(value: Locale('en'), child: Text('🇬🇧 English')),
                DropdownMenuItem(value: Locale('es'), child: Text('🇪🇸 Español')),
                DropdownMenuItem(value: Locale('pt'), child: Text('🇵🇹 Português')),
                DropdownMenuItem(value: Locale('zh'), child: Text('🇨🇳 中文')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(localeNotifierProvider.notifier).setLocale(locale.languageCode);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
