import 'dart:developer';

import 'package:moneyappsqflite/data/db/db_helper.dart';
import 'package:moneyappsqflite/data/model/transaction.dart';

class TransactionDao {
  final dbHelper = DbHelper();
  Future<int> insertTransaction (Transaction transactions) async {
    final db = await dbHelper.database;
    return await db.insert('transaction', transactions.toMap());
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await dbHelper.database;
    final result = await db.query('transactions');
    for (var map in result) {
      log('Transaction from DB: ${Transaction.fromMap(map).toJson()}');
    }
    return result.map((map) => Transaction.fromMap(map)).toList();
  }

  Future<double> getIncome() async {
    final db = await dbHelper.database;
    final incomeResult = await db.rawQuery(
      'SELECT SUM(amount)  as total_income FROM transaction WHERE TYPE = ?',
      ['income'],
    );
    return (incomeResult.first['total_income'] as num?)?.toDouble() ?? 0.0;
  }

   Future<double> getExpense() async {
    final db = await dbHelper.database;
    final expenseesult = await db.rawQuery(
      'SELECT SUM(amount)  as total_expense FROM transaction WHERE TYPE = ?',
      ['expense'],
    );
    return (expenseesult.first['total_expense'] as num?)?.toDouble() ?? 0.0;
  }
}