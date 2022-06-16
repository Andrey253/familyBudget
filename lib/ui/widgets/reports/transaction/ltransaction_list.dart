import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:family_budget/ui/widgets/reports/scrollable_widget.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({Key? key, required this.listTr}) : super(key: key);
  final List<Transaction> listTr;

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    return ScrollableWidget(child: buildDataTable());
  }

  Widget buildDataTable() {
    final columns = [
      'Приход/ \n Расход',
      'Катег.',
      'Дата',
      'Польз.',
      'Наимен\n операции',
      'Сумма'
    ];

    return DataTable(
      columnSpacing: 20,
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(widget.listTr),
    );
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
          trans.name,
          trans.amount
        ];

        return DataRow(cells: getCells(cells, trans));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, Transaction trans) => cells
      .map((data) => DataCell(
            Text('$data'),
            onTap: () => Navigator.pushNamed(
                context, MainNavigationRouteNames.transactioDialog,
                arguments: [trans, null, null]),
          ))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.listTr.sort((rt1, tr2) =>
          compareString(ascending, rt1.typeTransaction, tr2.typeTransaction));
    } else if (columnIndex == 1) {
      widget.listTr.sort((tr1, tr2) =>
          compareString(ascending, tr1.nameCategory, tr2.nameCategory));
    } else if (columnIndex == 2) {
      widget.listTr.sort((tr1, tr2) =>
          compareString(ascending, '${tr1.createdDate}', '${tr2.createdDate}'));
    } else if (columnIndex == 3) {
      widget.listTr.sort(
          (tr1, tr2) => compareString(ascending, tr1.nameUser, tr2.nameUser));
    } else if (columnIndex == 4) {
      widget.listTr
          .sort((tr1, tr2) => compareString(ascending, tr1.name, tr2.name));
    } else if (columnIndex == 5) {
      widget.listTr.sort((tr1, tr2) => ascending
          ? tr1.amount.compareTo(tr2.amount)
          : tr2.amount.compareTo(tr1.amount));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
