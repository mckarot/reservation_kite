import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/credit_pack.dart';
import '../../domain/repositories/credit_pack_repository.dart';

class HiveCreditPackRepository implements CreditPackRepository {
  static const String boxName = 'credit_packs';

  Future<Box<Map>> _getBox() async {
    return await Hive.openBox<Map>(boxName);
  }

  @override
  Future<List<CreditPack>> getAllPacks() async {
    final box = await _getBox();
    return box.values
        .map((e) => CreditPack.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<CreditPack?> getPack(String id) async {
    final box = await _getBox();
    final data = box.get(id);
    if (data == null) return null;
    return CreditPack.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> savePack(CreditPack pack) async {
    final box = await _getBox();
    await box.put(pack.id, pack.toJson());
  }

  @override
  Future<void> deletePack(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
