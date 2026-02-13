import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class SchoolSettings with _$SchoolSettings {
  const factory SchoolSettings({
    required OpeningHours hours,
    @Default([]) List<String> daysOff,
    @Default(4) int maxStudentsPerInstructor,
    required DateTime updatedAt,
  }) = _SchoolSettings;

  factory SchoolSettings.fromJson(Map<String, dynamic> json) =>
      _$SchoolSettingsFromJson(json);
}

@freezed
class OpeningHours with _$OpeningHours {
  const factory OpeningHours({
    required TimeSlot morning,
    required TimeSlot afternoon,
  }) = _OpeningHours;

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);
}

@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required String start, // ISO format or HH:mm
    required String end,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}
