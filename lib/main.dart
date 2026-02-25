import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

import 'domain/models/user.dart';
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
import 'presentation/providers/staff_session_notifier.dart';
import 'presentation/providers/session_notifier.dart';
import 'presentation/providers/auth_state_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'data/providers/repository_providers.dart';

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
              icon: const Icon(Icons.people),
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
            const Divider(height: 48),
            ElevatedButton.icon(
              onPressed: () => _showPupilSelector(context, ref),
              icon: const Icon(Icons.school, color: Colors.indigo),
              label: const Text('Simulation Mode Élève'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade50,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showStaffSelector(context, ref),
              icon: const Icon(Icons.group),
              label: const Text('Simulation Mode Moniteur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade50,
                foregroundColor: Colors.orange.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPupilSelector(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final usersAsync = ref.watch(userNotifierProvider);

          return AlertDialog(
            title: const Text('Choisir un élève pour la démo'),
            content: SizedBox(
              width: double.maxFinite,
              child: usersAsync.when(
                data: (allUsers) {
                  final users = allUsers
                      .where((u) => u.role == 'student')
                      .toList();
                  if (users.isEmpty) {
                    return const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'Aucun élève trouvé.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final u = users[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(u.displayName),
                        subtitle: Text(u.email),
                        onTap: () {
                          ref
                              .read(sessionNotifierProvider.notifier)
                              .login(u.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Erreur: $e'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStaffSelector(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final staffAsync = ref.watch(staffNotifierProvider);

          return AlertDialog(
            title: const Text('Choisir un moniteur (Simulation)'),
            content: SizedBox(
              width: double.maxFinite,
              child: staffAsync.when(
                data: (staffList) {
                  final activeStaff = staffList
                      .where((s) => s.isActive)
                      .toList();
                  if (activeStaff.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'Aucun moniteur actif trouvé.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: activeStaff.length,
                    itemBuilder: (context, index) {
                      final s = activeStaff[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: s.photoUrl.isNotEmpty
                              ? NetworkImage(s.photoUrl)
                              : null,
                          child: s.photoUrl.isEmpty
                              ? Text(s.name.substring(0, 1).toUpperCase())
                              : null,
                        ),
                        title: Text(s.name),
                        subtitle: Text(s.specialties.join(', ')),
                        onTap: () {
                          ref
                              .read(staffSessionNotifierProvider.notifier)
                              .login(s.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Erreur: $e'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }
}
