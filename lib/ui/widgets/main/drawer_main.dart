import 'package:family_budget/domain/sourse/string.dart';
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
      children: [
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushNamed(
                  context, MainNavigationRouteNames.transactionsMain,
                  arguments: [TypeTransaction.all, null]);
            },
            icon: const Icon(Icons.add),
            label: const Text('Все операции')),
      ],
    ));
  }
}
