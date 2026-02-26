import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

import 'services/reservation_service.dart';
import 'presentation/screens/admin_settings_screen.dart';
import 'presentation/screens/staff_admin_screen.dart';
import 'presentation/screens/booking_screen.dart';
import 'presentation/screens/user_directory_screen.dart';
import 'presentation/screens/equipment_admin_screen.dart';
import 'presentation/screens/pupil_main_screen.dart';
import 'presentation/screens/admin_dashboard_screen.dart';
import 'presentation/screens/monitor_main_screen.dart';
import 'presentation/providers/user_notifier.dart';
import 'presentation/providers/staff_notifier.dart';
import 'presentation/providers/auth_state_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/providers/unavailability_notifier.dart';
import 'domain/models/staff_unavailability.dart';
import 'domain/models/staff.dart';
import 'data/providers/repository_providers.dart';
import 'package:intl/intl.dart';

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

    Widget home = authState.when(
      data: (user) {
        if (user == null) return const LoginScreen();

        switch (user.role) {
          case 'admin':
            return const InitializationCheckScreen();
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

    return MaterialApp(
      title: 'Kite Reserve',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR')],
      locale: const Locale('fr', 'FR'),
      home: home,
    );
  }
}

class InitializationCheckScreen extends ConsumerWidget {
  const InitializationCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kite Reserve Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Système Pilotage École',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const _PendingAbsencesAlert(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
              ),
              icon: const Icon(Icons.dashboard_customize),
              label: const Text('Dashboard Pilotage (KPIs)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Gestion Administrative',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
              ),
              icon: const Icon(Icons.settings),
              label: const Text('Accéder aux Réglages'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StaffAdminScreen()),
              ),
              icon: Consumer(
                builder: (context, ref, _) {
                  final unavailabilities =
                      ref.watch(unavailabilityNotifierProvider).value ?? [];
                  final pendingCount = unavailabilities
                      .where((u) => u.status == UnavailabilityStatus.pending)
                      .length;

                  if (pendingCount > 0) {
                    return Badge(
                      label: Text('$pendingCount'),
                      child: const Icon(Icons.people),
                    );
                  }
                  return const Icon(Icons.people);
                },
              ),
              label: const Text('Gérer le Staff'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserDirectoryScreen()),
              ),
              icon: const Icon(Icons.person_search),
              label: const Text('Répertoire Élèves'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EquipmentAdminScreen()),
              ),
              icon: const Icon(Icons.inventory_2),
              label: const Text('Gestion du Matériel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade50,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingScreen()),
              ),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Calendrier / Réservations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingAbsencesAlert extends ConsumerWidget {
  const _PendingAbsencesAlert();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unavailabilitiesAsync = ref.watch(unavailabilityNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);

    return unavailabilitiesAsync.when(
      data: (list) {
        final pending = list
            .where((u) => u.status == UnavailabilityStatus.pending)
            .toList();
        if (pending.isEmpty) return const SizedBox();

        final allStaff = staffAsync.value ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ABSENCES À VALIDER',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              ...pending.take(2).map((u) {
                final staff = allStaff.firstWhere(
                  (s) => s.id == u.staffId,
                  orElse: () => Staff(
                    id: '',
                    name: '...',
                    bio: '',
                    photoUrl: '',
                    specialties: [],
                    updatedAt: DateTime.now(),
                  ),
                );
                return Card(
                  color: Colors.red.shade50,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffAdminScreen(),
                      ),
                    ),
                    leading: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    title: Text(
                      '${staff.name} - ${DateFormat('dd/MM').format(u.date)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                  ),
                );
              }),
              if (pending.length > 2)
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffAdminScreen()),
                  ),
                  child: Text(
                    'Voir les ${pending.length} demandes...',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (e, _) => const SizedBox(),
    );
  }
}
