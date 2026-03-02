import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
class Staff with _$Staff {
  const factory Staff({
    required String id,
    required String name,
    required String bio,
    required String photoUrl,
    @TimestampConverter() required DateTime updatedAt, @Default([]) List<String> specialties,
    @Default([]) List<String> certificates,
    @Default(true) bool isActive,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}
