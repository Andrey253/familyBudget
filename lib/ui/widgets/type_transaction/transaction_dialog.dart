import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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

  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      amountController.text =
          (transaction.amount == 0 ? '' : transaction.amount).toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();

    super.dispose();
  }

  void onClickedDone(
      String _name, double amount, Transaction transaction) async {
    transaction.name = _name;
    transaction.amount = amount;
    transaction.createdDate = dateTime;

    final box = Hive.box<Transaction>(HiveDbName.transactionBox);

    if (transaction.key == null) {
      await box.add(transaction);
    } else {
      transaction.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction?.key != null;
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
              buildCalebdar(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildDeleteButton(context, widget.transaction),
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
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Enter a valid number'
            : null,
        controller: amountController,
      );

  Widget buildCalebdar() => Row(
        children: [
          IconButton(
              onPressed: () async {
                final date = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2025));
                dateTime = date ?? DateTime.now();
                setState(() {});
              },
              icon: Icon(Icons.calendar_today)),
          Text('${dateTime.toString().split(' ').first}')
        ],
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );
  Widget buildDeleteButton(BuildContext context, Transaction? transaction) =>
      TextButton(
        child: transaction?.key != null
            ? const Text('Delete')
            : const SizedBox.shrink(),
        onPressed: () {
          transaction?.delete();
          Navigator.of(context).pop();
        },
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

          onClickedDone(name, amount, widget.transaction!);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
