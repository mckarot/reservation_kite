import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';

/// Extension pour accéder facilement aux couleurs du thème dans les widgets
extension ThemeColorsExtension on BuildContext {
  /// Couleur principale du thème
  Color get primaryColor {
    final ref = ProviderScope.containerOf(this);
    final themeSettings = ref.read(themeNotifierProvider).value;
    return themeSettings?.primary ?? Colors.blue;
  }

  /// Couleur secondaire du thème
  Color get secondaryColor {
    final ref = ProviderScope.containerOf(this);
    final themeSettings = ref.read(themeNotifierProvider).value;
    return themeSettings?.secondary ?? Colors.blue.shade300;
  }

  /// Couleur d'accent du thème
  Color get accentColor {
    final ref = ProviderScope.containerOf(this);
    final themeSettings = ref.read(themeNotifierProvider).value;
    return themeSettings?.accent ?? Colors.cyan;
  }
}

/// Widget helper pour utiliser les couleurs dynamiques du thème
class ThemeColors extends ConsumerWidget {
  final Widget Function(BuildContext context, Color primary, Color secondary, Color accent) builder;

  const ThemeColors({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    
    final primary = themeSettings?.primary ?? Colors.blue;
    final secondary = themeSettings?.secondary ?? Colors.blue.shade300;
    final accent = themeSettings?.accent ?? Colors.cyan;
    
    return builder(context, primary, secondary, accent);
  }
}
