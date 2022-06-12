import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/model/type_transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TypeInUserProfile extends StatelessWidget {
  const TypeInUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final type = <TypeTrans>[
      TypeTrans(TypeTransaction.all, Colors.blue),
      TypeTrans(TypeTransaction.income, Colors.green),
      TypeTrans(TypeTransaction.expense, Colors.red),
    ];
    print('teg ${model.typeTransaction} ');

    return SizedBox(
      height: 80,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: type
              .map((typeTrans) => GestureDetector(
                    onLongPress: () =>
                        model.resetTypeTransaction(context, typeTrans.name),
                    onTap: () =>
                        model.selectTypeTransaction(context, typeTrans.name),
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: typeTrans.color,
                      ),
                      // color: Colors.red,
                      child: Center(
                        child: Text(
                          typeTrans.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: typeTrans.name == model.typeTransaction
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ).paddingAll(4),
                  ))
              .toList()),
    );
  }

  // Future addTransaction(String name, double amount, bool isExpense,
  //     String nameUser, String nameCategory) async {
  //   final transaction = Transaction(
  //       name: name,
  //       createdDate: DateTime.now(),
  //       amount: amount,
  //       isExpense: isExpense,
  //       nameUser: nameUser,
  //       nameCategory: nameCategory,
  //       typeTransaction: );

  //   final box = Hive.box<Transaction>(HiveDbName.transactionBox);
  //   await box.add(transaction);
  // }
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
    final model = context.read<MainModel>();

    final group = model.users[indexInList];

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
