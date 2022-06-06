import 'package:family_budget/ui/widgets/user_profile/user_profile_widget.dart';
import 'package:family_budget/ui/widgets/users/user_add_widget.dart';
import 'package:family_budget/ui/widgets/users/users_widget.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/ui/widgets/task_form/task_form_widget.dart';

abstract class MainNavigationRouteNames {
  static const mainPage = '/';
  static const userAdd = '/userAdd';
  static const userProfile = '/userProfile';
  static const addTransaction = '/userProfile/addTransaction';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.mainPage;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainPage: (context) => const MainPage(),
    MainNavigationRouteNames.userAdd: (context) => const UserAddWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.userProfile:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => UserProfileWidget(groupKey: groupKey),
        );
      case MainNavigationRouteNames.addTransaction:
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
