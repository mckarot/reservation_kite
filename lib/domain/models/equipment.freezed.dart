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

MaintenanceHistory _$MaintenanceHistoryFromJson(Map<String, dynamic> json) {
  return _MaintenanceHistory.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceHistory {
  DateTime get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  num get cost => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MaintenanceHistoryCopyWith<MaintenanceHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceHistoryCopyWith<$Res> {
  factory $MaintenanceHistoryCopyWith(
          MaintenanceHistory value, $Res Function(MaintenanceHistory) then) =
      _$MaintenanceHistoryCopyWithImpl<$Res, MaintenanceHistory>;
  @useResult
  $Res call({DateTime date, String type, String notes, num cost});
}

/// @nodoc
class _$MaintenanceHistoryCopyWithImpl<$Res, $Val extends MaintenanceHistory>
    implements $MaintenanceHistoryCopyWith<$Res> {
  _$MaintenanceHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? type = null,
    Object? notes = null,
    Object? cost = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MaintenanceHistoryImplCopyWith<$Res>
    implements $MaintenanceHistoryCopyWith<$Res> {
  factory _$$MaintenanceHistoryImplCopyWith(_$MaintenanceHistoryImpl value,
          $Res Function(_$MaintenanceHistoryImpl) then) =
      __$$MaintenanceHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, String type, String notes, num cost});
}

/// @nodoc
class __$$MaintenanceHistoryImplCopyWithImpl<$Res>
    extends _$MaintenanceHistoryCopyWithImpl<$Res, _$MaintenanceHistoryImpl>
    implements _$$MaintenanceHistoryImplCopyWith<$Res> {
  __$$MaintenanceHistoryImplCopyWithImpl(_$MaintenanceHistoryImpl _value,
      $Res Function(_$MaintenanceHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? type = null,
    Object? notes = null,
    Object? cost = null,
  }) {
    return _then(_$MaintenanceHistoryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MaintenanceHistoryImpl implements _MaintenanceHistory {
  const _$MaintenanceHistoryImpl(
      {required this.date, required this.type, this.notes = '', this.cost = 0});

  factory _$MaintenanceHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaintenanceHistoryImplFromJson(json);

  @override
  final DateTime date;
  @override
  final String type;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final num cost;

  @override
  String toString() {
    return 'MaintenanceHistory(date: $date, type: $type, notes: $notes, cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceHistoryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cost, cost) || other.cost == cost));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, type, notes, cost);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceHistoryImplCopyWith<_$MaintenanceHistoryImpl> get copyWith =>
      __$$MaintenanceHistoryImplCopyWithImpl<_$MaintenanceHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceHistoryImplToJson(
      this,
    );
  }
}

abstract class _MaintenanceHistory implements MaintenanceHistory {
  const factory _MaintenanceHistory(
      {required final DateTime date,
      required final String type,
      final String notes,
      final num cost}) = _$MaintenanceHistoryImpl;

  factory _MaintenanceHistory.fromJson(Map<String, dynamic> json) =
      _$MaintenanceHistoryImpl.fromJson;

  @override
  DateTime get date;
  @override
  String get type;
  @override
  String get notes;
  @override
  num get cost;
  @override
  @JsonKey(ignore: true)
  _$$MaintenanceHistoryImplCopyWith<_$MaintenanceHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Equipment {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _anyToString)
  String get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'serial_number')
  String? get serialNumber => throw _privateConstructorUsedError;
  EquipmentStatus get status => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_date')
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_maintenance_date')
  DateTime? get lastMaintenanceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_history')
  List<MaintenanceHistory> get maintenanceHistory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'total_bookings')
  int get totalBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_quantity')
  int get totalQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Champs de migration (optionnels)
  @JsonKey(name: 'migrated_from')
  String? get migratedFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'migration_date')
  DateTime? get migrationDate => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'serial_number') String? serialNumber,
      EquipmentStatus status,
      String notes,
      @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
      @JsonKey(name: 'last_maintenance_date') DateTime? lastMaintenanceDate,
      @JsonKey(name: 'maintenance_history')
      List<MaintenanceHistory> maintenanceHistory,
      @JsonKey(name: 'total_bookings') int totalBookings,
      @JsonKey(name: 'total_quantity') int totalQuantity,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'migrated_from') String? migratedFrom,
      @JsonKey(name: 'migration_date') DateTime? migrationDate});
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
    Object? serialNumber = freezed,
    Object? status = null,
    Object? notes = null,
    Object? purchaseDate = freezed,
    Object? lastMaintenanceDate = freezed,
    Object? maintenanceHistory = null,
    Object? totalBookings = null,
    Object? totalQuantity = null,
    Object? updatedAt = null,
    Object? migratedFrom = freezed,
    Object? migrationDate = freezed,
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
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentStatus,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMaintenanceDate: freezed == lastMaintenanceDate
          ? _value.lastMaintenanceDate
          : lastMaintenanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maintenanceHistory: null == maintenanceHistory
          ? _value.maintenanceHistory
          : maintenanceHistory // ignore: cast_nullable_to_non_nullable
              as List<MaintenanceHistory>,
      totalBookings: null == totalBookings
          ? _value.totalBookings
          : totalBookings // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      migratedFrom: freezed == migratedFrom
          ? _value.migratedFrom
          : migratedFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      migrationDate: freezed == migrationDate
          ? _value.migrationDate
          : migrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      @JsonKey(name: 'serial_number') String? serialNumber,
      EquipmentStatus status,
      String notes,
      @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
      @JsonKey(name: 'last_maintenance_date') DateTime? lastMaintenanceDate,
      @JsonKey(name: 'maintenance_history')
      List<MaintenanceHistory> maintenanceHistory,
      @JsonKey(name: 'total_bookings') int totalBookings,
      @JsonKey(name: 'total_quantity') int totalQuantity,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'migrated_from') String? migratedFrom,
      @JsonKey(name: 'migration_date') DateTime? migrationDate});
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
    Object? serialNumber = freezed,
    Object? status = null,
    Object? notes = null,
    Object? purchaseDate = freezed,
    Object? lastMaintenanceDate = freezed,
    Object? maintenanceHistory = null,
    Object? totalBookings = null,
    Object? totalQuantity = null,
    Object? updatedAt = null,
    Object? migratedFrom = freezed,
    Object? migrationDate = freezed,
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
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EquipmentStatus,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMaintenanceDate: freezed == lastMaintenanceDate
          ? _value.lastMaintenanceDate
          : lastMaintenanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maintenanceHistory: null == maintenanceHistory
          ? _value._maintenanceHistory
          : maintenanceHistory // ignore: cast_nullable_to_non_nullable
              as List<MaintenanceHistory>,
      totalBookings: null == totalBookings
          ? _value.totalBookings
          : totalBookings // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      migratedFrom: freezed == migratedFrom
          ? _value.migratedFrom
          : migratedFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      migrationDate: freezed == migrationDate
          ? _value.migrationDate
          : migrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      @JsonKey(name: 'serial_number') this.serialNumber,
      required this.status,
      this.notes = '',
      @JsonKey(name: 'purchase_date') this.purchaseDate,
      @JsonKey(name: 'last_maintenance_date') this.lastMaintenanceDate,
      @JsonKey(name: 'maintenance_history')
      final List<MaintenanceHistory> maintenanceHistory = const [],
      @JsonKey(name: 'total_bookings') this.totalBookings = 0,
      @JsonKey(name: 'total_quantity') this.totalQuantity = 1,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'migrated_from') this.migratedFrom,
      @JsonKey(name: 'migration_date') this.migrationDate})
      : _maintenanceHistory = maintenanceHistory;

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
  @JsonKey(name: 'serial_number')
  final String? serialNumber;
  @override
  final EquipmentStatus status;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey(name: 'purchase_date')
  final DateTime? purchaseDate;
  @override
  @JsonKey(name: 'last_maintenance_date')
  final DateTime? lastMaintenanceDate;
  final List<MaintenanceHistory> _maintenanceHistory;
  @override
  @JsonKey(name: 'maintenance_history')
  List<MaintenanceHistory> get maintenanceHistory {
    if (_maintenanceHistory is EqualUnmodifiableListView)
      return _maintenanceHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_maintenanceHistory);
  }

  @override
  @JsonKey(name: 'total_bookings')
  final int totalBookings;
  @override
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Champs de migration (optionnels)
  @override
  @JsonKey(name: 'migrated_from')
  final String? migratedFrom;
  @override
  @JsonKey(name: 'migration_date')
  final DateTime? migrationDate;

  @override
  String toString() {
    return 'Equipment(id: $id, categoryId: $categoryId, brand: $brand, model: $model, size: $size, serialNumber: $serialNumber, status: $status, notes: $notes, purchaseDate: $purchaseDate, lastMaintenanceDate: $lastMaintenanceDate, maintenanceHistory: $maintenanceHistory, totalBookings: $totalBookings, totalQuantity: $totalQuantity, updatedAt: $updatedAt, migratedFrom: $migratedFrom, migrationDate: $migrationDate)';
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
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.lastMaintenanceDate, lastMaintenanceDate) ||
                other.lastMaintenanceDate == lastMaintenanceDate) &&
            const DeepCollectionEquality()
                .equals(other._maintenanceHistory, _maintenanceHistory) &&
            (identical(other.totalBookings, totalBookings) ||
                other.totalBookings == totalBookings) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.migratedFrom, migratedFrom) ||
                other.migratedFrom == migratedFrom) &&
            (identical(other.migrationDate, migrationDate) ||
                other.migrationDate == migrationDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      categoryId,
      brand,
      model,
      size,
      serialNumber,
      status,
      notes,
      purchaseDate,
      lastMaintenanceDate,
      const DeepCollectionEquality().hash(_maintenanceHistory),
      totalBookings,
      totalQuantity,
      updatedAt,
      migratedFrom,
      migrationDate);

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
          @JsonKey(name: 'serial_number') final String? serialNumber,
          required final EquipmentStatus status,
          final String notes,
          @JsonKey(name: 'purchase_date') final DateTime? purchaseDate,
          @JsonKey(name: 'last_maintenance_date')
          final DateTime? lastMaintenanceDate,
          @JsonKey(name: 'maintenance_history')
          final List<MaintenanceHistory> maintenanceHistory,
          @JsonKey(name: 'total_bookings') final int totalBookings,
          @JsonKey(name: 'total_quantity') final int totalQuantity,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt,
          @JsonKey(name: 'migrated_from') final String? migratedFrom,
          @JsonKey(name: 'migration_date') final DateTime? migrationDate}) =
      _$EquipmentImpl;

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
  @JsonKey(name: 'serial_number')
  String? get serialNumber;
  @override
  EquipmentStatus get status;
  @override
  String get notes;
  @override
  @JsonKey(name: 'purchase_date')
  DateTime? get purchaseDate;
  @override
  @JsonKey(name: 'last_maintenance_date')
  DateTime? get lastMaintenanceDate;
  @override
  @JsonKey(name: 'maintenance_history')
  List<MaintenanceHistory> get maintenanceHistory;
  @override
  @JsonKey(name: 'total_bookings')
  int get totalBookings;
  @override
  @JsonKey(name: 'total_quantity')
  int get totalQuantity;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override // Champs de migration (optionnels)
  @JsonKey(name: 'migrated_from')
  String? get migratedFrom;
  @override
  @JsonKey(name: 'migration_date')
  DateTime? get migrationDate;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
