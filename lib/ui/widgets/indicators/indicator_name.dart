import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class IndicatorPerson extends StatelessWidget {
  const IndicatorPerson({Key? key, this.userName}) : super(key: key);

  final String? userName;
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          model.getDataNameTransactions(userName);

          return CircleDiagramm(chartData: model.chartDataNameTransaction);
        });
  }
}
