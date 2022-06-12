import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key? key,
  required  this.typeTransaction,
    this.userName,
  }) : super(key: key);

  final String? typeTransaction;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Transaction>>(
      valueListenable:
          Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
      builder: (context, box, _) {
        final transactions = box.values
            .toList()
            .cast<Transaction>()
            .where((element) => typeTransaction != TypeTransaction.all
                ? element.typeTransaction == typeTransaction
                : true)
            .where((element) =>
                userName != null ? element.nameUser == userName : true)
            .toList();
        return ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) =>
                TransactionItem(transaction: transactions[index]));
      },
    );
  }
}
