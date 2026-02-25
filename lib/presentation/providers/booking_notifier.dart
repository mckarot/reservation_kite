import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/reservation.dart';
import '../../domain/logic/booking_validator.dart';
import '../../data/providers/repository_providers.dart';
import '../providers/staff_notifier.dart';
import '../providers/user_notifier.dart';
import '../providers/settings_notifier.dart';
import '../providers/notification_notifier.dart';
import '../providers/unavailability_notifier.dart';
import '../../domain/models/app_notification.dart';

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
    String? pupilId,
    ReservationStatus status = ReservationStatus.confirmed,
    String notes = '',
  }) async {
    final repository = ref.read(reservationRepositoryProvider);
    final settings = ref.read(settingsNotifierProvider).value;
    final staff = ref.read(staffNotifierProvider).value;

    if (settings == null || staff == null) return 'Paramètres non chargés';

    final activeStaff = staff.where((s) => s.isActive).toList();
    final existingReservations = state.value ?? [];

    final unavailabilities =
        ref.read(unavailabilityNotifierProvider).value ?? [];

    // Validation de capacité (on compte les confirmés ET les pending pour éviter le surbooking)
    final canBook = BookingValidator.canBook(
      date: date,
      slot: slot,
      existingReservations: existingReservations
          .where((r) => r.status != ReservationStatus.cancelled)
          .toList(),
      activeStaff: activeStaff,
      unavailabilities: unavailabilities,
      settings: settings,
    );

    if (!canBook) return 'Capacité maximale atteinte pour ce créneau';

    final reservation = Reservation(
      id: const Uuid().v4(),
      clientName: clientName,
      pupilId: pupilId,
      date: date,
      slot: slot,
      staffId: staffId,
      status: status,
      notes: notes,
      createdAt: DateTime.now(),
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveReservation(reservation);

      // Sécurité Wallet : Débit immédiat si c'est un élève identifié
      if (pupilId != null) {
        await ref
            .read(userNotifierProvider.notifier)
            .adjustCredits(pupilId, -1);
      }

      return repository.getAllReservations();
    });

    if (state.hasError) {
      return state.error.toString();
    }

    return null; // Success
  }

  Future<void> updateBookingStatus(
    String id,
    ReservationStatus status, {
    String? staffId,
  }) async {
    final repository = ref.read(reservationRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final reservations = await repository.getAllReservations();
      final index = reservations.indexWhere((r) => r.id == id);
      if (index != -1) {
        final oldRes = reservations[index];
        final updated = oldRes.copyWith(
          status: status,
          staffId: staffId ?? oldRes.staffId,
        );
        await repository.saveReservation(updated);

        // Sécurité Wallet : Restauration du crédit si annulé
        if (status == ReservationStatus.cancelled && oldRes.pupilId != null) {
          await ref
              .read(userNotifierProvider.notifier)
              .adjustCredits(oldRes.pupilId!, 1);
        }

        // Notification de l'élève
        if (oldRes.pupilId != null) {
          final notifNotifier = ref.read(notificationNotifierProvider.notifier);
          if (status == ReservationStatus.confirmed) {
            await notifNotifier.sendNotification(
              userId: oldRes.pupilId!,
              title: 'Cours Validé ! 🤙',
              message:
                  'Votre séance du ${oldRes.date.day}/${oldRes.date.month} a été confirmée.',
              type: NotificationType.success,
            );
          } else if (status == ReservationStatus.cancelled) {
            await notifNotifier.sendNotification(
              userId: oldRes.pupilId!,
              title: 'Séance Annulée 🔄',
              message:
                  'Votre séance a été annulée et votre crédit a été restitué.',
              type: NotificationType.alert,
            );
          }
        }
      }
      return repository.getAllReservations();
    });
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
