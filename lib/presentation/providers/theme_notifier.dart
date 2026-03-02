import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/theme_repository.dart';
import '../../data/sources/theme_global_datasource.dart';
import '../../data/sources/theme_local_datasource.dart';
import '../../domain/models/app_theme_settings.dart';
import '../../domain/models/theme_config.dart';
import '../../domain/models/theme_preset.dart';

/// Provider pour la DataSource locale
final themeLocalDataSourceProvider = Provider<ThemeLocalDataSource>((ref) {
  return ThemeLocalDataSource();
});

/// Provider pour la DataSource globale (Firestore)
final themeGlobalDataSourceProvider = Provider<ThemeGlobalDataSource>((ref) {
  return ThemeGlobalDataSource();
});

/// Provider pour le Repository (combine local + global)
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final local = ref.watch(themeLocalDataSourceProvider);
  final global = ref.watch(themeGlobalDataSourceProvider);
  return ThemeRepository(local, global);
});

/// Provider pour le Notifier (StateNotifier)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AsyncValue<AppThemeSettings>>((ref) {
  final repository = ref.watch(themeRepositoryProvider);
  return ThemeNotifier(repository);
});

/// Stream Provider pour écouter les changements de thème global en temps réel
final globalThemeStreamProvider = StreamProvider<ThemeConfig>((ref) {
  final dataSource = ref.watch(themeGlobalDataSourceProvider);
  return dataSource.watchConfig();
});

/// StateNotifier pour la gestion du thème
class ThemeNotifier extends StateNotifier<AsyncValue<AppThemeSettings>> {
  final ThemeRepository _repository;
  String? _currentUserId;
  StreamSubscription<AppThemeSettings>? _subscription;

  ThemeNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
    _listenToChanges();
  }

  /// Initialiser le thème
  Future<void> _init() async {
    try {
      final settings = await _repository.getThemeSettings();
      state = AsyncValue.data(settings);
    } catch (e) {
      debugPrint('Erreur lors du chargement du thème: $e');
      state = AsyncValue.data(AppThemeSettings.defaults());
    }
  }

  /// Écouter les changements de thème global en temps réel
  void _listenToChanges() {
    _subscription = _repository.watchThemeSettings().listen(
      (settings) {
        // Garder le mode local mais mettre à jour les couleurs globales
        final currentMode = state.value?.themeMode ?? ThemeMode.system;
        state = AsyncValue.data(
          settings.copyWith(themeMode: currentMode),
        );
        debugPrint('🎨 Thème mis à jour via stream: ${settings.primaryColor}');
      },
      onError: (e) {
        debugPrint('Erreur stream thème: $e');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Définir l'ID de l'utilisateur connecté (pour tracking)
  void setCurrentUserId(String? userId) {
    _currentUserId = userId;
  }

  /// Définir le mode du thème (LOCAL - chaque utilisateur choisit)
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final current = state.value;
      if (current == null) return;

      final newSettings = current.copyWith(themeMode: mode);
      state = AsyncValue.data(newSettings);
      await _repository.updateThemeMode(mode);
      debugPrint('Mode du thème mis à jour (LOCAL): $mode');
    } catch (e) {
      debugPrint('Erreur lors de la définition du mode du thème: $e');
    }
  }

  /// Définir la couleur principale (GLOBAL - Firestore, admin seulement)
  Future<void> setPrimaryColor(Color color) async {
    try {
      await _repository.updateColors(
        primaryColor: color.value,
        updatedBy: _currentUserId,
      );
      // Le stream mettra à jour automatiquement
      debugPrint('Couleur principale mise à jour (GLOBAL)');
    } catch (e) {
      debugPrint('Erreur lors de la définition de la couleur principale: $e');
      rethrow;
    }
  }

  /// Définir la couleur secondaire (GLOBAL - Firestore, admin seulement)
  Future<void> setSecondaryColor(Color color) async {
    try {
      await _repository.updateColors(
        secondaryColor: color.value,
        updatedBy: _currentUserId,
      );
      debugPrint('Couleur secondaire mise à jour (GLOBAL)');
    } catch (e) {
      debugPrint('Erreur lors de la définition de la couleur secondaire: $e');
      rethrow;
    }
  }

  /// Définir la couleur d'accent (GLOBAL - Firestore, admin seulement)
  Future<void> setAccentColor(Color color) async {
    try {
      await _repository.updateColors(
        accentColor: color.value,
        updatedBy: _currentUserId,
      );
      debugPrint('Couleur d\'accent mis à jour (GLOBAL)');
    } catch (e) {
      debugPrint('Erreur lors de la définition de la couleur d\'accent: $e');
      rethrow;
    }
  }

  /// Appliquer un préréglage de thème (GLOBAL - Firestore, admin seulement)
  Future<void> applyPreset(ThemePreset preset) async {
    try {
      await _repository.applyPreset(preset, updatedBy: _currentUserId);
      debugPrint('Preset appliqué (GLOBAL): ${preset.name}');
    } catch (e) {
      debugPrint('Erreur lors de l\'application du préréglage: $e');
      rethrow;
    }
  }

  /// Réinitialiser aux paramètres par défaut (GLOBAL - Firestore, admin seulement)
  Future<void> resetToDefaults() async {
    try {
      await _repository.resetColorsToDefaults(updatedBy: _currentUserId);
      debugPrint('Couleurs réinitialisées (GLOBAL)');
    } catch (e) {
      debugPrint('Erreur lors de la réinitialisation: $e');
      rethrow;
    }
  }

  /// Recharger les paramètres depuis le storage
  Future<void> reload() async {
    state = const AsyncValue.loading();
    await _init();
  }
}
