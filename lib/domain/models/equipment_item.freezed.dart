// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EquipmentItem _$EquipmentItemFromJson(Map<String, dynamic> json) {
  return _EquipmentItem.fromJson(json);
}

/// @nodoc
mixin _$EquipmentItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
  EquipmentCategoryType get category => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  double get size => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get serialNumber => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  int get purchasePrice => throw _privateConstructorUsedError;
  int get rentalPriceMorning => throw _privateConstructorUsedError;
  int get rentalPriceAfternoon => throw _privateConstructorUsedError;
  int get rentalPriceFullDay => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
  EquipmentCurrentStatus get currentStatus =>
      throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: EquipmentCondition.good)
  EquipmentCondition get condition => throw _privateConstructorUsedError;
  int get totalRentals => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get lastMaintenanceDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get nextMaintenanceDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EquipmentItemCopyWith<EquipmentItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentItemCopyWith<$Res> {
  factory $EquipmentItemCopyWith(
          EquipmentItem value, $Res Function(EquipmentItem) then) =
      _$EquipmentItemCopyWithImpl<$Res, EquipmentItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
      EquipmentCategoryType category,
      String brand,
      String model,
      double size,
      String? color,
      String? serialNumber,
      @TimestampConverter() DateTime? purchaseDate,
      int purchasePrice,
      int rentalPriceMorning,
      int rentalPriceAfternoon,
      int rentalPriceFullDay,
      bool isActive,
      @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
      EquipmentCurrentStatus currentStatus,
      @JsonKey(unknownEnumValue: EquipmentCondition.good)
      EquipmentCondition condition,
      int totalRentals,
      @TimestampConverter() DateTime? lastMaintenanceDate,
      @TimestampConverter() DateTime? nextMaintenanceDate,
      String? notes,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$EquipmentItemCopyWithImpl<$Res, $Val extends EquipmentItem>
    implements $EquipmentItemCopyWith<$Res> {
  _$EquipmentItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? brand = null,
    Object? model = null,
    Object? size = null,
    Object? color = freezed,
    Object? serialNumber = freezed,
    Object? purchaseDate = freezed,
    Object? purchasePrice = null,
    Object? rentalPriceMorning = null,
    Object? rentalPriceAfternoon = null,
    Object? rentalPriceFullDay = null,
    Object? isActive = null,
    Object? currentStatus = null,
    Object? condition = null,
    Object? totalRentals = null,
    Object? lastMaintenanceDate = freezed,
    Object? nextMaintenanceDate = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EquipmentCategoryType,
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
              as double,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as int,
      rentalPriceMorning: null == rentalPriceMorning
          ? _value.rentalPriceMorning
          : rentalPriceMorning // ignore: cast_nullable_to_non_nullable
              as int,
      rentalPriceAfternoon: null == rentalPriceAfternoon
          ? _value.rentalPriceAfternoon
          : rentalPriceAfternoon // ignore: cast_nullable_to_non_nullable
              as int,
      rentalPriceFullDay: null == rentalPriceFullDay
          ? _value.rentalPriceFullDay
          : rentalPriceFullDay // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStatus: null == currentStatus
          ? _value.currentStatus
          : currentStatus // ignore: cast_nullable_to_non_nullable
              as EquipmentCurrentStatus,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as EquipmentCondition,
      totalRentals: null == totalRentals
          ? _value.totalRentals
          : totalRentals // ignore: cast_nullable_to_non_nullable
              as int,
      lastMaintenanceDate: freezed == lastMaintenanceDate
          ? _value.lastMaintenanceDate
          : lastMaintenanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextMaintenanceDate: freezed == nextMaintenanceDate
          ? _value.nextMaintenanceDate
          : nextMaintenanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentItemImplCopyWith<$Res>
    implements $EquipmentItemCopyWith<$Res> {
  factory _$$EquipmentItemImplCopyWith(
          _$EquipmentItemImpl value, $Res Function(_$EquipmentItemImpl) then) =
      __$$EquipmentItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
      EquipmentCategoryType category,
      String brand,
      String model,
      double size,
      String? color,
      String? serialNumber,
      @TimestampConverter() DateTime? purchaseDate,
      int purchasePrice,
      int rentalPriceMorning,
      int rentalPriceAfternoon,
      int rentalPriceFullDay,
      bool isActive,
      @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
      EquipmentCurrentStatus currentStatus,
      @JsonKey(unknownEnumValue: EquipmentCondition.good)
      EquipmentCondition condition,
      int totalRentals,
      @TimestampConverter() DateTime? lastMaintenanceDate,
      @TimestampConverter() DateTime? nextMaintenanceDate,
      String? notes,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$EquipmentItemImplCopyWithImpl<$Res>
    extends _$EquipmentItemCopyWithImpl<$Res, _$EquipmentItemImpl>
    implements _$$EquipmentItemImplCopyWith<$Res> {
  __$$EquipmentItemImplCopyWithImpl(
      _$EquipmentItemImpl _value, $Res Function(_$EquipmentItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? brand = null,
    Object? model = null,
    Object? size = null,
    Object? color = freezed,
    Object? serialNumber = freezed,
    Object? purchaseDate = freezed,
    Object? purchasePrice = null,
    Object? rentalPriceMorning = null,
    Object? rentalPriceAfternoon = null,
    Object? rentalPriceFullDay = null,
    Object? isActive = null,
    Object? currentStatus = null,
    Object? condition = null,
    Object? totalRentals = null,
    Object? lastMaintenanceDate = freezed,
    Object? nextMaintenanceDate = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$EquipmentItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EquipmentCategoryType,
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
              as double,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as int,
      rentalPriceMorning: null == rentalPriceMorning
          ? _value.rentalPriceMorning
          : rentalPriceMorning // ignore: cast_nullable_to_non_nullable
              as int,
      rentalPriceAfternoon: null == rentalPriceAfternoon
          ? _value.rentalPriceAfternoon
          : rentalPriceAfternoon // ignore: cast_nullable_to_non_nullable
              as int,
      rentalPriceFullDay: null == rentalPriceFullDay
          ? _value.rentalPriceFullDay
          : rentalPriceFullDay // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStatus: null == currentStatus
          ? _value.currentStatus
          : currentStatus // ignore: cast_nullable_to_non_nullable
              as EquipmentCurrentStatus,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as EquipmentCondition,
      totalRentals: null == totalRentals
          ? _value.totalRentals
          : totalRentals // ignore: cast_nullable_to_non_nullable
              as int,
      lastMaintenanceDate: freezed == lastMaintenanceDate
          ? _value.lastMaintenanceDate
          : lastMaintenanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextMaintenanceDate: freezed == nextMaintenanceDate
          ? _value.nextMaintenanceDate
          : nextMaintenanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentItemImpl implements _EquipmentItem {
  const _$EquipmentItemImpl(
      {required this.id,
      required this.name,
      @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
      required this.category,
      required this.brand,
      required this.model,
      required this.size,
      this.color,
      this.serialNumber,
      @TimestampConverter() this.purchaseDate,
      required this.purchasePrice,
      required this.rentalPriceMorning,
      required this.rentalPriceAfternoon,
      required this.rentalPriceFullDay,
      this.isActive = true,
      @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
      this.currentStatus = EquipmentCurrentStatus.available,
      @JsonKey(unknownEnumValue: EquipmentCondition.good)
      this.condition = EquipmentCondition.good,
      this.totalRentals = 0,
      @TimestampConverter() this.lastMaintenanceDate,
      @TimestampConverter() this.nextMaintenanceDate,
      this.notes,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt});

  factory _$EquipmentItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
  final EquipmentCategoryType category;
  @override
  final String brand;
  @override
  final String model;
  @override
  final double size;
  @override
  final String? color;
  @override
  final String? serialNumber;
  @override
  @TimestampConverter()
  final DateTime? purchaseDate;
  @override
  final int purchasePrice;
  @override
  final int rentalPriceMorning;
  @override
  final int rentalPriceAfternoon;
  @override
  final int rentalPriceFullDay;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
  final EquipmentCurrentStatus currentStatus;
  @override
  @JsonKey(unknownEnumValue: EquipmentCondition.good)
  final EquipmentCondition condition;
  @override
  @JsonKey()
  final int totalRentals;
  @override
  @TimestampConverter()
  final DateTime? lastMaintenanceDate;
  @override
  @TimestampConverter()
  final DateTime? nextMaintenanceDate;
  @override
  final String? notes;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EquipmentItem(id: $id, name: $name, category: $category, brand: $brand, model: $model, size: $size, color: $color, serialNumber: $serialNumber, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, rentalPriceMorning: $rentalPriceMorning, rentalPriceAfternoon: $rentalPriceAfternoon, rentalPriceFullDay: $rentalPriceFullDay, isActive: $isActive, currentStatus: $currentStatus, condition: $condition, totalRentals: $totalRentals, lastMaintenanceDate: $lastMaintenanceDate, nextMaintenanceDate: $nextMaintenanceDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.rentalPriceMorning, rentalPriceMorning) ||
                other.rentalPriceMorning == rentalPriceMorning) &&
            (identical(other.rentalPriceAfternoon, rentalPriceAfternoon) ||
                other.rentalPriceAfternoon == rentalPriceAfternoon) &&
            (identical(other.rentalPriceFullDay, rentalPriceFullDay) ||
                other.rentalPriceFullDay == rentalPriceFullDay) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.currentStatus, currentStatus) ||
                other.currentStatus == currentStatus) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.totalRentals, totalRentals) ||
                other.totalRentals == totalRentals) &&
            (identical(other.lastMaintenanceDate, lastMaintenanceDate) ||
                other.lastMaintenanceDate == lastMaintenanceDate) &&
            (identical(other.nextMaintenanceDate, nextMaintenanceDate) ||
                other.nextMaintenanceDate == nextMaintenanceDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        category,
        brand,
        model,
        size,
        color,
        serialNumber,
        purchaseDate,
        purchasePrice,
        rentalPriceMorning,
        rentalPriceAfternoon,
        rentalPriceFullDay,
        isActive,
        currentStatus,
        condition,
        totalRentals,
        lastMaintenanceDate,
        nextMaintenanceDate,
        notes,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentItemImplCopyWith<_$EquipmentItemImpl> get copyWith =>
      __$$EquipmentItemImplCopyWithImpl<_$EquipmentItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentItemImplToJson(
      this,
    );
  }
}

abstract class _EquipmentItem implements EquipmentItem {
  const factory _EquipmentItem(
          {required final String id,
          required final String name,
          @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
          required final EquipmentCategoryType category,
          required final String brand,
          required final String model,
          required final double size,
          final String? color,
          final String? serialNumber,
          @TimestampConverter() final DateTime? purchaseDate,
          required final int purchasePrice,
          required final int rentalPriceMorning,
          required final int rentalPriceAfternoon,
          required final int rentalPriceFullDay,
          final bool isActive,
          @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
          final EquipmentCurrentStatus currentStatus,
          @JsonKey(unknownEnumValue: EquipmentCondition.good)
          final EquipmentCondition condition,
          final int totalRentals,
          @TimestampConverter() final DateTime? lastMaintenanceDate,
          @TimestampConverter() final DateTime? nextMaintenanceDate,
          final String? notes,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$EquipmentItemImpl;

  factory _EquipmentItem.fromJson(Map<String, dynamic> json) =
      _$EquipmentItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(unknownEnumValue: EquipmentCategoryType.other)
  EquipmentCategoryType get category;
  @override
  String get brand;
  @override
  String get model;
  @override
  double get size;
  @override
  String? get color;
  @override
  String? get serialNumber;
  @override
  @TimestampConverter()
  DateTime? get purchaseDate;
  @override
  int get purchasePrice;
  @override
  int get rentalPriceMorning;
  @override
  int get rentalPriceAfternoon;
  @override
  int get rentalPriceFullDay;
  @override
  bool get isActive;
  @override
  @JsonKey(unknownEnumValue: EquipmentCurrentStatus.available)
  EquipmentCurrentStatus get currentStatus;
  @override
  @JsonKey(unknownEnumValue: EquipmentCondition.good)
  EquipmentCondition get condition;
  @override
  int get totalRentals;
  @override
  @TimestampConverter()
  DateTime? get lastMaintenanceDate;
  @override
  @TimestampConverter()
  DateTime? get nextMaintenanceDate;
  @override
  String? get notes;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentItemImplCopyWith<_$EquipmentItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
