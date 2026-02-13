import '../../domain/models/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String id);
  Future<void> saveUser(User user);
  Future<List<User>> getAllUsers();
  Future<void> deleteUser(String id);
}
