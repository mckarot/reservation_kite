import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/utils/timestamp_converter.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String userId,
    required int amount,
    required String
    type, // 'credit_purchase', 'lesson_payment', 'boutique_purchase'
    required String paymentMethod, // 'cash', 'card', 'transfer'
    @Default({}) Map<String, dynamic> metadata,
    @TimestampConverter() required DateTime createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
