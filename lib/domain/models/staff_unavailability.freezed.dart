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
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'instructor_id')
  String get staffId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  TimeSlot get slot =>
      throw _privateConstructorUsedError; // morning, afternoon, or full_day?
  String get reason => throw _privateConstructorUsedError;
  UnavailabilityStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  @JsonKey(name: 'created_at')
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
      {String id,
      @JsonKey(name: 'instructor_id') String staffId,
      @TimestampConverter() DateTime date,
      TimeSlot slot,
      String reason,
      UnavailabilityStatus status,
      @TimestampConverter() @JsonKey(name: 'created_at') DateTime createdAt});
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
      {String id,
      @JsonKey(name: 'instructor_id') String staffId,
      @TimestampConverter() DateTime date,
      TimeSlot slot,
      String reason,
      UnavailabilityStatus status,
      @TimestampConverter() @JsonKey(name: 'created_at') DateTime createdAt});
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
class _$StaffUnavailabilityImpl implements _StaffUnavailability {
  const _$StaffUnavailabilityImpl(
      {required this.id,
      @JsonKey(name: 'instructor_id') required this.staffId,
      @TimestampConverter() required this.date,
      required this.slot,
      required this.reason,
      this.status = UnavailabilityStatus.pending,
      @TimestampConverter()
      @JsonKey(name: 'created_at')
      required this.createdAt});

  factory _$StaffUnavailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffUnavailabilityImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'instructor_id')
  final String staffId;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  final TimeSlot slot;
// morning, afternoon, or full_day?
  @override
  final String reason;
  @override
  @JsonKey()
  final UnavailabilityStatus status;
  @override
  @TimestampConverter()
  @JsonKey(name: 'created_at')
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
      {required final String id,
      @JsonKey(name: 'instructor_id') required final String staffId,
      @TimestampConverter() required final DateTime date,
      required final TimeSlot slot,
      required final String reason,
      final UnavailabilityStatus status,
      @TimestampConverter()
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$StaffUnavailabilityImpl;

  factory _StaffUnavailability.fromJson(Map<String, dynamic> json) =
      _$StaffUnavailabilityImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'instructor_id')
  String get staffId;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  TimeSlot get slot;
  @override // morning, afternoon, or full_day?
  String get reason;
  @override
  UnavailabilityStatus get status;
  @override
  @TimestampConverter()
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$StaffUnavailabilityImplCopyWith<_$StaffUnavailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
