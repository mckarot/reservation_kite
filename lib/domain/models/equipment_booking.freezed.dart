// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EquipmentBooking _$EquipmentBookingFromJson(Map<String, dynamic> json) {
  return _EquipmentBooking.fromJson(json);
}

/// @nodoc
mixin _$EquipmentBooking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userEmail => throw _privateConstructorUsedError;
  String get equipmentId => throw _privateConstructorUsedError;
  String get equipmentType => throw _privateConstructorUsedError;
  String get equipmentBrand => throw _privateConstructorUsedError;
  String get equipmentModel => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _anyToString)
  String get equipmentSize => throw _privateConstructorUsedError;
  String get dateString => throw _privateConstructorUsedError;
  DateTime get dateTimestamp => throw _privateConstructorUsedError;
  EquipmentBookingSlot get slot => throw _privateConstructorUsedError;
  EquipmentBookingStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EquipmentBookingCopyWith<EquipmentBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentBookingCopyWith<$Res> {
  factory $EquipmentBookingCopyWith(
          EquipmentBooking value, $Res Function(EquipmentBooking) then) =
      _$EquipmentBookingCopyWithImpl<$Res, EquipmentBooking>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      String equipmentId,
      String equipmentType,
      String equipmentBrand,
      String equipmentModel,
      @JsonKey(fromJson: _anyToString) String equipmentSize,
      String dateString,
      DateTime dateTimestamp,
      EquipmentBookingSlot slot,
      EquipmentBookingStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String createdBy,
      String? sessionId,
      String? notes});
}

/// @nodoc
class _$EquipmentBookingCopyWithImpl<$Res, $Val extends EquipmentBooking>
    implements $EquipmentBookingCopyWith<$Res> {
  _$EquipmentBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? equipmentId = null,
    Object? equipmentType = null,
    Object? equipmentBrand = null,
    Object? equipmentModel = null,
    Object? equipmentSize = null,
    Object? dateString = null,
    Object? dateTimestamp = null,
    Object? slot = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = null,
    Object? sessionId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentId: null == equipmentId
          ? _value.equipmentId
          : equipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentType: null == equipmentType
          ? _value.equipmentType
          : equipmentType // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentBrand: null == equipmentBrand
          ? _value.equipmentBrand
          : equipmentBrand // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentModel: null == equipmentModel
          ? _value.equipmentModel
          : equipmentModel // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentSize: null == equipmentSize
          ? _value.equipmentSize
          : equipmentSize // ignore: cast_nullable_to_non_nullable
              as String,
      dateString: null == dateString
          ? _value.dateString
          : dateString // ignore: cast_nullable_to_non_nullable
              as String,
      dateTimestamp: null == dateTimestamp
          ? _value.dateTimestamp
          : dateTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as EquipmentBookingSlot,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentBookingStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentBookingImplCopyWith<$Res>
    implements $EquipmentBookingCopyWith<$Res> {
  factory _$$EquipmentBookingImplCopyWith(_$EquipmentBookingImpl value,
          $Res Function(_$EquipmentBookingImpl) then) =
      __$$EquipmentBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      String equipmentId,
      String equipmentType,
      String equipmentBrand,
      String equipmentModel,
      @JsonKey(fromJson: _anyToString) String equipmentSize,
      String dateString,
      DateTime dateTimestamp,
      EquipmentBookingSlot slot,
      EquipmentBookingStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String createdBy,
      String? sessionId,
      String? notes});
}

