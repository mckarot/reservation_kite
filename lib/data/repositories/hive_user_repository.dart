import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user.dart';
import '../../database/hive_config.dart';

class HiveUserRepository implements UserRepository {
  Box<String> get _box => Hive.box<String>(HiveConfig.usersBox);

  @override
  Future<List<User>> getAllUsers() async {
    return _box.values
        .map((json) => User.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<User?> getUser(String id) async {
    final json = _box.get(id);
    if (json == null) return null;
    return User.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      final json = jsonEncode(user.toJson());
      await _box.put(user.id, json);
    } catch (e) {
      // Log minimaliste conforme aux règles
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    await _box.delete(id);
  }
}
