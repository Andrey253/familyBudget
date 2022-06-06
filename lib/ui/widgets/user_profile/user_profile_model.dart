import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';

class UserProfileModel extends ChangeNotifier {
  int userKey;
  late final Box<User> _userBox;
  // var _tasks = <Task>[];

  // List<Task> get tasks => _tasks.toList();

  User? _user;
  User? get user => _user;

  UserProfileModel({required this.userKey}) {
    _setup();
  }

  void addTransaction(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addTransaction,
      arguments: userKey,
    );
  }

  void _loadUser() {
    final box = _userBox;
    _user = box.get(userKey);
    notifyListeners();
  }

  // void _readTasks() {
  //   _tasks = _user?.tasks ?? <Task>[];
  //   notifyListeners();
  // }

  // void _setupListenTasks() async {
  //   final box = await _userBox;
  //   _readTasks();
  //   box.listenable(keys: <dynamic>[userKey]).addListener(_readTasks);
  // }

  // void deleteTask(int groupIndex) async {
  //   await _user?.tasks?.deleteFromHive(groupIndex);
  //   await _user?.save();
  // }

  // void doneToggle(int groupIndex) async {
  //   final task = group?.tasks?[groupIndex];
  //   final currentState = task?.isDone ?? false;
  //   task?.isDone = !currentState;
  //   await task?.save();
  //   notifyListeners();
  // }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    _userBox = Hive.box<User>(HiveDbName.userBox);
    // if (!Hive.isAdapterRegistered(2)) {
    //   Hive.registerAdapter(TaskAdapter());
    // }
    // Hive.box<Task>('tasks_box');
    _loadUser();
    notifyListeners();
    // _setupListenTasks();
  }
}

// class TasksWidgetModelProvider extends InheritedNotifier {
//   final TasksWidgetModel model;
//   const TasksWidgetModelProvider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   static TasksWidgetModelProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
//   }

//   static TasksWidgetModelProvider? read(BuildContext context) {
//     final widget = context.getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()?.widget;
//     return widget is TasksWidgetModelProvider ? widget : null;
//   }
// }
