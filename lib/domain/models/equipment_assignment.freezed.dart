// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EquipmentAssignment _$EquipmentAssignmentFromJson(Map<String, dynamic> json) {
  return _EquipmentAssignment.fromJson(json);
}

/// @nodoc
mixin _$EquipmentAssignment {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get studentName => throw _privateConstructorUsedError;
  String get studentEmail => throw _privateConstructorUsedError;
  String get equipmentId => throw _privateConstructorUsedError;
  String get equipmentType => throw _privateConstructorUsedError;
  String get equipmentBrand => throw _privateConstructorUsedError;
  String get equipmentModel => throw _privateConstructorUsedError;
  String get equipmentSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_string')
  String get dateString => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_timestamp')
  DateTime get dateTimestamp => throw _privateConstructorUsedError;
  String get slot => throw _privateConstructorUsedError;
  EquipmentAssignmentStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EquipmentAssignmentCopyWith<EquipmentAssignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentAssignmentCopyWith<$Res> {
  factory $EquipmentAssignmentCopyWith(
          EquipmentAssignment value, $Res Function(EquipmentAssignment) then) =
      _$EquipmentAssignmentCopyWithImpl<$Res, EquipmentAssignment>;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String studentId,
      String studentName,
      String studentEmail,
      String equipmentId,
      String equipmentType,
      String equipmentBrand,
      String equipmentModel,
      String equipmentSize,
      @JsonKey(name: 'date_string') String dateString,
      @JsonKey(name: 'date_timestamp') DateTime dateTimestamp,
      String slot,
      EquipmentAssignmentStatus status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      String createdBy,
      String? notes});
}

/// @nodoc
class _$EquipmentAssignmentCopyWithImpl<$Res, $Val extends EquipmentAssignment>
    implements $EquipmentAssignmentCopyWith<$Res> {
  _$EquipmentAssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
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
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentEmail: null == studentEmail
          ? _value.studentEmail
          : studentEmail // ignore: cast_nullable_to_non_nullable
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
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentAssignmentStatus,
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentAssignmentImplCopyWith<$Res>
    implements $EquipmentAssignmentCopyWith<$Res> {
  factory _$$EquipmentAssignmentImplCopyWith(_$EquipmentAssignmentImpl value,
          $Res Function(_$EquipmentAssignmentImpl) then) =
      __$$EquipmentAssignmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String studentId,
      String studentName,
      String studentEmail,
      String equipmentId,
      String equipmentType,
      String equipmentBrand,
      String equipmentModel,
      String equipmentSize,
      @JsonKey(name: 'date_string') String dateString,
      @JsonKey(name: 'date_timestamp') DateTime dateTimestamp,
      String slot,
      EquipmentAssignmentStatus status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      String createdBy,
      String? notes});
}

/// @nodoc
class __$$EquipmentAssignmentImplCopyWithImpl<$Res>
    extends _$EquipmentAssignmentCopyWithImpl<$Res, _$EquipmentAssignmentImpl>
    implements _$$EquipmentAssignmentImplCopyWith<$Res> {
  __$$EquipmentAssignmentImplCopyWithImpl(_$EquipmentAssignmentImpl _value,
      $Res Function(_$EquipmentAssignmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
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
    Object? notes = freezed,
  }) {
    return _then(_$EquipmentAssignmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentEmail: null == studentEmail
          ? _value.studentEmail
          : studentEmail // ignore: cast_nullable_to_non_nullable
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
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentAssignmentStatus,
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentAssignmentImpl implements _EquipmentAssignment {
  const _$EquipmentAssignmentImpl(
      {required this.id,
      required this.sessionId,
      required this.studentId,
      required this.studentName,
      required this.studentEmail,
      required this.equipmentId,
      required this.equipmentType,
      required this.equipmentBrand,
      required this.equipmentModel,
      required this.equipmentSize,
      @JsonKey(name: 'date_string') required this.dateString,
      @JsonKey(name: 'date_timestamp') required this.dateTimestamp,
      required this.slot,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      required this.createdBy,
      this.notes});

  factory _$EquipmentAssignmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentAssignmentImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String studentId;
  @override
  final String studentName;
  @override
  final String studentEmail;
  @override
  final String equipmentId;
  @override
  final String equipmentType;
  @override
  final String equipmentBrand;
  @override
  final String equipmentModel;
  @override
  final String equipmentSize;
  @override
  @JsonKey(name: 'date_string')
  final String dateString;
  @override
  @JsonKey(name: 'date_timestamp')
  final DateTime dateTimestamp;
  @override
  final String slot;
  @override
  final EquipmentAssignmentStatus status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final String createdBy;
  @override
  final String? notes;

  @override
  String toString() {
    return 'EquipmentAssignment(id: $id, sessionId: $sessionId, studentId: $studentId, studentName: $studentName, studentEmail: $studentEmail, equipmentId: $equipmentId, equipmentType: $equipmentType, equipmentBrand: $equipmentBrand, equipmentModel: $equipmentModel, equipmentSize: $equipmentSize, dateString: $dateString, dateTimestamp: $dateTimestamp, slot: $slot, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentAssignmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentEmail, studentEmail) ||
                other.studentEmail == studentEmail) &&
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
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      studentId,
      studentName,
      studentEmail,
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
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentAssignmentImplCopyWith<_$EquipmentAssignmentImpl> get copyWith =>
      __$$EquipmentAssignmentImplCopyWithImpl<_$EquipmentAssignmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentAssignmentImplToJson(
      this,
    );
  }
}

abstract class _EquipmentAssignment implements EquipmentAssignment {
  const factory _EquipmentAssignment(
      {required final String id,
      required final String sessionId,
      required final String studentId,
      required final String studentName,
      required final String studentEmail,
      required final String equipmentId,
      required final String equipmentType,
      required final String equipmentBrand,
      required final String equipmentModel,
      required final String equipmentSize,
      @JsonKey(name: 'date_string') required final String dateString,
      @JsonKey(name: 'date_timestamp') required final DateTime dateTimestamp,
      required final String slot,
      required final EquipmentAssignmentStatus status,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      required final String createdBy,
      final String? notes}) = _$EquipmentAssignmentImpl;

  factory _EquipmentAssignment.fromJson(Map<String, dynamic> json) =
      _$EquipmentAssignmentImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  String get studentId;
  @override
  String get studentName;
  @override
  String get studentEmail;
  @override
  String get equipmentId;
  @override
  String get equipmentType;
  @override
  String get equipmentBrand;
  @override
  String get equipmentModel;
  @override
  String get equipmentSize;
  @override
  @JsonKey(name: 'date_string')
  String get dateString;
  @override
  @JsonKey(name: 'date_timestamp')
  DateTime get dateTimestamp;
  @override
  String get slot;
  @override
  EquipmentAssignmentStatus get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  String get createdBy;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentAssignmentImplCopyWith<_$EquipmentAssignmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
