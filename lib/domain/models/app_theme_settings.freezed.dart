// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppThemeSettings _$AppThemeSettingsFromJson(Map<String, dynamic> json) {
  return _AppThemeSettings.fromJson(json);
}

/// @nodoc
mixin _$AppThemeSettings {
  /// Mode du thème : light, dark, ou system
  @JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  /// Couleur principale (primaire)
  int get primaryColor => throw _privateConstructorUsedError;

  /// Couleur secondaire
  int get secondaryColor => throw _privateConstructorUsedError;

  /// Couleur d'accent
  int get accentColor => throw _privateConstructorUsedError;

  /// Couleur de fond personnalisée (optionnelle)
  int? get backgroundColor => throw _privateConstructorUsedError;

  /// Couleur de surface personnalisée (optionnelle)
  int? get surfaceColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppThemeSettingsCopyWith<AppThemeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeSettingsCopyWith<$Res> {
  factory $AppThemeSettingsCopyWith(
          AppThemeSettings value, $Res Function(AppThemeSettings) then) =
      _$AppThemeSettingsCopyWithImpl<$Res, AppThemeSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
      ThemeMode themeMode,
      int primaryColor,
      int secondaryColor,
      int accentColor,
      int? backgroundColor,
      int? surfaceColor});
}

/// @nodoc
class _$AppThemeSettingsCopyWithImpl<$Res, $Val extends AppThemeSettings>
    implements $AppThemeSettingsCopyWith<$Res> {
  _$AppThemeSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? accentColor = null,
    Object? backgroundColor = freezed,
    Object? surfaceColor = freezed,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as int,
      backgroundColor: freezed == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as int?,
      surfaceColor: freezed == surfaceColor
          ? _value.surfaceColor
          : surfaceColor // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppThemeSettingsImplCopyWith<$Res>
    implements $AppThemeSettingsCopyWith<$Res> {
  factory _$$AppThemeSettingsImplCopyWith(_$AppThemeSettingsImpl value,
          $Res Function(_$AppThemeSettingsImpl) then) =
      __$$AppThemeSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
      ThemeMode themeMode,
      int primaryColor,
      int secondaryColor,
      int accentColor,
      int? backgroundColor,
      int? surfaceColor});
}

/// @nodoc
class __$$AppThemeSettingsImplCopyWithImpl<$Res>
    extends _$AppThemeSettingsCopyWithImpl<$Res, _$AppThemeSettingsImpl>
    implements _$$AppThemeSettingsImplCopyWith<$Res> {
  __$$AppThemeSettingsImplCopyWithImpl(_$AppThemeSettingsImpl _value,
      $Res Function(_$AppThemeSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? accentColor = null,
    Object? backgroundColor = freezed,
    Object? surfaceColor = freezed,
  }) {
    return _then(_$AppThemeSettingsImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as int,
      backgroundColor: freezed == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as int?,
      surfaceColor: freezed == surfaceColor
          ? _value.surfaceColor
          : surfaceColor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppThemeSettingsImpl implements _AppThemeSettings {
  const _$AppThemeSettingsImpl(
      {@JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
      this.themeMode = ThemeMode.system,
      this.primaryColor = 0xFF1976D2,
      this.secondaryColor = 0xFF42A5F5,
      this.accentColor = 0xFF00BCD4,
      this.backgroundColor,
      this.surfaceColor});

  factory _$AppThemeSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppThemeSettingsImplFromJson(json);

  /// Mode du thème : light, dark, ou system
  @override
  @JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
  final ThemeMode themeMode;

  /// Couleur principale (primaire)
  @override
  @JsonKey()
  final int primaryColor;

  /// Couleur secondaire
  @override
  @JsonKey()
  final int secondaryColor;

  /// Couleur d'accent
  @override
  @JsonKey()
  final int accentColor;

  /// Couleur de fond personnalisée (optionnelle)
  @override
  final int? backgroundColor;

  /// Couleur de surface personnalisée (optionnelle)
  @override
  final int? surfaceColor;

  @override
  String toString() {
    return 'AppThemeSettings(themeMode: $themeMode, primaryColor: $primaryColor, secondaryColor: $secondaryColor, accentColor: $accentColor, backgroundColor: $backgroundColor, surfaceColor: $surfaceColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppThemeSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.surfaceColor, surfaceColor) ||
                other.surfaceColor == surfaceColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, themeMode, primaryColor,
      secondaryColor, accentColor, backgroundColor, surfaceColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppThemeSettingsImplCopyWith<_$AppThemeSettingsImpl> get copyWith =>
      __$$AppThemeSettingsImplCopyWithImpl<_$AppThemeSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppThemeSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppThemeSettings implements AppThemeSettings {
  const factory _AppThemeSettings(
      {@JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
      final ThemeMode themeMode,
      final int primaryColor,
      final int secondaryColor,
      final int accentColor,
      final int? backgroundColor,
      final int? surfaceColor}) = _$AppThemeSettingsImpl;

  factory _AppThemeSettings.fromJson(Map<String, dynamic> json) =
      _$AppThemeSettingsImpl.fromJson;

  @override

  /// Mode du thème : light, dark, ou system
  @JsonKey(name: 'themeMode', unknownEnumValue: ThemeMode.system)
  ThemeMode get themeMode;
  @override

  /// Couleur principale (primaire)
  int get primaryColor;
  @override

  /// Couleur secondaire
  int get secondaryColor;
  @override

  /// Couleur d'accent
  int get accentColor;
  @override

  /// Couleur de fond personnalisée (optionnelle)
  int? get backgroundColor;
  @override

  /// Couleur de surface personnalisée (optionnelle)
  int? get surfaceColor;
  @override
  @JsonKey(ignore: true)
  _$$AppThemeSettingsImplCopyWith<_$AppThemeSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
