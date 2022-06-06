import 'package:family_budget/ui/widgets/users/user_add_widget.dart';
import 'package:family_budget/ui/widgets/users/users_widget.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/ui/widgets/task_form/task_form_widget.dart';
import 'package:family_budget/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  static const groupsFrom = '/groupForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupsFrom: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TasksWidget(groupKey: groupKey),
        );
      case MainNavigationRouteNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) {
            return TaskFormWidget(groupKey: groupKey);
          },
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }

  MainNavigation();
}
