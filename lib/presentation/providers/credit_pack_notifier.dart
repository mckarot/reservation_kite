import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/credit_pack.dart';
import '../../data/providers/repository_providers.dart';

part 'credit_pack_notifier.g.dart';

@riverpod
class CreditPackNotifier extends _$CreditPackNotifier {
  @override
  FutureOr<List<CreditPack>> build() async {
    return _fetchPacks();
  }

  Future<List<CreditPack>> _fetchPacks() async {
    return ref.read(creditPackRepositoryProvider).getAllPacks();
  }

  Future<void> addPack(CreditPack pack) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(creditPackRepositoryProvider).savePack(pack);
      return _fetchPacks();
    });
  }

  Future<void> deletePack(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(creditPackRepositoryProvider).deletePack(id);
      return _fetchPacks();
    });
  }
}
