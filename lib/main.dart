import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/widgets/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // await Hive.deleteBoxFromDisk(HiveDbName.userBox);
  // await Hive.deleteBoxFromDisk(HiveDbName.transactionBox);
  // await Hive.deleteBoxFromDisk(HiveDbName.typeBox);
  // await Hive.deleteBoxFromDisk(HiveDbName.categoryTransaction);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryTransactionAdapter());

  await Hive.openBox<User>(HiveDbName.userBox);
  await Hive.openBox<Transaction>(HiveDbName.transactionBox);
  await Hive.openBox<String>(HiveDbName.typeBox);
  await Hive.openBox<CategoryTransaction>(HiveDbName.categoryTransaction);

  const app = MyApp();
  runApp(app);
}

abstract class HiveDbName {
  static const userBox = 'users_box';
  static const transactionBox = 'transaction_box';
  static const typeBox = 'type_box';
  static const categoryTransaction = 'categoryTransaction_box';
}
