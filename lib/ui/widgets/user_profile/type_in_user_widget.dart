import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:family_budget/ui/widgets/users/users_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TypeInUserProfile extends StatelessWidget {
  const TypeInUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final types = Hive.box<String>(HiveDbName.typeBox).values.toList();

    return SizedBox(
      height: 80,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: types.length,
          itemBuilder: (context, index) => TextButton(
                child: Text(types[index]),
                //   onLongPress: () => context.read<TypeTransactionsWidgetModel>().deleteGroup(index, context),

                onPressed: () => model.selectTypeTransaction(context, types[index]),
                onLongPress: () => model.resetTypeTransaction(context, types[index]),
                // onPressed: () {
                //   Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => TransactionDialog(
                //         onClickedDone: addTransaction, nameUser: model.user!.name, nameCategory: types[index]),
                //   ));
                // },
              )),
    );
  }

  Future addTransaction(String name, double amount, bool isExpense, String nameUser, String nameCategory) async {
    final transaction = Transaction()
      ..name = name
      ..createdDate = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense
      ..nameUser = nameUser
      ..nameCategory = nameCategory;

    final box = Hive.box<Transaction>(HiveDbName.transactionBox);
    await box.put(transaction.createdDate.toString(), transaction);
  }
}

//незадействовано
class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<UsersWidgetModel>();

    final group = model.groups[indexInList];

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteUser(indexInList, context),
        ),
      ],
      child: ColoredBox(
        color: Colors.white,
        child: ListTile(
          title: Text(group.name),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => model.showTasks(context, indexInList),
        ),
      ),
    );
  }
}
