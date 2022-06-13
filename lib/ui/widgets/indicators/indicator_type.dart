import 'package:family_budget/domain/entity/cilcle_diagramm.dart';
import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class IndicatorType extends StatelessWidget {
  const IndicatorType({Key? key, required this.chartData}) : super(key: key);
  final List<ChartData> chartData;
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();

    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          model.getDataTypeTransactions('userName');
          return CircleDiagramm(chartData: model.chartDataTypeTransaction);
        });
  }
}
