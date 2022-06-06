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
        TextButton(
            child: Text('Добавить категорию ${model.typeTransaction}'), onPressed: () => model.addCategory(context)),
        Expanded(
          // height: 300,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: model.listTransactions.length,
              itemBuilder: (context, index) => Card(
                    elevation: 8,
                    child: ListTile(
                      trailing: IconButton(onPressed: ()=>model.deleteTypeTransaction(index), icon: Icon(Icons.delete)),
                      leading: Text('${model.listTransactions[index].type}'),
                      title: TextButton(
                          onPressed: () => model.openTransElement(context, model.listTransactions[index]),
                          child: Text(
                              '${model.listTransactions[index].name} ${model.listTransactions[index].type} ${model.listTransactions[index].keyAt}')),
                    ),
                  )),
        ),
      ],
    );
  }
}
