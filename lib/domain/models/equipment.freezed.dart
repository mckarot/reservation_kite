// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Equipment {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _anyToString)
  String get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_quantity')
  int get totalQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  EquipmentStatus get status => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EquipmentCopyWith<Equipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentCopyWith<$Res> {
  factory $EquipmentCopyWith(Equipment value, $Res Function(Equipment) then) =
      _$EquipmentCopyWithImpl<$Res, Equipment>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'category_id') String categoryId,
      String brand,
      String model,
      @JsonKey(fromJson: _anyToString) String size,
      @JsonKey(name: 'total_quantity') int totalQuantity,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      EquipmentStatus status,
      String notes});
}

/// @nodoc
class _$EquipmentCopyWithImpl<$Res, $Val extends Equipment>
    implements $EquipmentCopyWith<$Res> {
  _$EquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? brand = null,
    Object? model = null,
    Object? size = null,
    Object? totalQuantity = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentStatus,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentImplCopyWith<$Res>
    implements $EquipmentCopyWith<$Res> {
  factory _$$EquipmentImplCopyWith(
          _$EquipmentImpl value, $Res Function(_$EquipmentImpl) then) =
      __$$EquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'category_id') String categoryId,
      String brand,
      String model,
      @JsonKey(fromJson: _anyToString) String size,
      @JsonKey(name: 'total_quantity') int totalQuantity,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      EquipmentStatus status,
      String notes});
}

/// @nodoc
class __$$EquipmentImplCopyWithImpl<$Res>
    extends _$EquipmentCopyWithImpl<$Res, _$EquipmentImpl>
    implements _$$EquipmentImplCopyWith<$Res> {
  __$$EquipmentImplCopyWithImpl(
      _$EquipmentImpl _value, $Res Function(_$EquipmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? brand = null,
    Object? model = null,
    Object? size = null,
    Object? totalQuantity = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? notes = null,
  }) {
    return _then(_$EquipmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentStatus,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EquipmentImpl implements _Equipment {
  const _$EquipmentImpl(
      {required this.id,
      @JsonKey(name: 'category_id') required this.categoryId,
      required this.brand,
      required this.model,
      @JsonKey(fromJson: _anyToString) required this.size,
      @JsonKey(name: 'total_quantity') this.totalQuantity = 1,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.status = EquipmentStatus.available,
      this.notes = ''});

  @override
  final String id;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final String brand;
  @override
  final String model;
  @override
  @JsonKey(fromJson: _anyToString)
  final String size;
  @override
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey()
  final EquipmentStatus status;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'Equipment(id: $id, categoryId: $categoryId, brand: $brand, model: $model, size: $size, totalQuantity: $totalQuantity, updatedAt: $updatedAt, status: $status, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, categoryId, brand, model,
      size, totalQuantity, updatedAt, status, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      __$$EquipmentImplCopyWithImpl<_$EquipmentImpl>(this, _$identity);
}

abstract class _Equipment implements Equipment {
  const factory _Equipment(
      {required final String id,
      @JsonKey(name: 'category_id') required final String categoryId,
      required final String brand,
      required final String model,
      @JsonKey(fromJson: _anyToString) required final String size,
      @JsonKey(name: 'total_quantity') final int totalQuantity,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final EquipmentStatus status,
      final String notes}) = _$EquipmentImpl;

  @override
  String get id;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  String get brand;
  @override
  String get model;
  @override
  @JsonKey(fromJson: _anyToString)
  String get size;
  @override
  @JsonKey(name: 'total_quantity')
  int get totalQuantity;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  EquipmentStatus get status;
  @override
  String get notes;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
