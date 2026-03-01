import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/staff_notifier.dart';
import '../providers/booking_notifier.dart';
import '../providers/user_notifier.dart';
import '../providers/auth_state_provider.dart';
import '../../data/providers/repository_providers.dart';
import 'lesson_validation_screen.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/staff.dart';
import '../../domain/models/staff_unavailability.dart';
import '../providers/unavailability_notifier.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

class MonitorMainScreen extends ConsumerStatefulWidget {
  const MonitorMainScreen({super.key});

  @override
  ConsumerState<MonitorMainScreen> createState() => _MonitorMainScreenState();
}

class _MonitorMainScreenState extends ConsumerState<MonitorMainScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserAsync = ref.watch(currentUserProvider);
    final staffAsync = ref.watch(staffNotifierProvider);
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    
    // Récupérer les couleurs du thème dynamique
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    final secondaryColor = themeSettings?.secondary ?? AppThemeSettings.defaultSecondary;

    final effectiveStaffId = currentUserAsync.value?.id;

    if (effectiveStaffId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.monitorSpace),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_busy),
            tooltip: l10n.myAbsences,
            onPressed: () => _showAbsenceDialog(context, ref, effectiveStaffId),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: staffAsync.when(
        data: (staffList) {
          final meIndex = staffList.indexWhere((s) => s.id == effectiveStaffId);

          if (meIndex == -1) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search,
                        size: 64,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        l10n.monitorProfileNotActive,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        l10n.monitorProfileNotActiveDesc,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            ref.read(authRepositoryProvider).signOut(),
                        icon: const Icon(Icons.logout),
                        label: Text(l10n.signOut),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final me = staffList[meIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MonitorHeader(staff: me),
              _DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.lessonPlanning,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: bookingsAsync.when(
                  data: (bookings) {
                    final myLessons = bookings.where((b) {
                      final isSameDay =
                          b.date.year == _selectedDate.year &&
                          b.date.month == _selectedDate.month &&
                          b.date.day == _selectedDate.day;
                      return b.staffId == effectiveStaffId &&
                          isSameDay &&
                          b.status == ReservationStatus.confirmed;
                    }).toList();

                    if (myLessons.isEmpty) {
                      return Center(child: Text(l10n.noLessonsAssigned));
                    }

                    return ListView.builder(
                      itemCount: myLessons.length,
                      itemBuilder: (context, index) {
                        final session = myLessons[index];
                        return _LessonCard(reservation: session);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text('${l10n.errorLabel}: $e')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorLabel}: $e')),
      ),
    );
  }

  void _showAbsenceDialog(BuildContext context, WidgetRef ref, String staffId) {
    showDialog(
      context: context,
      builder: (context) => _AbsenceManagementDialog(staffId: staffId),
    );
  }
}

class _AbsenceManagementDialog extends ConsumerWidget {
  final String staffId;
  const _AbsenceManagementDialog({required this.staffId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unavailabilitiesAsync = ref.watch(unavailabilityNotifierProvider);

    return AlertDialog(
      title: Text(l10n.myAbsences),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => _requestAbsence(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.declareAbsence),
            ),
            const Divider(),
            Flexible(
              child: unavailabilitiesAsync.when(
                data: (list) {
                  final myAbsences = list
                      .where((u) => u.staffId == staffId)
                      .toList();
                  if (myAbsences.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        l10n.noAbsencesDeclared,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: myAbsences.length,
                    itemBuilder: (context, index) {
                      final u = myAbsences[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          '${u.date.day}/${u.date.month} - ${u.slot == TimeSlot.fullDay ? l10n.fullDay : (u.slot == TimeSlot.morning ? l10n.morning : l10n.afternoon)}',
                        ),
                        subtitle: Text(u.reason),
                        trailing: _StatusBadge(status: u.status, l10n: l10n),
                        onLongPress: u.status == UnavailabilityStatus.pending
                            ? () => ref
                                  .read(unavailabilityNotifierProvider.notifier)
                                  .deleteRequest(u.id)
                            : null,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('${l10n.errorLabel}: $e'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  void _requestAbsence(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeSlot selectedSlot = TimeSlot.morning;
    final reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.absenceRequestTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TimeSlot>(
                initialValue: selectedSlot,
                decoration: InputDecoration(labelText: l10n.timeSlot),
                items: [
                  DropdownMenuItem(
                    value: TimeSlot.morning,
                    child: Text(l10n.morning),
                  ),
                  DropdownMenuItem(
                    value: TimeSlot.afternoon,
                    child: Text(l10n.afternoon),
                  ),
                  DropdownMenuItem(
                    value: TimeSlot.fullDay,
                    child: Text(l10n.fullDay),
                  ),
                ],
                onChanged: (val) => setState(() => selectedSlot = val!),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(labelText: l10n.absenceReasonHint),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(unavailabilityNotifierProvider.notifier)
                    .requestUnavailability(
                      staffId: staffId,
                      date: selectedDate,
                      slot: selectedSlot,
                      reason: reasonController.text,
                    );
                Navigator.pop(context);
              },
              child: Text(l10n.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final UnavailabilityStatus status;
  final AppLocalizations l10n;
  const _StatusBadge({required this.status, required this.l10n});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case UnavailabilityStatus.pending:
        color = Colors.orange;
        label = l10n.statusPending;
        break;
      case UnavailabilityStatus.approved:
        color = Colors.green;
        label = l10n.statusApproved;
        break;
      case UnavailabilityStatus.rejected:
        color = Colors.red;
        label = l10n.statusRejected;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _DateSelector({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 14, // 2 semaines
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey.shade200,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekdayShort(l10n, date.weekday),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getWeekdayShort(AppLocalizations l10n, int day) {
    // Utiliser DateFormat avec la locale de l'application pour une localisation automatique
    final now = DateTime.now();
    final date = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: day - 1));
    return DateFormat('EEE', l10n.localeName).format(date);
  }
}

class _MonitorHeader extends StatelessWidget {
  final Staff staff;
  const _MonitorHeader({required this.staff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(bottom: BorderSide(color: Colors.orange.shade100)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: staff.photoUrl.isNotEmpty
                ? NetworkImage(staff.photoUrl)
                : null,
            child: staff.photoUrl.isEmpty
                ? Text(staff.name.substring(0, 1).toUpperCase())
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.greeting(staff.name),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  staff.specialties.join(' • '),
                  style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends ConsumerWidget {
  final Reservation reservation;
  const _LessonCard({required this.reservation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final users = ref.watch(userNotifierProvider).value ?? [];
    
    // Récupérer les couleurs du thème dynamique
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    final secondaryColor = themeSettings?.secondary ?? AppThemeSettings.defaultSecondary;
    
    final pupil = users.any((u) => u.id == reservation.pupilId)
        ? users.firstWhere((u) => u.id == reservation.pupilId)
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: secondaryColor.withOpacity(0.3), width: 1),
                ),
                child: Icon(
                  reservation.slot == TimeSlot.morning
                      ? Icons.light_mode
                      : Icons.wb_twilight,
                  color: primaryColor,
                ),
              ),
              title: Text(
                reservation.clientName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                reservation.slot == TimeSlot.morning
                    ? l10n.morning
                    : l10n.afternoon,
              ),
              trailing: pupil != null
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LessonValidationScreen(
                              reservation: reservation,
                              pupil: pupil,
                            ),
                          ),
                        );
                      },
                      child: Text(l10n.validate),
                    )
                  : Badge(label: Text(l10n.offSystem)),
            ),
            if (reservation.notes.isNotEmpty) ...[
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reservation.notes,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
