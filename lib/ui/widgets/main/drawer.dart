import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses_report.dart';
import 'package:flutter/material.dart';

class DrawerMy extends StatelessWidget {
  const DrawerMy({
    Key? key, this.userName,
  }) : super(key: key);
final String? userName;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Center(child: Text('Отчеты', style: TextStyle(fontSize: 32))),
        const SizedBox(height: 10),
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, MainNavigationRouteNames.reports,
                  arguments: [userName,0]);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('Транзакции')),
        TextButton.icon(
            onPressed: () {Navigator.pop(context);
              Navigator.pushNamed(context, MainNavigationRouteNames.reports,
                  arguments: [userName,1]);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('Доходы/Расходы')),
        TextButton.icon(
            onPressed: () {Navigator.pop(context);
              Navigator.pushNamed(context, MainNavigationRouteNames.reports,
                  arguments: [userName,2]);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('По категориям')),
      ],
    ));
  }
}
