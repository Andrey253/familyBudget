
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:family_budget/ui/widgets/reports/list.dart';
import 'package:family_budget/ui/widgets/type_transaction/select_period_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
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
      SelectPeriodMain(),
      Expanded(child: ListMy())
      // Expanded(
      //     child: ValueListenableBuilder<Box<Transaction>>(
      //         valueListenable:
      //             Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
      //         builder: (context, box, _) {
      //           model.setListTransaction(userName);
      //           return ListView(
      //               shrinkWrap: true,
      //               children: model.listTransaction
      //                   .map((e) => TransactionItem(transaction: e))
      //                   .toList());
      //         }))
    ])));
  }
}
