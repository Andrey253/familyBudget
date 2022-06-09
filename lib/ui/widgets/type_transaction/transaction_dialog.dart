import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction? transaction;

  const TransactionDialog({
    Key? key,
    this.transaction,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      amountController.text = (transaction.amount == 0 ? '' : transaction.amount).toString();
      isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();

    super.dispose();
  }

  void onClickedDone(String _name, double amount, bool isExpense, Transaction transaction) async {
    final tr = transaction.copyWith(name:_name,createdDate: DateTime.now(), isExpense:isExpense,amount: amount, nameUser: null,nameCategory: null,typeTransaction: null);
    final box = Hive.box<Transaction>(HiveDbName.transactionBox);
    await box.add(tr);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing
        ? 'Edit Transaction ${widget.transaction?.typeTransaction}'
        : 'Add Transaction ${widget.transaction?.nameCategory}';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              buildAmount(),
              const SizedBox(height: 8),
              buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) => name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null ? 'Enter a valid number' : null,
        controller: amountController,
      );

  Widget buildRadioButtons() => Column(
        children: [
          RadioListTile<bool>(
            title: const Text('Expense'),
            value: true,
            groupValue: isExpense,
            onChanged: (value) => setState(() => isExpense = value!),
          ),
          RadioListTile<bool>(
            title: const Text('Income'),
            value: false,
            groupValue: isExpense,
            onChanged: (value) => setState(() => isExpense = value!),
          ),
        ],
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final amount = double.tryParse(amountController.text) ?? 0;

          onClickedDone(name, amount, isExpense, widget.transaction!);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
