import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:family_budget/domain/entity/user.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var groupName = '';

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    final box = await Hive.openBox<User>('users_box');
    final group = User(name: groupName, isSelected: false);
    await box.add(group);
    Navigator.of(context).pop();
  }
}

// class GroupFormWidgetModelProvider extends InheritedWidget {
//   final GroupFormWidgetModel model;
//   const GroupFormWidgetModelProvider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           child: child,
//         );

//   static GroupFormWidgetModelProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
//   }

//   static GroupFormWidgetModelProvider? read(BuildContext context) {
//     final widget = context.getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()?.widget;
//     return widget is GroupFormWidgetModelProvider ? widget : null;
//   }

//   @override
//   bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
//     return false;
//   }
// }
