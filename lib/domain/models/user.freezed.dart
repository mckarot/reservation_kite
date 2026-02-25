// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  int? get weight => throw _privateConstructorUsedError;
  @JsonKey(name: 'wallet_balance')
  int get walletBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_credits_purchased')
  int get totalCreditsPurchased => throw _privateConstructorUsedError;
  UserProgress? get progress => throw _privateConstructorUsedError;
  @TimestampConverter()
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  @JsonKey(name: 'last_seen')
  DateTime get lastSeen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'display_name') String displayName,
      String email,
      @JsonKey(name: 'photo_url') String? photoUrl,
      String role,
      int? weight,
      @JsonKey(name: 'wallet_balance') int walletBalance,
      @JsonKey(name: 'total_credits_purchased') int totalCreditsPurchased,
      UserProgress? progress,
      @TimestampConverter() @JsonKey(name: 'created_at') DateTime createdAt,
      @TimestampConverter() @JsonKey(name: 'last_seen') DateTime lastSeen});

  $UserProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = null,
    Object? photoUrl = freezed,
    Object? role = null,
    Object? weight = freezed,
    Object? walletBalance = null,
    Object? totalCreditsPurchased = null,
    Object? progress = freezed,
    Object? createdAt = null,
    Object? lastSeen = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int?,
      walletBalance: null == walletBalance
          ? _value.walletBalance
          : walletBalance // ignore: cast_nullable_to_non_nullable
              as int,
      totalCreditsPurchased: null == totalCreditsPurchased
          ? _value.totalCreditsPurchased
          : totalCreditsPurchased // ignore: cast_nullable_to_non_nullable
              as int,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as UserProgress?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProgressCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $UserProgressCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'display_name') String displayName,
      String email,
      @JsonKey(name: 'photo_url') String? photoUrl,
      String role,
      int? weight,
      @JsonKey(name: 'wallet_balance') int walletBalance,
      @JsonKey(name: 'total_credits_purchased') int totalCreditsPurchased,
      UserProgress? progress,
      @TimestampConverter() @JsonKey(name: 'created_at') DateTime createdAt,
      @TimestampConverter() @JsonKey(name: 'last_seen') DateTime lastSeen});

  @override
  $UserProgressCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = null,
    Object? photoUrl = freezed,
    Object? role = null,
    Object? weight = freezed,
    Object? walletBalance = null,
    Object? totalCreditsPurchased = null,
    Object? progress = freezed,
    Object? createdAt = null,
    Object? lastSeen = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int?,
      walletBalance: null == walletBalance
          ? _value.walletBalance
          : walletBalance // ignore: cast_nullable_to_non_nullable
              as int,
      totalCreditsPurchased: null == totalCreditsPurchased
          ? _value.totalCreditsPurchased
          : totalCreditsPurchased // ignore: cast_nullable_to_non_nullable
              as int,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as UserProgress?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      @JsonKey(name: 'display_name') required this.displayName,
      required this.email,
      @JsonKey(name: 'photo_url') this.photoUrl,
      this.role = 'student',
      this.weight,
      @JsonKey(name: 'wallet_balance') this.walletBalance = 0,
      @JsonKey(name: 'total_credits_purchased') this.totalCreditsPurchased = 0,
      this.progress,
      @TimestampConverter()
      @JsonKey(name: 'created_at')
      required this.createdAt,
      @TimestampConverter()
      @JsonKey(name: 'last_seen')
      required this.lastSeen});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  final String email;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey()
  final String role;
  @override
  final int? weight;
  @override
  @JsonKey(name: 'wallet_balance')
  final int walletBalance;
  @override
  @JsonKey(name: 'total_credits_purchased')
  final int totalCreditsPurchased;
  @override
  final UserProgress? progress;
  @override
  @TimestampConverter()
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @TimestampConverter()
  @JsonKey(name: 'last_seen')
  final DateTime lastSeen;

  @override
  String toString() {
    return 'User(id: $id, displayName: $displayName, email: $email, photoUrl: $photoUrl, role: $role, weight: $weight, walletBalance: $walletBalance, totalCreditsPurchased: $totalCreditsPurchased, progress: $progress, createdAt: $createdAt, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.walletBalance, walletBalance) ||
                other.walletBalance == walletBalance) &&
            (identical(other.totalCreditsPurchased, totalCreditsPurchased) ||
                other.totalCreditsPurchased == totalCreditsPurchased) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      displayName,
      email,
      photoUrl,
      role,
      weight,
      walletBalance,
      totalCreditsPurchased,
      progress,
      createdAt,
      lastSeen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      @JsonKey(name: 'display_name') required final String displayName,
      required final String email,
      @JsonKey(name: 'photo_url') final String? photoUrl,
      final String role,
      final int? weight,
      @JsonKey(name: 'wallet_balance') final int walletBalance,
      @JsonKey(name: 'total_credits_purchased') final int totalCreditsPurchased,
      final UserProgress? progress,
      @TimestampConverter()
      @JsonKey(name: 'created_at')
      required final DateTime createdAt,
      @TimestampConverter()
      @JsonKey(name: 'last_seen')
      required final DateTime lastSeen}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  String get email;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  String get role;
  @override
  int? get weight;
  @override
  @JsonKey(name: 'wallet_balance')
  int get walletBalance;
  @override
  @JsonKey(name: 'total_credits_purchased')
  int get totalCreditsPurchased;
  @override
  UserProgress? get progress;
  @override
  @TimestampConverter()
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @TimestampConverter()
  @JsonKey(name: 'last_seen')
  DateTime get lastSeen;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) {
  return _UserProgress.fromJson(json);
}

