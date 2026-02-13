import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/reservation.dart';
import '../../domain/logic/booking_validator.dart';
import '../../data/providers/repository_providers.dart';
import '../providers/staff_notifier.dart';
import '../providers/settings_notifier.dart';

part 'booking_notifier.g.dart';

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  FutureOr<List<Reservation>> build() async {
    return ref.watch(reservationRepositoryProvider).getAllReservations();
  }

  Future<String?> createBooking({
    required String clientName,
    required DateTime date,
    required TimeSlot slot,
    String? staffId,
  }) async {
    final repository = ref.read(reservationRepositoryProvider);
    final settings = ref.read(settingsNotifierProvider).value;
    final staff = ref.read(staffNotifierProvider).value;

    if (settings == null || staff == null) return 'Paramètres non chargés';

    final activeStaff = staff.where((s) => s.isActive).toList();
    final existingReservations = state.value ?? [];

    // Validation de capacité
    final canBook = BookingValidator.canBook(
      date: date,
      slot: slot,
      existingReservations: existingReservations,
      activeStaff: activeStaff,
      settings: settings,
    );

    if (!canBook) return 'Capacité maximale atteinte pour ce créneau';

    final reservation = Reservation(
      id: const Uuid().v4(),
      clientName: clientName,
      date: date,
      slot: slot,
      staffId: staffId,
      createdAt: DateTime.now(),
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveReservation(reservation);
      return repository.getAllReservations();
    });

    return null; // Success
  }

  Future<void> deleteBooking(String id) async {
    final repository = ref.read(reservationRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.deleteReservation(id);
      return repository.getAllReservations();
    });
  }
}
