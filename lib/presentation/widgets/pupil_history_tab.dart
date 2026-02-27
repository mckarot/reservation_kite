import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_notifier.dart';
import '../../domain/models/reservation.dart';

class PupilHistoryTab extends ConsumerWidget {
  final String userId;
  const PupilHistoryTab({super.key, required this.userId});

  String _translateSlot(TimeSlot slot) {
    switch (slot) {
      case TimeSlot.morning:
        return 'Matin';
      case TimeSlot.afternoon:
        return 'Après-midi';
      default:
        return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingNotifierProvider);

    return bookingsAsync.when(
      data: (bookings) {
        final myBookings = bookings.where((b) => b.pupilId == userId).toList();

        // Trier par date décroissante
        myBookings.sort((a, b) => b.date.compareTo(a.date));

        if (myBookings.isEmpty) {
          return const Center(
            child: Text('Tu n\'as pas encore de cours de prévu.'),
          );
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
              color: isFuture ? Colors.blue.shade50 : Colors.white,
              child: ListTile(
                leading: Icon(
                  isFuture ? Icons.upcoming : Icons.history,
                  color: isFuture ? Colors.blue : Colors.grey,
                ),
                title: Text(
                  'Cours du ${b.date.day}/${b.date.month}/${b.date.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Créneau: ${_translateSlot(b.slot)}'),
                trailing: _StatusBadge(status: b.status, isFuture: isFuture),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur: $err')),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReservationStatus status;
  final bool isFuture;

  const _StatusBadge({required this.status, required this.isFuture});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case ReservationStatus.pending:
        color = Colors.orange;
        label = 'EN ATTENTE';
        break;
      case ReservationStatus.confirmed:
        color = isFuture ? Colors.blue : Colors.green;
        label = isFuture ? 'À VENIR' : 'TERMINÉ';
        break;
      case ReservationStatus.cancelled:
        color = Colors.red;
        label = 'ANNULÉ';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
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
