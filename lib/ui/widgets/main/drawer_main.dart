import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerMain extends StatelessWidget {
  const DrawerMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    final date = DateTime.now();

    return Drawer(
        child: Column(
      children: [
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushNamed(
                  context, MainNavigationRouteNames.transactions,
                  arguments: [
                    TypeTransaction.all,
                    null,
                    DateTime(date.year, date.month),
                    DateTime(date.year, date.month + 1)
                  ]);
            },
            icon: Icon(Icons.add),
            label: Text('Все операции')),
      ],
    ));
  }
}
