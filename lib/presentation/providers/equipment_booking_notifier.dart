import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/equipment_booking.dart';
import '../../utils/date_utils.dart';
import '../providers/auth_state_provider.dart';

part 'equipment_booking_notifier.g.dart';

/// State management pour les réservations de matériel d'un utilisateur.
///
/// CORRECTION #3 : Utilisation correcte d'AsyncValue.guard
/// - Pattern : guard + .value! (pas .fold() qui n'existe pas)
/// - .value! lance l'exception si AsyncError, retourne la valeur sinon
@riverpod
class EquipmentBookingNotifier extends _$EquipmentBookingNotifier {
  @override
  FutureOr<List<EquipmentBooking>> build(String userId) async {
    return ref
        .watch(equipmentBookingRepositoryProvider)
        .getUserBookings(userId);
  }

  /// Crée une nouvelle réservation de matériel.
  ///
  /// Paramètres :
  /// - [equipmentId] : ID de l'équipement dans Firestore
  /// - [equipmentType] : Type (kite, foil, board, harness)
  /// - [equipmentBrand] : Marque (F-ONE, Duotone, etc.)
  /// - [equipmentModel] : Modèle (Bandit, Rhino, etc.)
  /// - [equipmentSize] : Taille (en m² pour les kites)
  /// - [date] : Date de réservation
  /// - [slot] : Créneau (morning, afternoon, fullDay)
  /// - [sessionId] : ID de session si lié à un cours (optionnel)
  /// - [notes] : Notes additionnelles (optionnel)
  ///
  /// Retourne l'ID de la réservation créée.
  /// Lance une exception en cas d'erreur (équipement indisponible, etc.)
  Future<String> createBooking({
    required String equipmentId,
    required String equipmentType,
    required String equipmentBrand,
    required String equipmentModel,
    required String equipmentSize,
    required DateTime date,
    required EquipmentBookingSlot slot,
    String? sessionId,
    String? notes,
  }) async {
    print('DEBUG: EquipmentBookingNotifier.createBooking called');
    final user = ref.read(currentUserProvider).value;
    print('DEBUG: user: ${user?.id}');
    if (user == null) {
      print('DEBUG: ERROR - User not logged in');
      throw Exception('Utilisateur non connecté');
    }

    final dateString = formatDateForQuery(date);
    final dateTimestamp = DateTime.utc(date.year, date.month, date.day);
    print('DEBUG: dateString=$dateString, slot=$slot');

    final booking = EquipmentBooking(
      id: '',
      userId: user.id,
      userName: user.displayName,
      userEmail: user.email,
      equipmentId: equipmentId,
      equipmentType: equipmentType,
      equipmentBrand: equipmentBrand,
      equipmentModel: equipmentModel,
      equipmentSize: equipmentSize,
      dateString: dateString,
      dateTimestamp: dateTimestamp,
      slot: slot,
      status: EquipmentBookingStatus.confirmed,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: user.id,
      sessionId: sessionId,
      notes: notes,
    );
    print('DEBUG: Booking object: $booking');

    // CORRECTION #3 : AsyncValue.guard utilisé correctement
    // .value! lance l'exception si AsyncError, retourne la valeur sinon
    print('DEBUG: Calling repository.createBooking...');
    final result = await AsyncValue.guard(
      () => ref.read(equipmentBookingRepositoryProvider).createBooking(booking),
    );

    if (result.hasError) {
      print('DEBUG: ERROR from Repository: ${result.error}');
    }

    final bookingId = result.value!;
    print('DEBUG: Booking created with ID: $bookingId');
    ref.invalidateSelf();
    return bookingId;
  }

  /// Annule une réservation existante.
  ///
  /// Seules les réservations avec le statut 'confirmed' peuvent être annulées.
  Future<void> cancelBooking(String bookingId) async {
    final result = await AsyncValue.guard(
      () =>
          ref.read(equipmentBookingRepositoryProvider).cancelBooking(bookingId),
    );
    result.value; // Lance l'exception si erreur
    ref.invalidateSelf();
  }
}
