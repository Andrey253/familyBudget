import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTransaction extends StatelessWidget {
  const CategoryTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainModel>();
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Категории транзакций'),
        GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: size.width / 4,
                // childAspectRatio: 6 / 2,
                // crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            shrinkWrap: true,
            itemCount: model.listCategory.length,
            itemBuilder: (context, index) => Card(
                  elevation: 8,
                  child: categoryTransactionItem(model, index, context),
                )),
      ],
    );
  }

  Widget categoryTransactionItem(
      MainModel model, int index, BuildContext context) {
    var categoryTransaction = model.listCategory[index];
    return Column(
      children: [
        Text((categoryTransaction.fix ?? '- -').toString()),
        TextButton(
            onPressed: () {
              model.openTransElement(context, categoryTransaction);
            },
            child: Text(
              model.listCategory[index].name,
              style: TextStyle(
                  color:
                      model.listCategory[index].type == TypeTransaction.expense
                          ? Colors.red
                          : Colors.green),
            )),
      ],
    );
  }
}
