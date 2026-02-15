import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
class Staff with _$Staff {
  const factory Staff({
    required String id,
    required String name,
    required String bio,
    required String photoUrl,
    @Default([]) List<String> specialties,
    @Default([]) List<String> certificates,
    @Default(true) bool isActive,
    required DateTime updatedAt,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}
