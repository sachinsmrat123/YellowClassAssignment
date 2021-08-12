
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yellow_class_assignment/boxes/boxes.dart';
import 'package:yellow_class_assignment/model/transaction.dart';
import 'package:yellow_class_assignment/movie_page/movie_dialog.dart';
//this class is respnsible for showing data in list to user on main screen
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
        //valuelistenable will help to fetch the data from hive database
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
    //here checking if database is empty just show there  are no records
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No Records yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      
       //else show the items from database
      return Column(
        children: [
          SizedBox(height: 24),
          
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
  // adding data to our database
  Future addTransaction(String moviename, String directorname,String? imagepath) async {
    final transaction = Transaction()
      ..movieName = moviename
      ..directorname = directorname
      ..filePath =imagepath!;

    final box = Boxes.getTransactions();
    box.add(transaction);
    
  }
  
  //updating the transaction
  void editTransaction(
    Transaction transaction,
    String? moviename,
    String? directorname,
    String? filepath,
   
  ) {
    transaction.movieName = moviename!;
    transaction.directorname = directorname!;
    transaction.filePath = filepath!;
   


    transaction.save();
  }

  //this fuction is respnsible deleting the particular row from the database
  void deleteTransaction(Transaction transaction) {
   

    transaction.delete();
   
  }
}
