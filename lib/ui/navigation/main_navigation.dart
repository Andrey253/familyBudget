import 'package:family_budget/ui/widgets/reports/report_widget.dart';
import 'package:family_budget/ui/widgets/type_transaction/category_detail.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_widget.dart';
import 'package:family_budget/ui/widgets/user_profile/user_add_widget.dart';
import 'package:family_budget/ui/widgets/main/main_widget.dart';
import 'package:flutter/material.dart';

abstract class MainNavigationRouteNames {
  static const mainPage = '/';
  static const reports = '/reports';
  static const transactionDetail = '/transactionDetail';
  static const userAdd = '/userAdd';
  static const userProfile = '/userProfile';
  static const addTransaction = '/userProfile/addTransaction';
  static const transactioDialog = '/userProfile/transactioDialog';
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
          builder: (context) => UserProfileWidget(userKey: groupKey),
        );
      case MainNavigationRouteNames.transactioDialog:
        final arguments = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) {
            return TransactionDialog(
              transaction: arguments[0],
              limit: arguments[1],
              currenValue: arguments[2],
            );
          },
        );
      case MainNavigationRouteNames.transactionDetail:
        final arg = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) {
            return CategoryDetail(
              categoryTransaction: arg[0],
              deleteCategoryTransaction: arg[1],
              saveCategoryTransaction: arg[2],
            );
          },
        );
      case MainNavigationRouteNames.reports:
        final arguments = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) {
            return ReportWidget(
                nameUser: arguments[0], initialPage: arguments[1]);
          },
        );

      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }

  MainNavigation();
}
