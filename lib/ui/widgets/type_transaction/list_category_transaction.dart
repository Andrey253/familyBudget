import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class CategoryTransaction extends StatelessWidget {
  const CategoryTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Категории транзакций'),
              GridView(
                  primary: false,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: size.width / 3),
                  shrinkWrap: true,
                  children: model.listCategory
                      .map((e) => Card(
                          elevation: 8,
                          child: categoryTransactionItem(model, e, context)))
                      .toList()),
            ],
          );
        });
  }

  Widget categoryTransactionItem(
      MainModel model, NameCategory nameCategory, BuildContext context) {
    final date = DateTime.now();
    final dateStart = DateTime(date.year, date.month);
    final dateEnd = DateTime(date.year, date.month + 1);
    final trans = Hive.box<Transaction>(HiveDbName.transactionBox)
        .values
        .where((e) => e.createdDate.isAfter(dateStart))
        .where((e) => e.createdDate.isBefore(dateEnd))
        .where((element) => element.nameCategory == nameCategory.name);
    final summ = trans.fold<double>(
        0, (previousValue, element) => previousValue + element.amount);

    return Column(
      children: [
        Text(
          (nameCategory.fix != null
              ? 'Ограничение ${nameCategory.fix}'
              : 'Нет ограничений'),
          textAlign: TextAlign.center,
          style: nameCategory.fix != null && nameCategory.fix! < summ
              ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
              : const TextStyle(color: Colors.green),
        ),
        TextButton(
            onPressed: () {
              model.openTransElement(context, nameCategory);
            },
            child: Text(
              nameCategory.name,
              style: TextStyle(
                  color: nameCategory.type == TypeTransaction.expense
                      ? Colors.red
                      : Colors.green),
            )),
        Text((summ.toString())),
      ],
    );
  }
}
