// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppThemeSettingsImpl _$$AppThemeSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$AppThemeSettingsImpl(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode'],
              unknownValue: ThemeMode.system) ??
          ThemeMode.system,
      primaryColor: (json['primary_color'] as num?)?.toInt() ?? 0xFF1976D2,
      secondaryColor: (json['secondary_color'] as num?)?.toInt() ?? 0xFF42A5F5,
      accentColor: (json['accent_color'] as num?)?.toInt() ?? 0xFF00BCD4,
      backgroundColor: (json['background_color'] as num?)?.toInt(),
      surfaceColor: (json['surface_color'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AppThemeSettingsImplToJson(
        _$AppThemeSettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'primary_color': instance.primaryColor,
      'secondary_color': instance.secondaryColor,
      'accent_color': instance.accentColor,
      'background_color': instance.backgroundColor,
      'surface_color': instance.surfaceColor,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
