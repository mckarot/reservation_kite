// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_unavailability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffUnavailability _$StaffUnavailabilityFromJson(Map<String, dynamic> json) {
  return _StaffUnavailability.fromJson(json);
}

/// @nodoc
mixin _$StaffUnavailability {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get staffId => throw _privateConstructorUsedError;
  @HiveField(2)
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(3)
  TimeSlot get slot =>
      throw _privateConstructorUsedError; // morning, afternoon, or full_day?
// On va considérer que TimeSlot couvre morning/afternoon.
// Pour une journée entière, on créera deux entrées ou on ajoutera une option.
// Restons simple avec morning/afternoon.
  @HiveField(4)
  String get reason => throw _privateConstructorUsedError;
  @HiveField(5)
  UnavailabilityStatus get status => throw _privateConstructorUsedError;
  @HiveField(6)
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StaffUnavailabilityCopyWith<StaffUnavailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffUnavailabilityCopyWith<$Res> {
  factory $StaffUnavailabilityCopyWith(
          StaffUnavailability value, $Res Function(StaffUnavailability) then) =
      _$StaffUnavailabilityCopyWithImpl<$Res, StaffUnavailability>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String staffId,
      @HiveField(2) @TimestampConverter() DateTime date,
      @HiveField(3) TimeSlot slot,
      @HiveField(4) String reason,
      @HiveField(5) UnavailabilityStatus status,
      @HiveField(6) @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$StaffUnavailabilityCopyWithImpl<$Res, $Val extends StaffUnavailability>
    implements $StaffUnavailabilityCopyWith<$Res> {
  _$StaffUnavailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? staffId = null,
    Object? date = null,
    Object? slot = null,
    Object? reason = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as TimeSlot,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UnavailabilityStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffUnavailabilityImplCopyWith<$Res>
    implements $StaffUnavailabilityCopyWith<$Res> {
  factory _$$StaffUnavailabilityImplCopyWith(_$StaffUnavailabilityImpl value,
          $Res Function(_$StaffUnavailabilityImpl) then) =
      __$$StaffUnavailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String staffId,
      @HiveField(2) @TimestampConverter() DateTime date,
      @HiveField(3) TimeSlot slot,
      @HiveField(4) String reason,
      @HiveField(5) UnavailabilityStatus status,
      @HiveField(6) @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$StaffUnavailabilityImplCopyWithImpl<$Res>
    extends _$StaffUnavailabilityCopyWithImpl<$Res, _$StaffUnavailabilityImpl>
    implements _$$StaffUnavailabilityImplCopyWith<$Res> {
  __$$StaffUnavailabilityImplCopyWithImpl(_$StaffUnavailabilityImpl _value,
      $Res Function(_$StaffUnavailabilityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? staffId = null,
    Object? date = null,
    Object? slot = null,
    Object? reason = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_$StaffUnavailabilityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as TimeSlot,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UnavailabilityStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 11)
class _$StaffUnavailabilityImpl implements _StaffUnavailability {
  const _$StaffUnavailabilityImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.staffId,
      @HiveField(2) @TimestampConverter() required this.date,
      @HiveField(3) required this.slot,
      @HiveField(4) required this.reason,
      @HiveField(5) this.status = UnavailabilityStatus.pending,
      @HiveField(6) @TimestampConverter() required this.createdAt});

  factory _$StaffUnavailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffUnavailabilityImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String staffId;
  @override
  @HiveField(2)
  @TimestampConverter()
  final DateTime date;
  @override
  @HiveField(3)
  final TimeSlot slot;
// morning, afternoon, or full_day?
// On va considérer que TimeSlot couvre morning/afternoon.
// Pour une journée entière, on créera deux entrées ou on ajoutera une option.
// Restons simple avec morning/afternoon.
  @override
  @HiveField(4)
  final String reason;
  @override
  @JsonKey()
  @HiveField(5)
  final UnavailabilityStatus status;
  @override
  @HiveField(6)
  @TimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'StaffUnavailability(id: $id, staffId: $staffId, date: $date, slot: $slot, reason: $reason, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffUnavailabilityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, staffId, date, slot, reason, status, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffUnavailabilityImplCopyWith<_$StaffUnavailabilityImpl> get copyWith =>
      __$$StaffUnavailabilityImplCopyWithImpl<_$StaffUnavailabilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffUnavailabilityImplToJson(
      this,
    );
  }
}

abstract class _StaffUnavailability implements StaffUnavailability {
  const factory _StaffUnavailability(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String staffId,
      @HiveField(2) @TimestampConverter() required final DateTime date,
      @HiveField(3) required final TimeSlot slot,
      @HiveField(4) required final String reason,
      @HiveField(5) final UnavailabilityStatus status,
      @HiveField(6)
      @TimestampConverter()
      required final DateTime createdAt}) = _$StaffUnavailabilityImpl;

  factory _StaffUnavailability.fromJson(Map<String, dynamic> json) =
      _$StaffUnavailabilityImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get staffId;
  @override
  @HiveField(2)
  @TimestampConverter()
  DateTime get date;
  @override
  @HiveField(3)
  TimeSlot get slot;
  @override // morning, afternoon, or full_day?
// On va considérer que TimeSlot couvre morning/afternoon.
// Pour une journée entière, on créera deux entrées ou on ajoutera une option.
// Restons simple avec morning/afternoon.
  @HiveField(4)
  String get reason;
  @override
  @HiveField(5)
  UnavailabilityStatus get status;
  @override
  @HiveField(6)
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$StaffUnavailabilityImplCopyWith<_$StaffUnavailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
