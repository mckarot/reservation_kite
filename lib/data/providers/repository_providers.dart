import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../domain/repositories/staff_repository.dart';
import '../repositories/hive_user_repository.dart';
import '../repositories/hive_settings_repository.dart';
import '../repositories/hive_reservation_repository.dart';
import '../repositories/hive_staff_repository.dart';

part 'repository_providers.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return HiveUserRepository();
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return HiveSettingsRepository();
}

@riverpod
ReservationRepository reservationRepository(ReservationRepositoryRef ref) {
  return HiveReservationRepository();
}

@riverpod
StaffRepository staffRepository(StaffRepositoryRef ref) {
  return HiveStaffRepository();
}
