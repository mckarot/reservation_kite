import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

import 'l10n/app_localizations.dart';
import 'services/reservation_service.dart';
import 'presentation/screens/pupil_main_screen.dart';
import 'presentation/screens/monitor_main_screen.dart';
import 'presentation/providers/auth_state_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/theme_notifier.dart';
import 'presentation/screens/login_screen.dart';
import 'data/providers/repository_providers.dart';
import 'presentation/screens/admin_screen.dart';
import 'presentation/theme/app_theme.dart';
import 'domain/models/app_theme_settings.dart';

// Provider pour le service de réservation
final reservationServiceProvider = ChangeNotifierProvider<ReservationService>((
  ref,
) {
  final repository = ref.watch(reservationRepositoryProvider);
  return ReservationService(repository);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialiser App Check (Obligatoire selon les règles)
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode
          ? AppleProvider.debug
          : AppleProvider.deviceCheck,
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    );
  } catch (e) {
    debugPrint('Firebase App Check failed to initialize: $e');
  }

  // Initialiser les locales pour intl
  await initializeDateFormatting('fr_FR', null);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);
    final localeAsync = ref.watch(localeNotifierProvider);
    final themeSettingsAsync = ref.watch(themeNotifierProvider);

    Widget home = authState.when(
      data: (user) {
        if (user == null) return const LoginScreen();

        switch (user.role) {
          case 'admin':
            return const AdminScreen();
          case 'instructor':
            return const MonitorMainScreen();
          case 'student':
            return const PupilMainScreen();
          default:
            return const LoginScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur: $e'))),
    );

    // Obtenir les paramètres de thème
    final themeSettings = themeSettingsAsync.value;
    final themeMode = themeSettings?.themeMode ?? ThemeMode.system;
    final lightTheme = AppTheme.createLightTheme(themeSettings ?? AppThemeSettings.defaults());
    final darkTheme = AppTheme.createDarkTheme(themeSettings ?? AppThemeSettings.defaults());

    return MaterialApp(
      title: 'Kite Reserve',
      debugShowCheckedModeBanner: false,
      
      // Thèmes dynamiques
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),  // Français
        Locale('en'),  // Anglais
        Locale('es'),  // Espagnol
        Locale('pt'),  // Portugais
        Locale('zh'),  // Chinois
      ],
      locale: localeAsync.value ?? const Locale('fr'),
      home: home,
    );
  }
}
