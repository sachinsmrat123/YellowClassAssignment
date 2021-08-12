import 'package:hive/hive.dart';
import 'package:yellow_class_assignment/model/transaction.dart';


class Boxes {
  /**
 * this function will be respnsible for getting the refrence of our database
 */
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transaction');
}
