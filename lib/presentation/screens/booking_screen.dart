import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/reservation.dart';
import '../providers/booking_notifier.dart';
import '../providers/staff_notifier.dart';
import '../../l10n/app_localizations.dart';

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
  final _manualNotesController = TextEditingController();

  @override
  void dispose() {
    _clientNameController.dispose();
    _manualNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    // staffAsync unused here, but used in dialog Consumer

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reservations)),
      body: Column(
        children: [
          // Header / Calendar Placeholder
          ListTile(
            title: Text(
              '${l10n.dateLabel}: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
            segments: [
              ButtonSegment(value: TimeSlot.morning, label: Text(l10n.morning)),
              ButtonSegment(
                value: TimeSlot.afternoon,
                label: Text(l10n.afternoon),
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
                  return Center(child: Text(l10n.noReservationsOnSlot));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final b = filtered[index];
                    return ListTile(
                      title: Text(b.clientName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.staffId ?? l10n.instructorUnassigned),
                          if (b.notes.isNotEmpty)
                            Text(
                              '${l10n.noteLabel}: ${b.notes}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueGrey,
                              ),
                            ),
                        ],
                      ),
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
              error: (err, _) =>
                  Center(child: Text('${l10n.errorLabel}: $err')),
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
          final l10n = AppLocalizations.of(context);
          final staff = ref.watch(staffNotifierProvider).value ?? [];
          return AlertDialog(
            title: Text(l10n.newReservation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _clientNameController,
                  decoration: InputDecoration(labelText: l10n.clientNameLabel),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: l10n.instructorOptional,
                  ),
                  initialValue: _selectedStaffId,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.randomInstructor),
                    ),
                    ...staff.map(
                      (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedStaffId = val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _manualNotesController,
                  decoration: InputDecoration(
                    labelText: l10n.notesLabel,
                    hintText: l10n.notesHint,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancelButton),
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
                        notes: _manualNotesController.text,
                      );

                  if (context.mounted) {
                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    } else {
                      _clientNameController.clear();
                      _manualNotesController.clear();
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(l10n.bookButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
