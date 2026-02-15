import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/equipment.dart';
import '../../domain/repositories/equipment_repository.dart';

class HiveEquipmentRepository implements EquipmentRepository {
  static const String _boxName = 'equipment';

  Future<Box<String>> _getBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  @override
  Future<List<Equipment>> getAllEquipment() async {
    final box = await _getBox();
    return box.values.map((e) => Equipment.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<Equipment?> getEquipment(String id) async {
    final box = await _getBox();
    final data = box.get(id);
    if (data == null) return null;
    return Equipment.fromJson(jsonDecode(data));
  }

  @override
  Future<void> saveEquipment(Equipment equipment) async {
    final box = await _getBox();
    await box.put(equipment.id, jsonEncode(equipment.toJson()));
  }

  @override
  Future<void> deleteEquipment(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
