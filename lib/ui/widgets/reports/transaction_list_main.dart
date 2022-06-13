import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:family_budget/ui/widgets/reports/list.dart';
import 'package:family_budget/ui/widgets/type_transaction/select_period_main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class TransactionListMain extends StatelessWidget {
  const TransactionListMain({
    Key? key,
    required this.typeTransaction,
    this.userName,
  }) : super(key: key);

  final String? typeTransaction;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();

    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      const SelectPeriodMain(),
      Expanded(
          child: ValueListenableBuilder<Box<Transaction>>(
              valueListenable:
                  Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
              builder: (context, box, _) {
                return ListMy(listTr: model.getTransaction(userName).toList());
              }))
    ])));
  }
}
