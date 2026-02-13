// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_pack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreditPack _$CreditPackFromJson(Map<String, dynamic> json) {
  return _CreditPack.fromJson(json);
}

/// @nodoc
mixin _$CreditPack {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get credits => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreditPackCopyWith<CreditPack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditPackCopyWith<$Res> {
  factory $CreditPackCopyWith(
          CreditPack value, $Res Function(CreditPack) then) =
      _$CreditPackCopyWithImpl<$Res, CreditPack>;
  @useResult
  $Res call({String id, String name, int credits, double price, bool isActive});
}

/// @nodoc
class _$CreditPackCopyWithImpl<$Res, $Val extends CreditPack>
    implements $CreditPackCopyWith<$Res> {
  _$CreditPackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? credits = null,
    Object? price = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      credits: null == credits
          ? _value.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreditPackImplCopyWith<$Res>
    implements $CreditPackCopyWith<$Res> {
  factory _$$CreditPackImplCopyWith(
          _$CreditPackImpl value, $Res Function(_$CreditPackImpl) then) =
      __$$CreditPackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int credits, double price, bool isActive});
}

/// @nodoc
class __$$CreditPackImplCopyWithImpl<$Res>
    extends _$CreditPackCopyWithImpl<$Res, _$CreditPackImpl>
    implements _$$CreditPackImplCopyWith<$Res> {
  __$$CreditPackImplCopyWithImpl(
      _$CreditPackImpl _value, $Res Function(_$CreditPackImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? credits = null,
    Object? price = null,
    Object? isActive = null,
  }) {
    return _then(_$CreditPackImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      credits: null == credits
          ? _value.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreditPackImpl implements _CreditPack {
  const _$CreditPackImpl(
      {required this.id,
      required this.name,
      required this.credits,
      required this.price,
      this.isActive = true});

  factory _$CreditPackImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreditPackImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int credits;
  @override
  final double price;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CreditPack(id: $id, name: $name, credits: $credits, price: $price, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditPackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, credits, price, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditPackImplCopyWith<_$CreditPackImpl> get copyWith =>
      __$$CreditPackImplCopyWithImpl<_$CreditPackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreditPackImplToJson(
      this,
    );
  }
}

abstract class _CreditPack implements CreditPack {
  const factory _CreditPack(
      {required final String id,
      required final String name,
      required final int credits,
      required final double price,
      final bool isActive}) = _$CreditPackImpl;

  factory _CreditPack.fromJson(Map<String, dynamic> json) =
      _$CreditPackImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get credits;
  @override
  double get price;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CreditPackImplCopyWith<_$CreditPackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
