import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../domain/repositories/staff_repository.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/credit_pack_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/repositories/availability_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../repositories/firestore_user_repository.dart';
import '../repositories/firestore_staff_repository.dart';
import '../repositories/firestore_settings_repository.dart';
import '../repositories/firestore_reservation_repository.dart';
import '../repositories/firestore_equipment_repository.dart';
import '../repositories/firebase_auth_repository.dart';
import '../repositories/firestore_session_repository.dart';
import '../repositories/firestore_availability_repository.dart';
import '../repositories/firestore_transaction_repository.dart';
import '../repositories/firestore_credit_pack_repository.dart';
import '../repositories/hive_notification_repository.dart';

part 'repository_providers.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return FirestoreUserRepository(FirebaseFirestore.instance);
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return FirestoreSettingsRepository(FirebaseFirestore.instance);
}

@riverpod
ReservationRepository reservationRepository(ReservationRepositoryRef ref) {
  return FirestoreReservationRepository(FirebaseFirestore.instance);
}

@riverpod
EquipmentRepository equipmentRepository(EquipmentRepositoryRef ref) {
  return FirestoreEquipmentRepository(FirebaseFirestore.instance);
}

@riverpod
StaffRepository staffRepository(StaffRepositoryRef ref) {
  return FirestoreStaffRepository(FirebaseFirestore.instance);
}

@riverpod
CreditPackRepository creditPackRepository(CreditPackRepositoryRef ref) {
  return FirestoreCreditPackRepository(FirebaseFirestore.instance);
}

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return HiveNotificationRepository();
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FirebaseAuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
}

@riverpod
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  return FirestoreSessionRepository(FirebaseFirestore.instance);
}

@riverpod
AvailabilityRepository availabilityRepository(AvailabilityRepositoryRef ref) {
  return FirestoreAvailabilityRepository(FirebaseFirestore.instance);
}

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return FirestoreTransactionRepository(FirebaseFirestore.instance);
}
