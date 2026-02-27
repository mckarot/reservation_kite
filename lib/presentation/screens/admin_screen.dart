import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reservation_kite/presentation/screens/admin_dashboard_screen.dart';
import 'package:reservation_kite/presentation/screens/admin_settings_screen.dart';
import 'package:reservation_kite/presentation/screens/booking_screen.dart';
import 'package:reservation_kite/presentation/screens/equipment_admin_screen.dart';
import 'package:reservation_kite/presentation/screens/staff_admin_screen.dart';
import 'package:reservation_kite/presentation/screens/user_directory_screen.dart';
import '../../data/providers/repository_providers.dart';
import '../../domain/models/staff.dart';
import '../../domain/models/staff_unavailability.dart';
import '../../l10n/app_localizations.dart';
import '../providers/staff_notifier.dart';
import '../providers/unavailability_notifier.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final List<_DashboardItem> items = [
      _DashboardItem(
        title: l10n.dashboardKPIs,
        icon: Icons.dashboard_customize,
        route: const AdminDashboardScreen(),
        color: Colors.blue.shade700,
      ),
      _DashboardItem(
        title: l10n.settings,
        icon: Icons.settings,
        route: const AdminSettingsScreen(),
      ),
      _DashboardItem(
        title: l10n.manageStaff,
        icon: Icons.people,
        route: const StaffAdminScreen(),
        hasBadge: true,
      ),
      _DashboardItem(
        title: l10n.studentDirectory,
        icon: Icons.person_search,
        route: const UserDirectoryScreen(),
      ),
      _DashboardItem(
        title: l10n.equipmentManagement,
        icon: Icons.inventory_2,
        route: const EquipmentAdminScreen(),
      ),
      _DashboardItem(
        title: l10n.calendarBookings,
        icon: Icons.calendar_month,
        route: const BookingScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            tooltip: l10n.logoutButton,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const _PendingAbsencesAlert(),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _DashboardCard(item: items[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Widget route;
  final Color? color;
  final bool hasBadge;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.route,
    this.color,
    this.hasBadge = false,
  });
}

class _DashboardCard extends ConsumerWidget {
  final _DashboardItem item;

  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget icon = Icon(item.icon, size: 40, color: item.color ?? Theme.of(context).primaryColor);

    if (item.hasBadge) {
      final unavailabilities = ref.watch(unavailabilityNotifierProvider).value ?? [];
      final pendingCount =
          unavailabilities.where((u) => u.status == UnavailabilityStatus.pending).length;
      if (pendingCount > 0) {
        icon = Badge(
          label: Text('$pendingCount'),
          child: icon,
        );
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => item.route),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
    final l10n = AppLocalizations.of(context)!;
    final unavailabilitiesAsync = ref.watch(unavailabilityNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);

    return unavailabilitiesAsync.when(
      data: (list) {
        final pending =
            list.where((u) => u.status == UnavailabilityStatus.pending).toList();
        if (pending.isEmpty) return const SizedBox.shrink();

        final allStaff = staffAsync.value ?? [];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.red.shade50,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pendingAbsencesAlert,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...pending.take(2).map((u) {
                  final staff = allStaff.firstWhere(
                    (s) => s.id == u.staffId,
                    orElse: () => Staff(
                      id: '',
                      name: l10n.notFound,
                      bio: '',
                      photoUrl: '',
                      specialties: [],
                      updatedAt: DateTime.now(),
                    ),
                  );
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                    title: Text(
                      '${staff.name} - ${DateFormat('dd/MM').format(u.date)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StaffAdminScreen()),
                    ),
                  );
                }),
                if (pending.length > 2)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StaffAdminScreen()),
                      ),
                      child: Text(l10n.seeRequests(pending.length)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}