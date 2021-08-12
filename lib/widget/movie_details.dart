
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yellow_class_assignment/boxes/boxes.dart';
import 'package:yellow_class_assignment/model/transaction.dart';
import 'package:yellow_class_assignment/movie_page/movie_dialog.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Movie Manager'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Transaction>>(
          valueListenable: Boxes.getTransactions().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Transaction>();

            return buildContent(transactions);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => MovieDialog(
              onClickedDone: addTransaction,
            ),
          ),
        ),
      );

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No Records yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      // final netExpense = transactions.fold<double>(
      //   0,
      //   (previousValue, transaction) => transaction.isExpense
      //       ? previousValue - transaction.amount!
      //       : previousValue + transaction.amount!,
      // );
      // final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      // final color = netExpense > 0 ? Colors.green : Colors.red;

      return Column(
        children: [
          SizedBox(height: 24),
          // Text(
          //   'Net Expense: $newExpenseString',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //     color: color,
          //   ),
          // ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    Transaction transaction,
  ) {
    // final color = transaction.isExpense ? Colors.red : Colors.green;
   // final date = DateFormat.yMMMd().format(transaction.createdDate);
  //  final amount = '\$' + transaction.amount!.toStringAsFixed(2);

    return Column(

      children: [
        Container(height: 200,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      
        
        child:Image.file(File(transaction.filePath!), fit: BoxFit.fill,),
        ),
        
        Card(
      
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
        title: Text(
          transaction.movieName!,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      //  subtitle: Text(date),
        trailing: Text(
          transaction.directorname!,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, transaction),
        ],
      ),
    ),
      ],
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDialog(
                    transaction: transaction,
                    onClickedDone: (name, directorname,imagepath) =>
                        editTransaction(transaction, name, directorname, imagepath),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteTransaction(transaction),
            ),
          )
        ],
      );

  Future addTransaction(String moviename, String directorname,String? imagepath) async {
    final transaction = Transaction()
      ..movieName = moviename
      ..directorname = directorname
      ..filePath =imagepath!;

    final box = Boxes.getTransactions();
    box.add(transaction);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }

  void editTransaction(
    Transaction transaction,
    String? moviename,
    String? directorname,
    String? filepath,
   
  ) {
    transaction.movieName = moviename!;
    transaction.directorname = directorname!;
    transaction.filePath = filepath!;
   

    // final box = Boxes.getTransactions();
    // box.put(transaction.key, transaction);

    transaction.save();
  }

  void deleteTransaction(Transaction transaction) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    transaction.delete();
    //setState(() => transactions.remove(transaction));
  }
}
