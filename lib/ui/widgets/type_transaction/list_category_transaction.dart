import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategoryTransaction extends StatefulWidget {
  const ListCategoryTransaction({Key? key}) : super(key: key);

  @override
  State<ListCategoryTransaction> createState() => _ListCategoryTransactionState();
}

class _ListCategoryTransactionState extends State<ListCategoryTransaction> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Категории транзакций'),
        if (model.typeTransaction != TypeTransaction.all)
          TextButton(
              child: Text('Добавить категорию ${model.typeTransaction}'), onPressed: () => model.addCategory(context)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: model.listTypes.length,
            itemBuilder: (context, index) => Card(
                  elevation: 8,
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () => model.deleteCategoryTransaction(model.listTypes[index].key), icon: const Icon(Icons.delete)),
                    leading: Text(model.listTypes[index].type),
                    title: TextButton(
                        onPressed: () => model.openTransElement(context, model.listTypes[index]),
                        child: Text(
                            '${model.listTypes[index].nameCategory} ${model.listTypes[index].type}')),
                  ),
                )),
      ],
    );
  }
}
