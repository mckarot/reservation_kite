import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/staff.dart';
import '../../data/providers/repository_providers.dart';

part 'staff_notifier.g.dart';

@riverpod
class StaffNotifier extends _$StaffNotifier {
  @override
  FutureOr<List<Staff>> build() async {
    return ref.watch(staffRepositoryProvider).getAllStaff();
  }

  Future<void> addStaffWithAccount({
    required String name,
    required String email,
    required String password,
    required String bio,
    required String photoUrl,
    required List<String> specialties,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);

      // 1. Créer le compte Auth (cela va nous déconnecter temporairement de l'admin sur le SDK Client)
      final user = await authRepo.signUpWithEmailAndPassword(
        email,
        password,
        role: 'instructor',
      );

      if (user == null) throw Exception("Échec de la création du compte Auth");

      // 2. Créer le profil Staff associé avec le même ID
      final staff = Staff(
        id: user.id,
        name: name,
        bio: bio,
        photoUrl: photoUrl,
        specialties: specialties,
        updatedAt: DateTime.now(),
      );

      await ref.read(staffRepositoryProvider).saveStaff(staff);

      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }

  Future<void> addStaff(Staff staff) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(staffRepositoryProvider).saveStaff(staff);
      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }

  Future<void> updateStaff(Staff staff) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(staffRepositoryProvider).saveStaff(staff);
      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }

  Future<void> deleteStaff(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(staffRepositoryProvider).deleteStaff(id);
      return ref.read(staffRepositoryProvider).getAllStaff();
    });
  }
}
