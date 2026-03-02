import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/repository_providers.dart';
import '../../domain/models/settings.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  FutureOr<SchoolSettings?> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateSettings(SchoolSettings settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .saveSettings(settings.copyWith(updatedAt: DateTime.now()));
      return ref.read(settingsRepositoryProvider).getSettings();
    });
  }

  Future<void> updateWeatherLocation({
    required double latitude,
    required double longitude,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .updateWeatherLocation(latitude: latitude, longitude: longitude);
      return ref.read(settingsRepositoryProvider).getSettings();
    });
  }
}
