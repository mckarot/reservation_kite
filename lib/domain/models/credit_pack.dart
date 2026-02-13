import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_pack.freezed.dart';
part 'credit_pack.g.dart';

@freezed
class CreditPack with _$CreditPack {
  const factory CreditPack({
    required String id,
    required String name,
    required int credits,
    required double price,
    @Default(true) bool isActive,
  }) = _CreditPack;

  factory CreditPack.fromJson(Map<String, dynamic> json) =>
      _$CreditPackFromJson(json);
}
