import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yellow_class_assignment/model/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yellow_class_assignment/widget/movie_details.dart';
Future main() async {
  /**
   * initlizing the widget binding and making sure that it is initlized
   */
  WidgetsFlutterBinding.ensureInitialized();
  
  /**
   * initlizing the Hive with flutter 
   */
  await Hive.initFlutter();
  /**
   * resgistring the hive with Adapter
   */
  Hive.registerAdapter(TransactionAdapter());
  /**
   * initlizing our box giving some name to it
   */
  await Hive.openBox<Transaction>('transaction');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Movie Details';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: MovieListPage(),
      );
}