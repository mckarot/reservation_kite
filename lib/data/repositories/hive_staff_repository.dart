import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reservation_kite/domain/repositories/staff_repository.dart';
import 'package:reservation_kite/domain/models/staff.dart';
import '../../database/hive_config.dart';

class HiveStaffRepository implements StaffRepository {
  Box<String> get _box => Hive.box<String>(HiveConfig.staffBox);

  @override
  Future<List<Staff>> getAllStaff() async {
    return _box.values
        .map((json) => Staff.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveStaff(Staff staff) async {
    final json = jsonEncode(staff.toJson());
    await _box.put(staff.id, json);
  }

  @override
  Future<void> deleteStaff(String id) async {
    await _box.delete(id);
  }
}
