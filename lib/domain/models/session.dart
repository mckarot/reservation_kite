import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    @TimestampConverter() required DateTime date,
    required String slot, // 'morning' or 'afternoon'
    required String instructorId,
    @Default([]) List<String> studentIds,
    required int maxCapacity,
    @Default('scheduled') String status,
    @TimestampConverter() required DateTime createdAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