/// @nodoc
mixin _$UserProgress {
  @JsonKey(name: 'iko_level')
  String? get ikoLevel => throw _privateConstructorUsedError;
  List<String> get checklist => throw _privateConstructorUsedError;
  List<UserNote> get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProgressCopyWith<UserProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProgressCopyWith<$Res> {
  factory $UserProgressCopyWith(
          UserProgress value, $Res Function(UserProgress) then) =
      _$UserProgressCopyWithImpl<$Res, UserProgress>;
  @useResult
  $Res call(
      {@JsonKey(name: 'iko_level') String? ikoLevel,
      List<String> checklist,
      List<UserNote> notes});
}

/// @nodoc
class _$UserProgressCopyWithImpl<$Res, $Val extends UserProgress>
    implements $UserProgressCopyWith<$Res> {
  _$UserProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ikoLevel = freezed,
    Object? checklist = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      ikoLevel: freezed == ikoLevel
          ? _value.ikoLevel
          : ikoLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      checklist: null == checklist
          ? _value.checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<UserNote>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProgressImplCopyWith<$Res>
    implements $UserProgressCopyWith<$Res> {
  factory _$$UserProgressImplCopyWith(
          _$UserProgressImpl value, $Res Function(_$UserProgressImpl) then) =
      __$$UserProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'iko_level') String? ikoLevel,
      List<String> checklist,
      List<UserNote> notes});
}

