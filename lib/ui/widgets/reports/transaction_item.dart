import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Text(transaction.typeTransaction),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: ()=>Navigator.pushNamed(context, MainNavigationRouteNames.transactioDialog,arguments: transaction),
        ),
        subtitle: Text(
            '${transaction.createdDate} ${transaction.nameUser} ${transaction.nameCategory} ${transaction.name} '),
        title: Text(
            '${transaction.name} : ${transaction.amount}: ${transaction.isExpense}'),
      ),
    );
  }
}