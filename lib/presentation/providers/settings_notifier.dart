import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/settings.dart';
import '../../data/providers/repository_providers.dart';

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
}
