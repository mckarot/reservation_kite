// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_rental.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EquipmentRental _$EquipmentRentalFromJson(Map<String, dynamic> json) {
  return _EquipmentRental.fromJson(json);
}

/// @nodoc
mixin _$EquipmentRental {
  String get id => throw _privateConstructorUsedError; // Élève
  String get studentId => throw _privateConstructorUsedError;
  String get studentName => throw _privateConstructorUsedError;
  String get studentEmail =>
      throw _privateConstructorUsedError; // Équipement (dénormalisé)
  String get equipmentId => throw _privateConstructorUsedError;
  String get equipmentName => throw _privateConstructorUsedError;
  String get equipmentCategory => throw _privateConstructorUsedError;
  String get equipmentBrand => throw _privateConstructorUsedError;
  String get equipmentModel => throw _privateConstructorUsedError;
  double get equipmentSize =>
      throw _privateConstructorUsedError; // Période — double stockage pour requêtes Firestore
  String get dateString => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get dateTimestamp => throw _privateConstructorUsedError;
  TimeSlot get slot => throw _privateConstructorUsedError; // Type d'affectation
  AssignmentType get assignmentType =>
      throw _privateConstructorUsedError; // Statut
  RentalStatus get status =>
      throw _privateConstructorUsedError; // Prix — null pour admin/instructor assignments
  int? get totalPrice => throw _privateConstructorUsedError;
  PaymentStatus? get paymentStatus =>
      throw _privateConstructorUsedError; // Contexte (FK → reservations)
  String? get reservationId => throw _privateConstructorUsedError;
  String get bookedBy => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get bookedAt =>
      throw _privateConstructorUsedError; // Assignment Admin
  @TimestampConverter()
  DateTime? get adminAssignedAt => throw _privateConstructorUsedError;
  String? get adminAssignedBy => throw _privateConstructorUsedError;
  String? get adminAssignmentNotes =>
      throw _privateConstructorUsedError; // Assignment Moniteur
  @TimestampConverter()
  DateTime? get instructorAssignedAt => throw _privateConstructorUsedError;
  String? get instructorAssignedBy =>
      throw _privateConstructorUsedError; // Check-out / Check-in
  @TimestampConverter()
  DateTime? get checkedOutAt => throw _privateConstructorUsedError;
  String? get checkedOutBy => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get checkedInAt => throw _privateConstructorUsedError;
  String? get checkedInBy =>
      throw _privateConstructorUsedError; // État matériel
  String? get conditionAtCheckout => throw _privateConstructorUsedError;
  String? get conditionAtCheckin => throw _privateConstructorUsedError;
  String? get damageNotes => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EquipmentRentalCopyWith<EquipmentRental> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentRentalCopyWith<$Res> {
  factory $EquipmentRentalCopyWith(
          EquipmentRental value, $Res Function(EquipmentRental) then) =
      _$EquipmentRentalCopyWithImpl<$Res, EquipmentRental>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String studentName,
      String studentEmail,
      String equipmentId,
      String equipmentName,
      String equipmentCategory,
      String equipmentBrand,
      String equipmentModel,
      double equipmentSize,
      String dateString,
      @TimestampConverter() DateTime dateTimestamp,
      TimeSlot slot,
      AssignmentType assignmentType,
      RentalStatus status,
      int? totalPrice,
      PaymentStatus? paymentStatus,
      String? reservationId,
      String bookedBy,
      @TimestampConverter() DateTime bookedAt,
      @TimestampConverter() DateTime? adminAssignedAt,
      String? adminAssignedBy,
      String? adminAssignmentNotes,
      @TimestampConverter() DateTime? instructorAssignedAt,
      String? instructorAssignedBy,
      @TimestampConverter() DateTime? checkedOutAt,
      String? checkedOutBy,
      @TimestampConverter() DateTime? checkedInAt,
      String? checkedInBy,
      String? conditionAtCheckout,
      String? conditionAtCheckin,
      String? damageNotes,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$EquipmentRentalCopyWithImpl<$Res, $Val extends EquipmentRental>
    implements $EquipmentRentalCopyWith<$Res> {
  _$EquipmentRentalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
    Object? equipmentId = null,
    Object? equipmentName = null,
    Object? equipmentCategory = null,
    Object? equipmentBrand = null,
    Object? equipmentModel = null,
    Object? equipmentSize = null,
    Object? dateString = null,
    Object? dateTimestamp = null,
    Object? slot = null,
    Object? assignmentType = null,
    Object? status = null,
    Object? totalPrice = freezed,
    Object? paymentStatus = freezed,
    Object? reservationId = freezed,
    Object? bookedBy = null,
    Object? bookedAt = null,
    Object? adminAssignedAt = freezed,
    Object? adminAssignedBy = freezed,
    Object? adminAssignmentNotes = freezed,
    Object? instructorAssignedAt = freezed,
    Object? instructorAssignedBy = freezed,
    Object? checkedOutAt = freezed,
    Object? checkedOutBy = freezed,
    Object? checkedInAt = freezed,
    Object? checkedInBy = freezed,
    Object? conditionAtCheckout = freezed,
    Object? conditionAtCheckin = freezed,
    Object? damageNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      equipmentName: null == equipmentName
          ? _value.equipmentName
          : equipmentName // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentCategory: null == equipmentCategory
          ? _value.equipmentCategory
          : equipmentCategory // ignore: cast_nullable_to_non_nullable
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
              as double,
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
              as TimeSlot,
      assignmentType: null == assignmentType
          ? _value.assignmentType
          : assignmentType // ignore: cast_nullable_to_non_nullable
              as AssignmentType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RentalStatus,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus?,
      reservationId: freezed == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookedBy: null == bookedBy
          ? _value.bookedBy
          : bookedBy // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      adminAssignedAt: freezed == adminAssignedAt
          ? _value.adminAssignedAt
          : adminAssignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adminAssignedBy: freezed == adminAssignedBy
          ? _value.adminAssignedBy
          : adminAssignedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      adminAssignmentNotes: freezed == adminAssignmentNotes
          ? _value.adminAssignmentNotes
          : adminAssignmentNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorAssignedAt: freezed == instructorAssignedAt
          ? _value.instructorAssignedAt
          : instructorAssignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      instructorAssignedBy: freezed == instructorAssignedBy
          ? _value.instructorAssignedBy
          : instructorAssignedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      checkedOutAt: freezed == checkedOutAt
          ? _value.checkedOutAt
          : checkedOutAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkedOutBy: freezed == checkedOutBy
          ? _value.checkedOutBy
          : checkedOutBy // ignore: cast_nullable_to_non_nullable
              as String?,
      checkedInAt: freezed == checkedInAt
          ? _value.checkedInAt
          : checkedInAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkedInBy: freezed == checkedInBy
          ? _value.checkedInBy
          : checkedInBy // ignore: cast_nullable_to_non_nullable
              as String?,
      conditionAtCheckout: freezed == conditionAtCheckout
          ? _value.conditionAtCheckout
          : conditionAtCheckout // ignore: cast_nullable_to_non_nullable
              as String?,
      conditionAtCheckin: freezed == conditionAtCheckin
          ? _value.conditionAtCheckin
          : conditionAtCheckin // ignore: cast_nullable_to_non_nullable
              as String?,
      damageNotes: freezed == damageNotes
          ? _value.damageNotes
          : damageNotes // ignore: cast_nullable_to_non_nullable
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
abstract class _$$EquipmentRentalImplCopyWith<$Res>
    implements $EquipmentRentalCopyWith<$Res> {
  factory _$$EquipmentRentalImplCopyWith(_$EquipmentRentalImpl value,
          $Res Function(_$EquipmentRentalImpl) then) =
      __$$EquipmentRentalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String studentName,
      String studentEmail,
      String equipmentId,
      String equipmentName,
      String equipmentCategory,
      String equipmentBrand,
      String equipmentModel,
      double equipmentSize,
      String dateString,
      @TimestampConverter() DateTime dateTimestamp,
      TimeSlot slot,
      AssignmentType assignmentType,
      RentalStatus status,
      int? totalPrice,
      PaymentStatus? paymentStatus,
      String? reservationId,
      String bookedBy,
      @TimestampConverter() DateTime bookedAt,
      @TimestampConverter() DateTime? adminAssignedAt,
      String? adminAssignedBy,
      String? adminAssignmentNotes,
      @TimestampConverter() DateTime? instructorAssignedAt,
      String? instructorAssignedBy,
      @TimestampConverter() DateTime? checkedOutAt,
      String? checkedOutBy,
      @TimestampConverter() DateTime? checkedInAt,
      String? checkedInBy,
      String? conditionAtCheckout,
      String? conditionAtCheckin,
      String? damageNotes,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$EquipmentRentalImplCopyWithImpl<$Res>
    extends _$EquipmentRentalCopyWithImpl<$Res, _$EquipmentRentalImpl>
    implements _$$EquipmentRentalImplCopyWith<$Res> {
  __$$EquipmentRentalImplCopyWithImpl(
      _$EquipmentRentalImpl _value, $Res Function(_$EquipmentRentalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
    Object? equipmentId = null,
    Object? equipmentName = null,
    Object? equipmentCategory = null,
    Object? equipmentBrand = null,
    Object? equipmentModel = null,
    Object? equipmentSize = null,
    Object? dateString = null,
    Object? dateTimestamp = null,
    Object? slot = null,
    Object? assignmentType = null,
    Object? status = null,
    Object? totalPrice = freezed,
    Object? paymentStatus = freezed,
    Object? reservationId = freezed,
    Object? bookedBy = null,
    Object? bookedAt = null,
    Object? adminAssignedAt = freezed,
    Object? adminAssignedBy = freezed,
    Object? adminAssignmentNotes = freezed,
    Object? instructorAssignedAt = freezed,
    Object? instructorAssignedBy = freezed,
    Object? checkedOutAt = freezed,
    Object? checkedOutBy = freezed,
    Object? checkedInAt = freezed,
    Object? checkedInBy = freezed,
    Object? conditionAtCheckout = freezed,
    Object? conditionAtCheckin = freezed,
    Object? damageNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$EquipmentRentalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      equipmentName: null == equipmentName
          ? _value.equipmentName
          : equipmentName // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentCategory: null == equipmentCategory
          ? _value.equipmentCategory
          : equipmentCategory // ignore: cast_nullable_to_non_nullable
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
              as double,
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
              as TimeSlot,
      assignmentType: null == assignmentType
          ? _value.assignmentType
          : assignmentType // ignore: cast_nullable_to_non_nullable
              as AssignmentType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RentalStatus,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus?,
      reservationId: freezed == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookedBy: null == bookedBy
          ? _value.bookedBy
          : bookedBy // ignore: cast_nullable_to_non_nullable
              as String,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      adminAssignedAt: freezed == adminAssignedAt
          ? _value.adminAssignedAt
          : adminAssignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adminAssignedBy: freezed == adminAssignedBy
          ? _value.adminAssignedBy
          : adminAssignedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      adminAssignmentNotes: freezed == adminAssignmentNotes
          ? _value.adminAssignmentNotes
          : adminAssignmentNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorAssignedAt: freezed == instructorAssignedAt
          ? _value.instructorAssignedAt
          : instructorAssignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      instructorAssignedBy: freezed == instructorAssignedBy
          ? _value.instructorAssignedBy
          : instructorAssignedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      checkedOutAt: freezed == checkedOutAt
          ? _value.checkedOutAt
          : checkedOutAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkedOutBy: freezed == checkedOutBy
          ? _value.checkedOutBy
          : checkedOutBy // ignore: cast_nullable_to_non_nullable
              as String?,
      checkedInAt: freezed == checkedInAt
          ? _value.checkedInAt
          : checkedInAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkedInBy: freezed == checkedInBy
          ? _value.checkedInBy
          : checkedInBy // ignore: cast_nullable_to_non_nullable
              as String?,
      conditionAtCheckout: freezed == conditionAtCheckout
          ? _value.conditionAtCheckout
          : conditionAtCheckout // ignore: cast_nullable_to_non_nullable
              as String?,
      conditionAtCheckin: freezed == conditionAtCheckin
          ? _value.conditionAtCheckin
          : conditionAtCheckin // ignore: cast_nullable_to_non_nullable
              as String?,
      damageNotes: freezed == damageNotes
          ? _value.damageNotes
          : damageNotes // ignore: cast_nullable_to_non_nullable
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
class _$EquipmentRentalImpl implements _EquipmentRental {
  const _$EquipmentRentalImpl(
      {required this.id,
      required this.studentId,
      required this.studentName,
      required this.studentEmail,
      required this.equipmentId,
      required this.equipmentName,
      required this.equipmentCategory,
      required this.equipmentBrand,
      required this.equipmentModel,
      required this.equipmentSize,
      required this.dateString,
      @TimestampConverter() required this.dateTimestamp,
      required this.slot,
      required this.assignmentType,
      this.status = RentalStatus.pending,
      this.totalPrice,
      this.paymentStatus,
      this.reservationId,
      required this.bookedBy,
      @TimestampConverter() required this.bookedAt,
      @TimestampConverter() this.adminAssignedAt,
      this.adminAssignedBy,
      this.adminAssignmentNotes,
      @TimestampConverter() this.instructorAssignedAt,
      this.instructorAssignedBy,
      @TimestampConverter() this.checkedOutAt,
      this.checkedOutBy,
      @TimestampConverter() this.checkedInAt,
      this.checkedInBy,
      this.conditionAtCheckout,
      this.conditionAtCheckin,
      this.damageNotes,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt});

  factory _$EquipmentRentalImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentRentalImplFromJson(json);

  @override
  final String id;
// Élève
  @override
  final String studentId;
  @override
  final String studentName;
  @override
  final String studentEmail;
// Équipement (dénormalisé)
  @override
  final String equipmentId;
  @override
  final String equipmentName;
  @override
  final String equipmentCategory;
  @override
  final String equipmentBrand;
  @override
  final String equipmentModel;
  @override
  final double equipmentSize;
// Période — double stockage pour requêtes Firestore
  @override
  final String dateString;
  @override
  @TimestampConverter()
  final DateTime dateTimestamp;
  @override
  final TimeSlot slot;
// Type d'affectation
  @override
  final AssignmentType assignmentType;
// Statut
  @override
  @JsonKey()
  final RentalStatus status;
// Prix — null pour admin/instructor assignments
  @override
  final int? totalPrice;
  @override
  final PaymentStatus? paymentStatus;
// Contexte (FK → reservations)
  @override
  final String? reservationId;
  @override
  final String bookedBy;
  @override
  @TimestampConverter()
  final DateTime bookedAt;
// Assignment Admin
  @override
  @TimestampConverter()
  final DateTime? adminAssignedAt;
  @override
  final String? adminAssignedBy;
  @override
  final String? adminAssignmentNotes;
// Assignment Moniteur
  @override
  @TimestampConverter()
  final DateTime? instructorAssignedAt;
  @override
  final String? instructorAssignedBy;
// Check-out / Check-in
  @override
  @TimestampConverter()
  final DateTime? checkedOutAt;
  @override
  final String? checkedOutBy;
  @override
  @TimestampConverter()
  final DateTime? checkedInAt;
  @override
  final String? checkedInBy;
// État matériel
  @override
  final String? conditionAtCheckout;
  @override
  final String? conditionAtCheckin;
  @override
  final String? damageNotes;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EquipmentRental(id: $id, studentId: $studentId, studentName: $studentName, studentEmail: $studentEmail, equipmentId: $equipmentId, equipmentName: $equipmentName, equipmentCategory: $equipmentCategory, equipmentBrand: $equipmentBrand, equipmentModel: $equipmentModel, equipmentSize: $equipmentSize, dateString: $dateString, dateTimestamp: $dateTimestamp, slot: $slot, assignmentType: $assignmentType, status: $status, totalPrice: $totalPrice, paymentStatus: $paymentStatus, reservationId: $reservationId, bookedBy: $bookedBy, bookedAt: $bookedAt, adminAssignedAt: $adminAssignedAt, adminAssignedBy: $adminAssignedBy, adminAssignmentNotes: $adminAssignmentNotes, instructorAssignedAt: $instructorAssignedAt, instructorAssignedBy: $instructorAssignedBy, checkedOutAt: $checkedOutAt, checkedOutBy: $checkedOutBy, checkedInAt: $checkedInAt, checkedInBy: $checkedInBy, conditionAtCheckout: $conditionAtCheckout, conditionAtCheckin: $conditionAtCheckin, damageNotes: $damageNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentRentalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentEmail, studentEmail) ||
                other.studentEmail == studentEmail) &&
            (identical(other.equipmentId, equipmentId) ||
                other.equipmentId == equipmentId) &&
            (identical(other.equipmentName, equipmentName) ||
                other.equipmentName == equipmentName) &&
            (identical(other.equipmentCategory, equipmentCategory) ||
                other.equipmentCategory == equipmentCategory) &&
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
            (identical(other.assignmentType, assignmentType) ||
                other.assignmentType == assignmentType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.bookedBy, bookedBy) ||
                other.bookedBy == bookedBy) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt) &&
            (identical(other.adminAssignedAt, adminAssignedAt) ||
                other.adminAssignedAt == adminAssignedAt) &&
            (identical(other.adminAssignedBy, adminAssignedBy) ||
                other.adminAssignedBy == adminAssignedBy) &&
            (identical(other.adminAssignmentNotes, adminAssignmentNotes) ||
                other.adminAssignmentNotes == adminAssignmentNotes) &&
            (identical(other.instructorAssignedAt, instructorAssignedAt) ||
                other.instructorAssignedAt == instructorAssignedAt) &&
            (identical(other.instructorAssignedBy, instructorAssignedBy) ||
                other.instructorAssignedBy == instructorAssignedBy) &&
            (identical(other.checkedOutAt, checkedOutAt) ||
                other.checkedOutAt == checkedOutAt) &&
            (identical(other.checkedOutBy, checkedOutBy) ||
                other.checkedOutBy == checkedOutBy) &&
            (identical(other.checkedInAt, checkedInAt) ||
                other.checkedInAt == checkedInAt) &&
            (identical(other.checkedInBy, checkedInBy) ||
                other.checkedInBy == checkedInBy) &&
            (identical(other.conditionAtCheckout, conditionAtCheckout) ||
                other.conditionAtCheckout == conditionAtCheckout) &&
            (identical(other.conditionAtCheckin, conditionAtCheckin) ||
                other.conditionAtCheckin == conditionAtCheckin) &&
            (identical(other.damageNotes, damageNotes) ||
                other.damageNotes == damageNotes) &&
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
        studentId,
        studentName,
        studentEmail,
        equipmentId,
        equipmentName,
        equipmentCategory,
        equipmentBrand,
        equipmentModel,
        equipmentSize,
        dateString,
        dateTimestamp,
        slot,
        assignmentType,
        status,
        totalPrice,
        paymentStatus,
        reservationId,
        bookedBy,
        bookedAt,
        adminAssignedAt,
        adminAssignedBy,
        adminAssignmentNotes,
        instructorAssignedAt,
        instructorAssignedBy,
        checkedOutAt,
        checkedOutBy,
        checkedInAt,
        checkedInBy,
        conditionAtCheckout,
        conditionAtCheckin,
        damageNotes,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentRentalImplCopyWith<_$EquipmentRentalImpl> get copyWith =>
      __$$EquipmentRentalImplCopyWithImpl<_$EquipmentRentalImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentRentalImplToJson(
      this,
    );
  }
}

abstract class _EquipmentRental implements EquipmentRental {
  const factory _EquipmentRental(
          {required final String id,
          required final String studentId,
          required final String studentName,
          required final String studentEmail,
          required final String equipmentId,
          required final String equipmentName,
          required final String equipmentCategory,
          required final String equipmentBrand,
          required final String equipmentModel,
          required final double equipmentSize,
          required final String dateString,
          @TimestampConverter() required final DateTime dateTimestamp,
          required final TimeSlot slot,
          required final AssignmentType assignmentType,
          final RentalStatus status,
          final int? totalPrice,
          final PaymentStatus? paymentStatus,
          final String? reservationId,
          required final String bookedBy,
          @TimestampConverter() required final DateTime bookedAt,
          @TimestampConverter() final DateTime? adminAssignedAt,
          final String? adminAssignedBy,
          final String? adminAssignmentNotes,
          @TimestampConverter() final DateTime? instructorAssignedAt,
          final String? instructorAssignedBy,
          @TimestampConverter() final DateTime? checkedOutAt,
          final String? checkedOutBy,
          @TimestampConverter() final DateTime? checkedInAt,
          final String? checkedInBy,
          final String? conditionAtCheckout,
          final String? conditionAtCheckin,
          final String? damageNotes,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$EquipmentRentalImpl;

  factory _EquipmentRental.fromJson(Map<String, dynamic> json) =
      _$EquipmentRentalImpl.fromJson;

  @override
  String get id;
  @override // Élève
  String get studentId;
  @override
  String get studentName;
  @override
  String get studentEmail;
  @override // Équipement (dénormalisé)
  String get equipmentId;
  @override
  String get equipmentName;
  @override
  String get equipmentCategory;
  @override
  String get equipmentBrand;
  @override
  String get equipmentModel;
  @override
  double get equipmentSize;
  @override // Période — double stockage pour requêtes Firestore
  String get dateString;
  @override
  @TimestampConverter()
  DateTime get dateTimestamp;
  @override
  TimeSlot get slot;
  @override // Type d'affectation
  AssignmentType get assignmentType;
  @override // Statut
  RentalStatus get status;
  @override // Prix — null pour admin/instructor assignments
  int? get totalPrice;
  @override
  PaymentStatus? get paymentStatus;
  @override // Contexte (FK → reservations)
  String? get reservationId;
  @override
  String get bookedBy;
  @override
  @TimestampConverter()
  DateTime get bookedAt;
  @override // Assignment Admin
  @TimestampConverter()
  DateTime? get adminAssignedAt;
  @override
  String? get adminAssignedBy;
  @override
  String? get adminAssignmentNotes;
  @override // Assignment Moniteur
  @TimestampConverter()
  DateTime? get instructorAssignedAt;
  @override
  String? get instructorAssignedBy;
  @override // Check-out / Check-in
  @TimestampConverter()
  DateTime? get checkedOutAt;
  @override
  String? get checkedOutBy;
  @override
  @TimestampConverter()
  DateTime? get checkedInAt;
  @override
  String? get checkedInBy;
  @override // État matériel
  String? get conditionAtCheckout;
  @override
  String? get conditionAtCheckin;
  @override
  String? get damageNotes;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentRentalImplCopyWith<_$EquipmentRentalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
