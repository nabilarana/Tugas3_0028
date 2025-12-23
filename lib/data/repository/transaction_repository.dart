import 'package:moneyappsqflite/data/db/transaction_dao.dart';
import 'package:moneyappsqflite/data/model/transaction.dart';

class TransactionRepository {
  final MoneyDao = TransactionDao();

  Future<int> insertTransaction(Transaction transaction) async {
    return await MoneyDao.insertTransaction(transaction);
  }

  Future<List<Transaction>> getAllTransactions() async {
    return await MoneyDao.getAllTransactions();
  }

  Future<double> getBalance() async {
    return await MoneyDao.getBalance();
  }

  Future<int> updateTransaction(int id, Transaction transaction) async {
    return await MoneyDao.updateTransaction(id, transaction);
  }

  Future<int> deleteTransaction(int id) async {
    return await MoneyDao.deleteTransaction(id);
  }

  Future<double> getIncome() async {
    return await MoneyDao.getIncome();
  }

  Future<double> getExpense() async {
    return await MoneyDao.getExpense();
  }
}
