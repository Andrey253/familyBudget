import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TransactionDetail extends StatefulWidget {
  TransactionDetail({
    Key? key,
    required this.categoryTransaction,
    required this.model,
  }) : super(key: key);
  final NameCategory categoryTransaction;
  final MainModel model;
  final TextEditingController textControllerName = TextEditingController();
  final TextEditingController textControllerFix = TextEditingController();

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    widget.textControllerName.text = widget.categoryTransaction.name;
    widget.textControllerFix.text =
        (widget.categoryTransaction.fix ?? '').toString();
    ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали транзакции'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(' Тип транзакции:  ${widget.categoryTransaction.type}')
              .paddingAll(),
          Row(
            children: [
              Text(' Наименование транзакции: ${widget.categoryTransaction.name}')
                  .paddingAll(),
              Expanded(child: TextField(controller: widget.textControllerName))
            ],
          ),
          Row(
            children: [
              Text(' Фиксировать ${widget.categoryTransaction.type}: ')
                  .paddingAll(),
              Expanded(child: TextField(controller: widget.textControllerFix))
            ],
          ),
          Text(' Индекс транзакции: ${widget.categoryTransaction.key}')
              .paddingAll(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: save, icon: const Icon(Icons.save)),
              IconButton(
                  onPressed: () => widget.model.deleteCategoryTransaction(
                      widget.categoryTransaction, context),
                  icon: const Icon(Icons.delete)),
            ],
          ),
        ],
      ),
    );
  }

  void save() {
    final oldNameTransaction = widget.categoryTransaction.name;
    final newNameTransaction = widget.textControllerName.text;
    final transactions =
        Hive.box<Transaction>(HiveDbName.transactionBox).values;
    transactions
        .where((transaction) =>
            transaction.nameCategory == oldNameTransaction)
        .forEach((e) {
      e.nameCategory = newNameTransaction;
      e.save();
    });
    widget.categoryTransaction.name = newNameTransaction;
    widget.categoryTransaction.fix =
        double.parse(widget.textControllerFix.text);

    widget.model.saveCategoryTransaction(widget.categoryTransaction, context);
  }
}
