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
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<User>('users_box');
  await Hive.openBox<Task>('tasks_box');
  const app = MyApp();
  runApp(app);
}
