import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

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
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Отчеты', style: TextStyle(fontSize: 32)),
          ],
        ),
        SizedBox(height: 10),
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
              Navigator.pushNamed(
                  context, MainNavigationRouteNames.transactionsMain,
                  arguments: [TypeTransaction.all, null]);
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
