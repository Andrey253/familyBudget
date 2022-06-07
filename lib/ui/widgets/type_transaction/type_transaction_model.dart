import 'dart:async';

import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';

class TypeTransactionsWidgetModel extends ChangeNotifier {
  var _types = <String>[];

  List<String> get types => _types.toList();








}
