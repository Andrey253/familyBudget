import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:family_budget/ui/widgets/reports/scrollable_widget.dart';
import 'package:family_budget/ui/widgets/reports/user.dart';
import 'package:family_budget/ui/widgets/reports/users.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ListMy extends StatefulWidget {
  const ListMy({Key? key, this.userName}) : super(key: key);
  final String? userName;

  @override
  State<ListMy> createState() => _ListMyState();
}

class _ListMyState extends State<ListMy> {
  int? sortColumnIndex;
  bool isAscending = false;
  late List<Transaction> listTr;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollableWidget(child: buildDataTable()),
    );
  }

  Widget buildDataTable() {
    final columns = ['Приход/ \n Расход', 'Катег.', 'Дата', 'Польз.', 'Сумма'];
    return ValueListenableBuilder<Box<Transaction>>(
        valueListenable:
            Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
        builder: (context, box, _) {
          final model = context.read<MainModel>();
          model.setListTransaction(widget.userName);
          listTr = model.listTransaction;
          return DataTable(
            columnSpacing: 20,
            sortAscending: isAscending,
            sortColumnIndex: sortColumnIndex,
            columns: getColumns(columns),
            rows: getRows(listTr),
          );
        });
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Transaction> tr) => tr.map((Transaction trans) {
        final cells = [
          trans.typeTransaction,
          trans.nameCategory,
          trans.createdDate.toString().split(' ').first,
          trans.nameUser,
          trans.amount
        ];

        return DataRow(cells: getCells(cells, trans));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, Transaction trans) => cells
      .map((data) => DataCell(
            Text('$data'),
            onTap: () => Navigator.pushNamed(
                context, MainNavigationRouteNames.transactioDialog,
                arguments: trans),
          ))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      listTr.sort((rt1, tr2) =>
          compareString(ascending, rt1.typeTransaction, tr2.typeTransaction));
    } else if (columnIndex == 1) {
      listTr.sort((tr1, tr2) =>
          compareString(ascending, tr1.nameCategory, tr2.nameCategory));
    } else if (columnIndex == 2) {
      listTr.sort((tr1, tr2) =>
          compareString(ascending, '${tr1.createdDate}', '${tr2.createdDate}'));
    } else if (columnIndex == 3) {
      listTr.sort((tr1, tr2) =>
          compareString(ascending, '${tr1.nameUser}', '${tr2.nameUser}'));
    } else if (columnIndex == 4) {
      listTr.sort((tr1, tr2) => ascending
          ? tr1.amount.compareTo(tr2.amount)
          : tr2.amount.compareTo(tr1.amount));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
