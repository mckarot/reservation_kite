import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/hive_config.dart';
import 'services/reservation_service.dart';
import 'presentation/screens/admin_settings_screen.dart';
import 'presentation/screens/staff_admin_screen.dart';
import 'presentation/screens/booking_screen.dart';
import 'presentation/screens/user_directory_screen.dart';
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

  // Initialiser Hive
  await HiveConfig.init();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kite Reserve',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const InitializationCheckScreen(),
    );
  }
}

class InitializationCheckScreen extends ConsumerWidget {
  const InitializationCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kite Reserve Status')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Système Initialisé en Local',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Base de données Hive : OK'),
            const Text('Architecture Repository : Prête'),
            const SizedBox(height: 32),
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
