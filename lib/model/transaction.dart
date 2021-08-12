import 'dart:io';

import 'package:hive/hive.dart';

part 'transaction.g.dart';
/**
 * initlizing the fields inside database
 */
@HiveType(typeId: 0)
class Transaction extends HiveObject{
  @HiveField(0)
 String? movieName;

  @HiveField(2)
 String? directorname;

  @HiveField(3)
 String? filePath;

 

}