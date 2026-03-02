import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_notifier.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

class PupilHistoryTab extends ConsumerWidget {
  final String userId;
  const PupilHistoryTab({super.key, required this.userId});

  String _translateSlot(TimeSlot slot, AppLocalizations l10n) {
    switch (slot) {
      case TimeSlot.morning:
        return l10n.slotMorning;
      case TimeSlot.afternoon:
        return l10n.slotAfternoon;
      default:
        return l10n.slotUnknown;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return bookingsAsync.when(
      data: (bookings) {
        final myBookings = bookings.where((b) => b.pupilId == userId).toList();

        // Trier par date décroissante
        myBookings.sort((a, b) => b.date.compareTo(a.date));

        if (myBookings.isEmpty) {
          return Center(child: Text(l10n.noLessonsScheduled));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
          itemCount: myBookings.length,
          itemBuilder: (context, index) {
            final b = myBookings[index];
            final isFuture = b.date.isAfter(DateTime.now());

            return Card(
              elevation: isFuture ? 4 : 1,
              margin: const EdgeInsets.only(bottom: 16),
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1.5),
              ),
              color: isFuture ? primaryColor.withOpacity(0.1) : Colors.white,
              child: ListTile(
                leading: Icon(
                  isFuture ? Icons.upcoming : Icons.history,
                  color: isFuture ? primaryColor : Colors.grey,
                ),
                title: Text(
                  '${l10n.lessonOn} ${b.date.day}/${b.date.month}/${b.date.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${l10n.slotLabel}: ${_translateSlot(b.slot, l10n)}',
                ),
                trailing: _StatusBadge(status: b.status, isFuture: isFuture),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${l10n.errorLabel}: $err')),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReservationStatus status;
  final bool isFuture;

  const _StatusBadge({required this.status, required this.isFuture});

  String _getLabel(AppLocalizations l10n) {
    switch (status) {
      case ReservationStatus.pending:
        return l10n.statusPending;
      case ReservationStatus.confirmed:
        return isFuture ? l10n.statusUpcoming : l10n.statusCompleted;
      case ReservationStatus.cancelled:
        return l10n.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = _getLabel(l10n);

    Color color;
    switch (status) {
      case ReservationStatus.pending:
        color = Colors.orange;
        break;
      case ReservationStatus.confirmed:
        color = isFuture ? Colors.blue : Colors.green;
        break;
      case ReservationStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
