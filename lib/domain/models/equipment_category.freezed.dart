// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EquipmentCategory _$EquipmentCategoryFromJson(Map<String, dynamic> json) {
  return _EquipmentCategory.fromJson(json);
}

/// @nodoc
mixin _$EquipmentCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<String> get equipmentIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EquipmentCategoryCopyWith<EquipmentCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentCategoryCopyWith<$Res> {
  factory $EquipmentCategoryCopyWith(
          EquipmentCategory value, $Res Function(EquipmentCategory) then) =
      _$EquipmentCategoryCopyWithImpl<$Res, EquipmentCategory>;
  @useResult
  $Res call(
      {String id,
      String name,
      int order,
      bool isActive,
      List<String> equipmentIds});
}

/// @nodoc
class _$EquipmentCategoryCopyWithImpl<$Res, $Val extends EquipmentCategory>
    implements $EquipmentCategoryCopyWith<$Res> {
  _$EquipmentCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? isActive = null,
    Object? equipmentIds = null,
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
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      equipmentIds: null == equipmentIds
          ? _value.equipmentIds
          : equipmentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentCategoryImplCopyWith<$Res>
    implements $EquipmentCategoryCopyWith<$Res> {
  factory _$$EquipmentCategoryImplCopyWith(_$EquipmentCategoryImpl value,
          $Res Function(_$EquipmentCategoryImpl) then) =
      __$$EquipmentCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int order,
      bool isActive,
      List<String> equipmentIds});
}

/// @nodoc
class __$$EquipmentCategoryImplCopyWithImpl<$Res>
    extends _$EquipmentCategoryCopyWithImpl<$Res, _$EquipmentCategoryImpl>
    implements _$$EquipmentCategoryImplCopyWith<$Res> {
  __$$EquipmentCategoryImplCopyWithImpl(_$EquipmentCategoryImpl _value,
      $Res Function(_$EquipmentCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? isActive = null,
    Object? equipmentIds = null,
  }) {
    return _then(_$EquipmentCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      equipmentIds: null == equipmentIds
          ? _value._equipmentIds
          : equipmentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentCategoryImpl implements _EquipmentCategory {
  const _$EquipmentCategoryImpl(
      {required this.id,
      required this.name,
      required this.order,
      this.isActive = true,
      final List<String> equipmentIds = const []})
      : _equipmentIds = equipmentIds;

  factory _$EquipmentCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int order;
  @override
  @JsonKey()
  final bool isActive;
  final List<String> _equipmentIds;
  @override
  @JsonKey()
  List<String> get equipmentIds {
    if (_equipmentIds is EqualUnmodifiableListView) return _equipmentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentIds);
  }

  @override
  String toString() {
    return 'EquipmentCategory(id: $id, name: $name, order: $order, isActive: $isActive, equipmentIds: $equipmentIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other._equipmentIds, _equipmentIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, order, isActive,
      const DeepCollectionEquality().hash(_equipmentIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentCategoryImplCopyWith<_$EquipmentCategoryImpl> get copyWith =>
      __$$EquipmentCategoryImplCopyWithImpl<_$EquipmentCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentCategoryImplToJson(
      this,
    );
  }
}

abstract class _EquipmentCategory implements EquipmentCategory {
  const factory _EquipmentCategory(
      {required final String id,
      required final String name,
      required final int order,
      final bool isActive,
      final List<String> equipmentIds}) = _$EquipmentCategoryImpl;

  factory _EquipmentCategory.fromJson(Map<String, dynamic> json) =
      _$EquipmentCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get order;
  @override
  bool get isActive;
  @override
  List<String> get equipmentIds;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentCategoryImplCopyWith<_$EquipmentCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
