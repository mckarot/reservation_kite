import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/session_notifier.dart';
import '../providers/user_notifier.dart';
import '../widgets/pupil_dashboard_tab.dart';
import '../widgets/pupil_history_tab.dart';
import '../widgets/pupil_progress_tab.dart';

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
          PupilHistoryTab(userId: user.id),
          PupilProgressTab(user: user),
        ];

        return Scaffold(
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Aujourd\'hui',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Mes Cours',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Ma Progression',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () =>
                ref.read(sessionNotifierProvider.notifier).logout(),
            child: const Icon(Icons.logout),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Erreur: $err'))),
    );
  }
}