/// @nodoc
class __$$EquipmentBookingImplCopyWithImpl<$Res>
    extends _$EquipmentBookingCopyWithImpl<$Res, _$EquipmentBookingImpl>
    implements _$$EquipmentBookingImplCopyWith<$Res> {
  __$$EquipmentBookingImplCopyWithImpl(_$EquipmentBookingImpl _value,
      $Res Function(_$EquipmentBookingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? equipmentId = null,
    Object? equipmentType = null,
    Object? equipmentBrand = null,
    Object? equipmentModel = null,
    Object? equipmentSize = null,
    Object? dateString = null,
    Object? dateTimestamp = null,
    Object? slot = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = null,
    Object? sessionId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$EquipmentBookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentId: null == equipmentId
          ? _value.equipmentId
          : equipmentId // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentType: null == equipmentType
          ? _value.equipmentType
          : equipmentType // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentBrand: null == equipmentBrand
          ? _value.equipmentBrand
          : equipmentBrand // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentModel: null == equipmentModel
          ? _value.equipmentModel
          : equipmentModel // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentSize: null == equipmentSize
          ? _value.equipmentSize
          : equipmentSize // ignore: cast_nullable_to_non_nullable
              as String,
      dateString: null == dateString
          ? _value.dateString
          : dateString // ignore: cast_nullable_to_non_nullable
              as String,
      dateTimestamp: null == dateTimestamp
          ? _value.dateTimestamp
          : dateTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as EquipmentBookingSlot,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentBookingStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentBookingImpl implements _EquipmentBooking {
  const _$EquipmentBookingImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.equipmentId,
      required this.equipmentType,
      required this.equipmentBrand,
      required this.equipmentModel,
      @JsonKey(fromJson: _anyToString) required this.equipmentSize,
      required this.dateString,
      required this.dateTimestamp,
      required this.slot,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      this.sessionId,
      this.notes});

  factory _$EquipmentBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userEmail;
  @override
  final String equipmentId;
  @override
  final String equipmentType;
  @override
  final String equipmentBrand;
  @override
  final String equipmentModel;
  @override
  @JsonKey(fromJson: _anyToString)
  final String equipmentSize;
  @override
  final String dateString;
  @override
  final DateTime dateTimestamp;
  @override
  final EquipmentBookingSlot slot;
  @override
  final EquipmentBookingStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String createdBy;
  @override
  final String? sessionId;
  @override
  final String? notes;

  @override
  String toString() {
    return 'EquipmentBooking(id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, equipmentId: $equipmentId, equipmentType: $equipmentType, equipmentBrand: $equipmentBrand, equipmentModel: $equipmentModel, equipmentSize: $equipmentSize, dateString: $dateString, dateTimestamp: $dateTimestamp, slot: $slot, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, sessionId: $sessionId, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.equipmentId, equipmentId) ||
                other.equipmentId == equipmentId) &&
            (identical(other.equipmentType, equipmentType) ||
                other.equipmentType == equipmentType) &&
            (identical(other.equipmentBrand, equipmentBrand) ||
                other.equipmentBrand == equipmentBrand) &&
            (identical(other.equipmentModel, equipmentModel) ||
                other.equipmentModel == equipmentModel) &&
            (identical(other.equipmentSize, equipmentSize) ||
                other.equipmentSize == equipmentSize) &&
            (identical(other.dateString, dateString) ||
                other.dateString == dateString) &&
            (identical(other.dateTimestamp, dateTimestamp) ||
                other.dateTimestamp == dateTimestamp) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      userEmail,
      equipmentId,
      equipmentType,
      equipmentBrand,
      equipmentModel,
      equipmentSize,
      dateString,
      dateTimestamp,
      slot,
      status,
      createdAt,
      updatedAt,
      createdBy,
      sessionId,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentBookingImplCopyWith<_$EquipmentBookingImpl> get copyWith =>
      __$$EquipmentBookingImplCopyWithImpl<_$EquipmentBookingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentBookingImplToJson(
      this,
    );
  }
}

abstract class _EquipmentBooking implements EquipmentBooking {
  const factory _EquipmentBooking(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String userEmail,
      required final String equipmentId,
      required final String equipmentType,
      required final String equipmentBrand,
      required final String equipmentModel,
      @JsonKey(fromJson: _anyToString) required final String equipmentSize,
      required final String dateString,
      required final DateTime dateTimestamp,
      required final EquipmentBookingSlot slot,
      required final EquipmentBookingStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final String createdBy,
      final String? sessionId,
      final String? notes}) = _$EquipmentBookingImpl;

  factory _EquipmentBooking.fromJson(Map<String, dynamic> json) =
      _$EquipmentBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get userEmail;
  @override
  String get equipmentId;
  @override
  String get equipmentType;
  @override
  String get equipmentBrand;
  @override
  String get equipmentModel;
  @override
  @JsonKey(fromJson: _anyToString)
  String get equipmentSize;
  @override
  String get dateString;
  @override
  DateTime get dateTimestamp;
  @override
  EquipmentBookingSlot get slot;
  @override
  EquipmentBookingStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get createdBy;
  @override
  String? get sessionId;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentBookingImplCopyWith<_$EquipmentBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
