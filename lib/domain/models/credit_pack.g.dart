// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditPackImpl _$$CreditPackImplFromJson(Map<String, dynamic> json) =>
    _$CreditPackImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      credits: (json['credits'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$CreditPackImplToJson(_$CreditPackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'credits': instance.credits,
      'price': instance.price,
      'is_active': instance.isActive,
    };
