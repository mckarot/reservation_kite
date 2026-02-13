import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_notifier.g.dart';

@riverpod
class SessionNotifier extends _$SessionNotifier {
  @override
  String? build() {
    return null; // Pas d'utilisateur connecté par défaut
  }

  void login(String userId) {
    state = userId;
  }

  void logout() {
    state = null;
  }
}
