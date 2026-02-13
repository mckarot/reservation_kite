import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_notifier.dart';

class PupilHistoryTab extends ConsumerWidget {
  final String userId;
  const PupilHistoryTab({super.key, required this.userId});

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
                subtitle: Text('Créneau: ${b.slot.name.toUpperCase()}'),
                trailing: Text(
                  isFuture ? 'À VENIR' : 'TERMINÉ',
                  style: TextStyle(
                    fontSize: 10,
                    color: isFuture ? Colors.blue : Colors.grey,
                  ),
                ),
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
