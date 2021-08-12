import 'package:hive/hive.dart';
import 'package:yellow_class_assignment/model/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transaction');
}
