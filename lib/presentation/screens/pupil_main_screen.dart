import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/session_notifier.dart';
import '../providers/user_notifier.dart';
import '../widgets/pupil_dashboard_tab.dart';
import '../widgets/pupil_history_tab.dart';
import '../widgets/pupil_progress_tab.dart';
import 'pupil_booking_screen.dart';
import 'notification_center_screen.dart';
import '../providers/notification_notifier.dart';

class PupilMainScreen extends ConsumerStatefulWidget {
  const PupilMainScreen({super.key});

  @override
  ConsumerState<PupilMainScreen> createState() => _PupilMainScreenState();
}

class _PupilMainScreenState extends ConsumerState<PupilMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final activeUserId = ref.watch(sessionNotifierProvider);
    final usersAsync = ref.watch(userNotifierProvider);

    if (activeUserId == null) {
      return const Scaffold(body: Center(child: Text('Session expirée')));
    }

    return usersAsync.when(
      data: (users) {
        final user = users.firstWhere(
          (u) => u.id == activeUserId,
          orElse: () => users.first,
        );

        final List<Widget> tabs = [
          PupilDashboardTab(user: user),
          PupilProgressTab(user: user),
          const NotificationCenterScreen(),
          PupilHistoryTab(userId: user.id),
        ];

        return Scaffold(
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Accueil',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Progrès',
              ),
              BottomNavigationBarItem(
                icon: Consumer(
                  builder: (context, ref, _) {
                    final notifs =
                        ref.watch(notificationNotifierProvider).value ?? [];
                    final unreadCount = notifs.where((n) => !n.isRead).length;
                    return Badge(
                      label: Text(unreadCount.toString()),
                      isLabelVisible: unreadCount > 0,
                      child: const Icon(Icons.notifications),
                    );
                  },
                ),
                label: 'Alertes',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Historique',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PupilBookingScreen()),
            ),
            label: const Text('Réserver'),
            icon: const Icon(Icons.add),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Erreur: $err'))),
    );
  }
}
