import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/extentions.dart';
import 'package:flutter/material.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({
    Key? key,
    required this.categoryTransaction,
  }) : super(key: key);
  final CategoryTransaction categoryTransaction;

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали транзакции'),
      ),
      body: Column(
        children: [
          Text(' Тип транзакции: ${widget.categoryTransaction.type}').paddingAll(),
          Text(' Наименование транзакции: ${widget.categoryTransaction.nameCategory}').paddingAll(),
          Text(' Индекс транзакции: ${widget.categoryTransaction.key}').paddingAll(),
        ],
      ),
    );
  }
}
