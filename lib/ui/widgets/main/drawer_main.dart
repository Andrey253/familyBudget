import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses.dart';
import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerMain extends StatelessWidget {
  const DrawerMain({
    Key? key,
  }) : super(key: key);

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
              Navigator.pushNamed(
                  context, MainNavigationRouteNames.transactionsMain,
                  arguments: [TypeTransaction.all, null]);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('Транзакции')),
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                    const      IncomeExpensesReportWidget()));
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('Доходы/Расходы')),
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                  context, MainNavigationRouteNames.transactionsMain,
                  arguments: [TypeTransaction.all, null]);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('По категориям')),
      ],
    ));
  }
}
