import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String displayName,
    required String email,
    String? photoUrl,
    @Default('student') String role,
    int? weight,
    @Default(0) int walletBalance,
    @Default(0) int totalCreditsPurchased,
    UserProgress? progress,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime lastSeen,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProgress with _$UserProgress {
  const factory UserProgress({
    String? ikoLevel,
    @Default([]) List<String> checklist,
    @Default([]) List<UserNote> notes,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}

@freezed
class UserNote with _$UserNote {
  const factory UserNote({
    @TimestampConverter() required DateTime date,
    required String content,
    required String instructorId,
  }) = _UserNote;

  factory UserNote.fromJson(Map<String, dynamic> json) =>
      _$UserNoteFromJson(json);
}
