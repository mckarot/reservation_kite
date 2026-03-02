// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toInt(),
      type: json['type'] as String,
      paymentMethod: json['payment_method'] as String,
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount': instance.amount,
      'type': instance.type,
      'payment_method': instance.paymentMethod,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'metadata': instance.metadata,
    };
