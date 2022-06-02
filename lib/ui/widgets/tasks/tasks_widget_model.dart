import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<User>> _groupBox;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  User? _group;
  User? get group => _group;

  TasksWidgetModel({required this.groupKey}) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.tasksForm,
      arguments: groupKey,
    );
  }

  void _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void _setupListenTasks() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  void deleteTask(int groupIndex) async {
    await _group?.tasks?.deleteFromHive(groupIndex);
    await _group?.save();
  }

  void doneToggle(int groupIndex) async {
    final task = group?.tasks?[groupIndex];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    _groupBox = Hive.openBox<User>('users_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    Hive.box<Task>('tasks_box');
    _loadGroup();
    _setupListenTasks();
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
