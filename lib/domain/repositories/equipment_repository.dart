import '../models/equipment.dart';

abstract class EquipmentRepository {
  Future<List<Equipment>> getAllEquipment();
  Future<Equipment?> getEquipment(String id);
  Future<void> saveEquipment(Equipment equipment);
  Future<void> deleteEquipment(String id);
}
