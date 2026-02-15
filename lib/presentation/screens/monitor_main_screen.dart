import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/staff_session_notifier.dart';
import '../providers/staff_notifier.dart';
import '../providers/booking_notifier.dart';
import '../providers/user_notifier.dart';
import 'lesson_validation_screen.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/staff.dart';

class MonitorMainScreen extends ConsumerStatefulWidget {
  const MonitorMainScreen({super.key});

  @override
  ConsumerState<MonitorMainScreen> createState() => _MonitorMainScreenState();
}

class _MonitorMainScreenState extends ConsumerState<MonitorMainScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final staffId = ref.watch(staffSessionNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);
    final bookingsAsync = ref.watch(bookingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Moniteur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(staffSessionNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: staffAsync.when(
        data: (staffList) {
          final me = staffList.firstWhere((s) => s.id == staffId);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MonitorHeader(staff: me),
              _DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'PLANNING DES COURS',
                  style: TextStyle(
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
                      return b.staffId == staffId &&
                          isSameDay &&
                          b.status == ReservationStatus.confirmed;
                    }).toList();

                    if (myLessons.isEmpty) {
                      return const Center(
                        child: Text('Aucun cours assigné pour ce jour'),
                      );
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
                  error: (e, _) => Center(child: Text('Erreur: $e')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
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
                    _getWeekdayShort(date.weekday),
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

  String _getWeekdayShort(int day) {
    switch (day) {
      case 1:
        return 'lun';
      case 2:
        return 'mar';
      case 3:
        return 'mer';
      case 4:
        return 'jeu';
      case 5:
        return 'ven';
      case 6:
        return 'sam';
      case 7:
        return 'dim';
      default:
        return '';
    }
  }
}

class _MonitorHeader extends StatelessWidget {
  final Staff staff;
  const _MonitorHeader({required this.staff});

  @override
  Widget build(BuildContext context) {
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
                  'Salut, ${staff.name} ! 🤙',
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
    final users = ref.watch(userNotifierProvider).value ?? [];
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  reservation.slot == TimeSlot.morning
                      ? Icons.light_mode
                      : Icons.wb_twilight,
                  color: Colors.blue.shade700,
                ),
              ),
              title: Text(
                reservation.clientName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                reservation.slot == TimeSlot.morning ? 'Matin' : 'Après-midi',
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
                      child: const Text('Valider'),
                    )
                  : const Badge(label: Text('Hors Système')),
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
