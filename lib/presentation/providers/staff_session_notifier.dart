import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_session_notifier.g.dart';

@riverpod
class StaffSessionNotifier extends _$StaffSessionNotifier {
  @override
  String? build() {
    return null;
  }

  void login(String staffId) {
    state = staffId;
  }

  void logout() {
    state = null;
  }
}
