import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/reservation.dart';
import '../providers/booking_notifier.dart';
import '../providers/staff_notifier.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot _selectedSlot = TimeSlot.morning;
  String? _selectedStaffId;
  final _clientNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    // staffAsync unused here, but used in dialog Consumer

    return Scaffold(
      appBar: AppBar(title: const Text('Réservations')),
      body: Column(
        children: [
          // Header / Calendar Placeholder
          ListTile(
            title: Text(
              'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
          ),
          SegmentedButton<TimeSlot>(
            segments: const [
              ButtonSegment(value: TimeSlot.morning, label: Text('Matin')),
              ButtonSegment(
                value: TimeSlot.afternoon,
                label: Text('Après-midi'),
              ),
            ],
            selected: {_selectedSlot},
            onSelectionChanged: (set) =>
                setState(() => _selectedSlot = set.first),
          ),
          const Divider(),
          // Booking List
          Expanded(
            child: bookingsAsync.when(
              data: (bookings) {
                final filtered = bookings
                    .where(
                      (b) =>
                          b.date.year == _selectedDate.year &&
                          b.date.month == _selectedDate.month &&
                          b.date.day == _selectedDate.day &&
                          b.slot == _selectedSlot,
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Aucune réservation sur ce créneau'),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final b = filtered[index];
                    return ListTile(
                      title: Text(b.clientName),
                      subtitle: Text(b.staffId ?? 'Moniteur non assigné'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ref
                            .read(bookingNotifierProvider.notifier)
                            .deleteBooking(b.id),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookingDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final staff = ref.watch(staffNotifierProvider).value ?? [];
          return AlertDialog(
            title: const Text('Nouvelle Réservation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _clientNameController,
                  decoration: const InputDecoration(labelText: 'Nom du Client'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Moniteur (Optionnel)',
                  ),
                  initialValue: _selectedStaffId,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Au hasard / Équipe'),
                    ),
                    ...staff.map(
                      (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedStaffId = val),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final error = await ref
                      .read(bookingNotifierProvider.notifier)
                      .createBooking(
                        clientName: _clientNameController.text,
                        date: _selectedDate,
                        slot: _selectedSlot,
                        staffId: _selectedStaffId,
                      );

                  if (context.mounted) {
                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    } else {
                      _clientNameController.clear();
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Réserver'),
              ),
            ],
          );
        },
      ),
    );
  }
}
