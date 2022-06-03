import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/widgets/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('users_box');
  // await Hive.deleteBoxFromDisk('tasks_box');
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<User>(HiveDbName.userBox);
  await Hive.openBox<Task>(HiveDbName.tasksBox);
  await Hive.openBox<String>(HiveDbName.typeBox);
  const app = MyApp();
  runApp(app);
}

abstract class HiveDbName {
  static const userBox = 'users_box';
  static const tasksBox = 'tasks_box';
  static const typeBox = 'type_box';
}
