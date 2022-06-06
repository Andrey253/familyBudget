import 'package:family_budget/ui/widgets/users/users_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTransaction extends StatefulWidget {
  const ListTransaction({Key? key}) : super(key: key);

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersWidgetModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(child: Text('Добавить категорию ${model.typeTransaction}'), onPressed: model.addCategory),
        SizedBox(
          height: 300,
          child: ListView.builder(
              itemCount: model.listTransactions.length,
              itemBuilder: (context, index) => Text('${model.listTransactions[index].name} ${model.listTransactions[index].type}')),
        ),
      ],
    );
  }
}
