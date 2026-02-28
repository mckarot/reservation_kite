import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_notifier.dart';
import '../widgets/pupil_dashboard_tab.dart';
import '../widgets/pupil_history_tab.dart';
import '../widgets/pupil_progress_tab.dart';
import 'pupil_booking_screen.dart';
import 'notification_center_screen.dart';
import '../providers/notification_notifier.dart';
import '../providers/auth_state_provider.dart';
import '../../data/providers/repository_providers.dart';
import '../../l10n/app_localizations.dart';

class PupilMainScreen extends ConsumerStatefulWidget {
  const PupilMainScreen({super.key});

  @override
  ConsumerState<PupilMainScreen> createState() => _PupilMainScreenState();
}

class _PupilMainScreenState extends ConsumerState<PupilMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserAsync = ref.watch(currentUserProvider);
    final usersAsync = ref.watch(userNotifierProvider);

    final effectiveUserId = currentUserAsync.value?.id;

    if (effectiveUserId == null) {
      if (currentUserAsync.isLoading || usersAsync.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(l10n.sessionExpired), const SizedBox(height: 16)],
          ),
        ),
      );
    }

    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Scaffold(body: Center(child: Text(l10n.noUsersFound)));
        }

        final user = users.firstWhere(
          (u) => u.id == effectiveUserId,
          orElse: () => users.first,
        );

        final List<Widget> tabs = [
          PupilDashboardTab(user: user),
          PupilProgressTab(user: user),
          const NotificationCenterScreen(),
          PupilHistoryTab(userId: user.id),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _currentIndex == 0
                  ? l10n.pupilSpace
                  : _currentIndex == 1
                  ? l10n.myProgress
                  : _currentIndex == 2
                  ? l10n.notifications
                  : l10n.history,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: l10n.logoutTooltip,
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                },
              ),
            ],
          ),
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard),
                label: l10n.homeTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.trending_up),
                label: l10n.progressTab,
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
                label: l10n.alertsTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: l10n.historyTab,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PupilBookingScreen()),
            ),
            label: Text(l10n.bookButton),
            icon: const Icon(Icons.add),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) =>
          Scaffold(body: Center(child: Text('${l10n.errorLabel}: $err'))),
    );
  }
}
