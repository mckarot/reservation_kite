import '../models/credit_pack.dart';

abstract class CreditPackRepository {
  Future<List<CreditPack>> getAllPacks();
  Future<CreditPack?> getPack(String id);
  Future<void> savePack(CreditPack pack);
  Future<void> deletePack(String id);
}
