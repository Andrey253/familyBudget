import 'dart:async';

import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/domain/entity/task.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';

class UsersWidgetModel extends ChangeNotifier {
  var _groups = <User>[];
  var groupName = '';

  List<User> get groups => _groups.toList();

  UsersWidgetModel() {

    _setup();
  }

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final box = Hive.box<User>(HiveDbName.userBox);
    final group = User(name: groupName, isSelected: false);
    await box.add(group);
    Navigator.of(context).pop();
  }
  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsFrom);
  }

  void showTasks(BuildContext context, int userIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }

    final box = Hive.box<User>(HiveDbName.userBox);
    final groupKey = box.keyAt(userIndex) as int;

    unawaited(
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: groupKey,
      ),
    );
  }

  void deleteGroup(int groupIndex, BuildContext context) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      final box = await Hive.openBox<User>(HiveDbName.userBox);
                      await box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
                      await box.deleteAt(groupIndex);
                      Navigator.pop(context);
                    },
                    child: Text('Удалить пользователя')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Отмена'))
              ],
            ));
  }

  void _readGroupsFromHive(Box<User> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    final box = Hive.box<User>('users_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    Hive.box<Task>('tasks_box');
    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }
}

// class GroupsWidgetModelProvider extends InheritedNotifier {
//   final UsersWidgetModel model;
//   const GroupsWidgetModelProvider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   static GroupsWidgetModelProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
//   }

//   static GroupsWidgetModelProvider? read(BuildContext context) {
//     final widget = context.getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()?.widget;
//     return widget is GroupsWidgetModelProvider ? widget : null;
//   }
// }
