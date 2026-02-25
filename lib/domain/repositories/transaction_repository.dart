import '../models/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getUserTransactions(String userId);
  Future<void> saveTransaction(Transaction transaction);
  Future<List<Transaction>> getAllTransactions({int? limit});
}
