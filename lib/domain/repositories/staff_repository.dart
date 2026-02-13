import '../models/staff.dart';

abstract class StaffRepository {
  Future<List<Staff>> getAllStaff();
  Future<void> saveStaff(Staff staff);
  Future<void> deleteStaff(String id);
}
