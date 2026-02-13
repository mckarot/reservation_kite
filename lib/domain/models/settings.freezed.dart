// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchoolSettings _$SchoolSettingsFromJson(Map<String, dynamic> json) {
  return _SchoolSettings.fromJson(json);
}

/// @nodoc
mixin _$SchoolSettings {
  OpeningHours get hours => throw _privateConstructorUsedError;
  List<String> get daysOff => throw _privateConstructorUsedError;
  int get maxStudentsPerInstructor => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchoolSettingsCopyWith<SchoolSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolSettingsCopyWith<$Res> {
  factory $SchoolSettingsCopyWith(
          SchoolSettings value, $Res Function(SchoolSettings) then) =
      _$SchoolSettingsCopyWithImpl<$Res, SchoolSettings>;
  @useResult
  $Res call(
      {OpeningHours hours,
      List<String> daysOff,
      int maxStudentsPerInstructor,
      DateTime updatedAt});

  $OpeningHoursCopyWith<$Res> get hours;
}

/// @nodoc
class _$SchoolSettingsCopyWithImpl<$Res, $Val extends SchoolSettings>
    implements $SchoolSettingsCopyWith<$Res> {
  _$SchoolSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hours = null,
    Object? daysOff = null,
    Object? maxStudentsPerInstructor = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as OpeningHours,
      daysOff: null == daysOff
          ? _value.daysOff
          : daysOff // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxStudentsPerInstructor: null == maxStudentsPerInstructor
          ? _value.maxStudentsPerInstructor
          : maxStudentsPerInstructor // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OpeningHoursCopyWith<$Res> get hours {
    return $OpeningHoursCopyWith<$Res>(_value.hours, (value) {
      return _then(_value.copyWith(hours: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SchoolSettingsImplCopyWith<$Res>
    implements $SchoolSettingsCopyWith<$Res> {
  factory _$$SchoolSettingsImplCopyWith(_$SchoolSettingsImpl value,
          $Res Function(_$SchoolSettingsImpl) then) =
      __$$SchoolSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OpeningHours hours,
      List<String> daysOff,
      int maxStudentsPerInstructor,
      DateTime updatedAt});

  @override
  $OpeningHoursCopyWith<$Res> get hours;
}

/// @nodoc
class __$$SchoolSettingsImplCopyWithImpl<$Res>
    extends _$SchoolSettingsCopyWithImpl<$Res, _$SchoolSettingsImpl>
    implements _$$SchoolSettingsImplCopyWith<$Res> {
  __$$SchoolSettingsImplCopyWithImpl(
      _$SchoolSettingsImpl _value, $Res Function(_$SchoolSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hours = null,
    Object? daysOff = null,
    Object? maxStudentsPerInstructor = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SchoolSettingsImpl(
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as OpeningHours,
      daysOff: null == daysOff
          ? _value._daysOff
          : daysOff // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxStudentsPerInstructor: null == maxStudentsPerInstructor
          ? _value.maxStudentsPerInstructor
          : maxStudentsPerInstructor // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolSettingsImpl implements _SchoolSettings {
  const _$SchoolSettingsImpl(
      {required this.hours,
      final List<String> daysOff = const [],
      this.maxStudentsPerInstructor = 4,
      required this.updatedAt})
      : _daysOff = daysOff;

  factory _$SchoolSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolSettingsImplFromJson(json);

  @override
  final OpeningHours hours;
  final List<String> _daysOff;
  @override
  @JsonKey()
  List<String> get daysOff {
    if (_daysOff is EqualUnmodifiableListView) return _daysOff;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOff);
  }

  @override
  @JsonKey()
  final int maxStudentsPerInstructor;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SchoolSettings(hours: $hours, daysOff: $daysOff, maxStudentsPerInstructor: $maxStudentsPerInstructor, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolSettingsImpl &&
            (identical(other.hours, hours) || other.hours == hours) &&
            const DeepCollectionEquality().equals(other._daysOff, _daysOff) &&
            (identical(
                    other.maxStudentsPerInstructor, maxStudentsPerInstructor) ||
                other.maxStudentsPerInstructor == maxStudentsPerInstructor) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hours,
      const DeepCollectionEquality().hash(_daysOff),
      maxStudentsPerInstructor,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolSettingsImplCopyWith<_$SchoolSettingsImpl> get copyWith =>
      __$$SchoolSettingsImplCopyWithImpl<_$SchoolSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolSettingsImplToJson(
      this,
    );
  }
}

abstract class _SchoolSettings implements SchoolSettings {
  const factory _SchoolSettings(
      {required final OpeningHours hours,
      final List<String> daysOff,
      final int maxStudentsPerInstructor,
      required final DateTime updatedAt}) = _$SchoolSettingsImpl;

  factory _SchoolSettings.fromJson(Map<String, dynamic> json) =
      _$SchoolSettingsImpl.fromJson;

  @override
  OpeningHours get hours;
  @override
  List<String> get daysOff;
  @override
  int get maxStudentsPerInstructor;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SchoolSettingsImplCopyWith<_$SchoolSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return _OpeningHours.fromJson(json);
}

/// @nodoc
mixin _$OpeningHours {
  TimeSlot get morning => throw _privateConstructorUsedError;
  TimeSlot get afternoon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OpeningHoursCopyWith<OpeningHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpeningHoursCopyWith<$Res> {
  factory $OpeningHoursCopyWith(
          OpeningHours value, $Res Function(OpeningHours) then) =
      _$OpeningHoursCopyWithImpl<$Res, OpeningHours>;
  @useResult
  $Res call({TimeSlot morning, TimeSlot afternoon});

  $TimeSlotCopyWith<$Res> get morning;
  $TimeSlotCopyWith<$Res> get afternoon;
}

/// @nodoc
class _$OpeningHoursCopyWithImpl<$Res, $Val extends OpeningHours>
    implements $OpeningHoursCopyWith<$Res> {
  _$OpeningHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? morning = null,
    Object? afternoon = null,
  }) {
    return _then(_value.copyWith(
      morning: null == morning
          ? _value.morning
          : morning // ignore: cast_nullable_to_non_nullable
              as TimeSlot,
      afternoon: null == afternoon
          ? _value.afternoon
          : afternoon // ignore: cast_nullable_to_non_nullable
              as TimeSlot,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TimeSlotCopyWith<$Res> get morning {
    return $TimeSlotCopyWith<$Res>(_value.morning, (value) {
      return _then(_value.copyWith(morning: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TimeSlotCopyWith<$Res> get afternoon {
    return $TimeSlotCopyWith<$Res>(_value.afternoon, (value) {
      return _then(_value.copyWith(afternoon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpeningHoursImplCopyWith<$Res>
    implements $OpeningHoursCopyWith<$Res> {
  factory _$$OpeningHoursImplCopyWith(
          _$OpeningHoursImpl value, $Res Function(_$OpeningHoursImpl) then) =
      __$$OpeningHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TimeSlot morning, TimeSlot afternoon});

  @override
  $TimeSlotCopyWith<$Res> get morning;
  @override
  $TimeSlotCopyWith<$Res> get afternoon;
}

/// @nodoc
class __$$OpeningHoursImplCopyWithImpl<$Res>
    extends _$OpeningHoursCopyWithImpl<$Res, _$OpeningHoursImpl>
    implements _$$OpeningHoursImplCopyWith<$Res> {
  __$$OpeningHoursImplCopyWithImpl(
      _$OpeningHoursImpl _value, $Res Function(_$OpeningHoursImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? morning = null,
    Object? afternoon = null,
  }) {
    return _then(_$OpeningHoursImpl(
      morning: null == morning
          ? _value.morning
          : morning // ignore: cast_nullable_to_non_nullable
              as TimeSlot,
      afternoon: null == afternoon
          ? _value.afternoon
          : afternoon // ignore: cast_nullable_to_non_nullable
              as TimeSlot,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpeningHoursImpl implements _OpeningHours {
  const _$OpeningHoursImpl({required this.morning, required this.afternoon});

  factory _$OpeningHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpeningHoursImplFromJson(json);

  @override
  final TimeSlot morning;
  @override
  final TimeSlot afternoon;

  @override
  String toString() {
    return 'OpeningHours(morning: $morning, afternoon: $afternoon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpeningHoursImpl &&
            (identical(other.morning, morning) || other.morning == morning) &&
            (identical(other.afternoon, afternoon) ||
                other.afternoon == afternoon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, morning, afternoon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      __$$OpeningHoursImplCopyWithImpl<_$OpeningHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpeningHoursImplToJson(
      this,
    );
  }
}

abstract class _OpeningHours implements OpeningHours {
  const factory _OpeningHours(
      {required final TimeSlot morning,
      required final TimeSlot afternoon}) = _$OpeningHoursImpl;

  factory _OpeningHours.fromJson(Map<String, dynamic> json) =
      _$OpeningHoursImpl.fromJson;

  @override
  TimeSlot get morning;
  @override
  TimeSlot get afternoon;
  @override
  @JsonKey(ignore: true)
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) {
  return _TimeSlot.fromJson(json);
}

/// @nodoc
mixin _$TimeSlot {
  String get start => throw _privateConstructorUsedError; // ISO format or HH:mm
  String get end => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimeSlotCopyWith<TimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotCopyWith<$Res> {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) then) =
      _$TimeSlotCopyWithImpl<$Res, TimeSlot>;
  @useResult
  $Res call({String start, String end});
}

/// @nodoc
class _$TimeSlotCopyWithImpl<$Res, $Val extends TimeSlot>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as String,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeSlotImplCopyWith<$Res>
    implements $TimeSlotCopyWith<$Res> {
  factory _$$TimeSlotImplCopyWith(
          _$TimeSlotImpl value, $Res Function(_$TimeSlotImpl) then) =
      __$$TimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String start, String end});
}

/// @nodoc
class __$$TimeSlotImplCopyWithImpl<$Res>
    extends _$TimeSlotCopyWithImpl<$Res, _$TimeSlotImpl>
    implements _$$TimeSlotImplCopyWith<$Res> {
  __$$TimeSlotImplCopyWithImpl(
      _$TimeSlotImpl _value, $Res Function(_$TimeSlotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$TimeSlotImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as String,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotImpl implements _TimeSlot {
  const _$TimeSlotImpl({required this.start, required this.end});

  factory _$TimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotImplFromJson(json);

  @override
  final String start;
// ISO format or HH:mm
  @override
  final String end;

  @override
  String toString() {
    return 'TimeSlot(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      __$$TimeSlotImplCopyWithImpl<_$TimeSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotImplToJson(
      this,
    );
  }
}

abstract class _TimeSlot implements TimeSlot {
  const factory _TimeSlot(
      {required final String start,
      required final String end}) = _$TimeSlotImpl;

  factory _TimeSlot.fromJson(Map<String, dynamic> json) =
      _$TimeSlotImpl.fromJson;

  @override
  String get start;
  @override // ISO format or HH:mm
  String get end;
  @override
  @JsonKey(ignore: true)
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
