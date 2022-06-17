import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/reports/report_model.dart';
import 'package:family_budget/ui/widgets/reports/transaction/ltransaction_list.dart';
import 'package:family_budget/ui/widgets/general_widgets/select_period.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class TransactionListMain extends StatelessWidget {
  const TransactionListMain({
    Key? key,


  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    final model = context.watch<ReportModel>();

    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      SelectPeriod(
          setDateTimeRange: model.setDateTimeRange,
          start: model.start,
          end: model.end),
      Expanded(
          child: ValueListenableBuilder<Box<Transaction>>(
              valueListenable:
                  Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
              builder: (context, box, _) {
                return TransactionsList(
                    listTr: model.getTransaction().toList());
              }))
    ])));
  }
}
