import 'package:family_budget/domain/entity/category_transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTypeDialog extends StatefulWidget {
  const TransactionTypeDialog({
    Key? key,
    required this.type,
  }) : super(key: key);
  final String? type;
  @override
  _TransactionTypeDialogState createState() => _TransactionTypeDialogState();
}

class _TransactionTypeDialogState extends State<TransactionTypeDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавление категории'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: false),
      ],
    );
  }

  Widget buildName() => TextFormField(
        autofocus: true,
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) => name != null && name.isEmpty ? 'Enter a name' : null,
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

        if (isValid && widget.type!=null) {
          final name = nameController.text;

          Navigator.of(context)
              .pop(CategoryTransaction(nameCategory: name, type: widget.type!, keyAt: DateTime.now().toString()));
        }
      },
    );
  }
}
