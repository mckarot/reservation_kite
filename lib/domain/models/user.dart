import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'display_name') required String displayName,
    required String email,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @Default('student') String role,
    int? weight,
    @JsonKey(name: 'wallet_balance') @Default(0) int walletBalance,
    @JsonKey(name: 'total_credits_purchased')
    @Default(0)
    int totalCreditsPurchased,
    UserProgress? progress,
    @TimestampConverter()
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @TimestampConverter()
    @JsonKey(name: 'last_seen')
    required DateTime lastSeen,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProgress with _$UserProgress {
  const factory UserProgress({
    @JsonKey(name: 'iko_level') String? ikoLevel,
    @Default([]) List<String> checklist,
    @Default([]) List<UserNote> notes,
  }) = _UserProgress;

  static const Map<String, List<String>> ikoSkillsByLevel = {
    'Niveau 1 - Découverte': [
      'Préparation & Sécurité',
      'Pilotage zone neutre',
      'Décollage / Atterrissage',
    ],
    'Niveau 2 - Intermédiaire': [
      'Nage tractée (Body Drag)',
      'Waterstart',
      'Navigation de base',
    ],
    'Niveau 3 - Indépendant': ['Remontée au vent', 'Transitions & Sauts'],
  };

  static List<String> get allIkoSkills =>
      ikoSkillsByLevel.values.expand((e) => e).toList();

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}

@freezed
class UserNote with _$UserNote {
  const factory UserNote({
    @TimestampConverter() required DateTime date,
    required String content,
    @JsonKey(name: 'instructor_id') required String instructorId,
  }) = _UserNote;

  factory UserNote.fromJson(Map<String, dynamic> json) =>
      _$UserNoteFromJson(json);
}
