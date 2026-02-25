import '../models/staff_unavailability.dart';

abstract class AvailabilityRepository {
  Future<List<StaffUnavailability>> getAvailabilities(DateTime date);
  Future<void> saveAvailability(StaffUnavailability availability);
  Future<void> deleteAvailability(String id);
  Future<List<StaffUnavailability>> getInstructorAvailabilities(
    String instructorId,
  );
}
