import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../../domain/models/equipment.dart';
import '../../database/hive_config.dart';

class HiveEquipmentRepository implements EquipmentRepository {
  Box<String> get _box => Hive.box<String>(HiveConfig.equipmentBox);

  @override
  Future<List<Equipment>> getAllEquipment() async {
    return _box.values
        .map(
          (json) =>
              Equipment.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> saveEquipment(Equipment equipment) async {
    final json = jsonEncode(equipment.toJson());
    await _box.put(equipment.id, json);
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await _box.delete(id);
  }
}
