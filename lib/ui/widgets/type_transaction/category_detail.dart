import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:family_budget/extentions.dart';
import 'package:flutter/material.dart';

class CategoryDetail extends StatefulWidget {
  CategoryDetail({
    Key? key,
    required this.categoryTransaction,
    required this.deleteCategoryTransaction,
    required this.saveCategoryTransaction,
  }) : super(key: key);
  final NameCategory categoryTransaction;
  final Function(BuildContext context, NameCategory categoryTransaction)
      deleteCategoryTransaction;
  final Function(
      BuildContext context,
      NameCategory categoryTransaction,
      bool validate,
      String textFieldName,
      String textFieldFix) saveCategoryTransaction;
  final TextEditingController textControllerName = TextEditingController();
  final TextEditingController textControllerFix = TextEditingController();

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  @override
  Widget build(BuildContext context) {
    widget.textControllerName.text = widget.categoryTransaction.name;
    widget.textControllerFix.text =
        (widget.categoryTransaction.fix ?? '').toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали категории'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(' Тип транзакции:  ${widget.categoryTransaction.type}')
              .paddingAll(),
          Row(
            children: [
              const Text(' Наименование транзакции: ').paddingAll(),
              Expanded(child: TextField(controller: widget.textControllerName))
            ],
          ),
          Row(
            children: [
              Text(' Фиксировать ${widget.categoryTransaction.type}: ')
                  .paddingAll(),
              Expanded(
                  child: TextFormField(
                controller: widget.textControllerFix,
                onChanged: validate,
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () => widget.saveCategoryTransaction(
                      context,
                      widget.categoryTransaction,
                      validate(widget.textControllerFix.text),
                      widget.textControllerName.text,
                      widget.textControllerFix.text),
                  icon: const Icon(Icons.save)),
              IconButton(
                  onPressed: () => widget.deleteCategoryTransaction(
                      context, widget.categoryTransaction),
                  icon: const Icon(Icons.delete))
            ],
          ),
        ],
      ),
    );
  }

  bool validate(String value) {
    try {
      if (value != '') double.parse(value);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Не верное число')));
      return false;
    }
  }
}