/// @nodoc
class __$$UserProgressImplCopyWithImpl<$Res>
    extends _$UserProgressCopyWithImpl<$Res, _$UserProgressImpl>
    implements _$$UserProgressImplCopyWith<$Res> {
  __$$UserProgressImplCopyWithImpl(
      _$UserProgressImpl _value, $Res Function(_$UserProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ikoLevel = freezed,
    Object? checklist = null,
    Object? notes = null,
  }) {
    return _then(_$UserProgressImpl(
      ikoLevel: freezed == ikoLevel
          ? _value.ikoLevel
          : ikoLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      checklist: null == checklist
          ? _value._checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<UserNote>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProgressImpl implements _UserProgress {
  const _$UserProgressImpl(
      {@JsonKey(name: 'iko_level') this.ikoLevel,
      final List<String> checklist = const [],
      final List<UserNote> notes = const []})
      : _checklist = checklist,
        _notes = notes;

  factory _$UserProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProgressImplFromJson(json);

  @override
  @JsonKey(name: 'iko_level')
  final String? ikoLevel;
  final List<String> _checklist;
  @override
  @JsonKey()
  List<String> get checklist {
    if (_checklist is EqualUnmodifiableListView) return _checklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checklist);
  }

  final List<UserNote> _notes;
  @override
  @JsonKey()
  List<UserNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  String toString() {
    return 'UserProgress(ikoLevel: $ikoLevel, checklist: $checklist, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProgressImpl &&
            (identical(other.ikoLevel, ikoLevel) ||
                other.ikoLevel == ikoLevel) &&
            const DeepCollectionEquality()
                .equals(other._checklist, _checklist) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ikoLevel,
      const DeepCollectionEquality().hash(_checklist),
      const DeepCollectionEquality().hash(_notes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      __$$UserProgressImplCopyWithImpl<_$UserProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProgressImplToJson(
      this,
    );
  }
}

abstract class _UserProgress implements UserProgress {
  const factory _UserProgress(
      {@JsonKey(name: 'iko_level') final String? ikoLevel,
      final List<String> checklist,
      final List<UserNote> notes}) = _$UserProgressImpl;

  factory _UserProgress.fromJson(Map<String, dynamic> json) =
      _$UserProgressImpl.fromJson;

  @override
  @JsonKey(name: 'iko_level')
  String? get ikoLevel;
  @override
  List<String> get checklist;
  @override
  List<UserNote> get notes;
  @override
  @JsonKey(ignore: true)
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserNote _$UserNoteFromJson(Map<String, dynamic> json) {
  return _UserNote.fromJson(json);
}

/// @nodoc
mixin _$UserNote {
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'instructor_id')
  String get instructorId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserNoteCopyWith<UserNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNoteCopyWith<$Res> {
  factory $UserNoteCopyWith(UserNote value, $Res Function(UserNote) then) =
      _$UserNoteCopyWithImpl<$Res, UserNote>;
  @useResult
  $Res call(
      {@TimestampConverter() DateTime date,
      String content,
      @JsonKey(name: 'instructor_id') String instructorId});
}

/// @nodoc
class _$UserNoteCopyWithImpl<$Res, $Val extends UserNote>
    implements $UserNoteCopyWith<$Res> {
  _$UserNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? content = null,
    Object? instructorId = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      instructorId: null == instructorId
          ? _value.instructorId
          : instructorId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserNoteImplCopyWith<$Res>
    implements $UserNoteCopyWith<$Res> {
  factory _$$UserNoteImplCopyWith(
          _$UserNoteImpl value, $Res Function(_$UserNoteImpl) then) =
      __$$UserNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@TimestampConverter() DateTime date,
      String content,
      @JsonKey(name: 'instructor_id') String instructorId});
}

/// @nodoc
class __$$UserNoteImplCopyWithImpl<$Res>
    extends _$UserNoteCopyWithImpl<$Res, _$UserNoteImpl>
    implements _$$UserNoteImplCopyWith<$Res> {
  __$$UserNoteImplCopyWithImpl(
      _$UserNoteImpl _value, $Res Function(_$UserNoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? content = null,
    Object? instructorId = null,
  }) {
    return _then(_$UserNoteImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      instructorId: null == instructorId
          ? _value.instructorId
          : instructorId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNoteImpl implements _UserNote {
  const _$UserNoteImpl(
      {@TimestampConverter() required this.date,
      required this.content,
      @JsonKey(name: 'instructor_id') required this.instructorId});

  factory _$UserNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserNoteImplFromJson(json);

  @override
  @TimestampConverter()
  final DateTime date;
  @override
  final String content;
  @override
  @JsonKey(name: 'instructor_id')
  final String instructorId;

  @override
  String toString() {
    return 'UserNote(date: $date, content: $content, instructorId: $instructorId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNoteImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.instructorId, instructorId) ||
                other.instructorId == instructorId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, content, instructorId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNoteImplCopyWith<_$UserNoteImpl> get copyWith =>
      __$$UserNoteImplCopyWithImpl<_$UserNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNoteImplToJson(
      this,
    );
  }
}

abstract class _UserNote implements UserNote {
  const factory _UserNote(
          {@TimestampConverter() required final DateTime date,
          required final String content,
          @JsonKey(name: 'instructor_id') required final String instructorId}) =
      _$UserNoteImpl;

  factory _UserNote.fromJson(Map<String, dynamic> json) =
      _$UserNoteImpl.fromJson;

  @override
  @TimestampConverter()
  DateTime get date;
  @override
  String get content;
  @override
  @JsonKey(name: 'instructor_id')
  String get instructorId;
  @override
  @JsonKey(ignore: true)
  _$$UserNoteImplCopyWith<_$UserNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
