import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale> build() async {
    // Charger la langue sauvegardée
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'fr';
    return Locale(savedLocale);
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
    state = AsyncData(Locale(languageCode));
  }
}
