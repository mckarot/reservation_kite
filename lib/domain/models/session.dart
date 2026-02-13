import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    required DateTime date,
    required String slot, // 'morning' or 'afternoon'
    required String instructorId,
    @Default([]) List<String> studentIds,
    required int maxCapacity,
    @Default('scheduled') String status,
    required DateTime createdAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
