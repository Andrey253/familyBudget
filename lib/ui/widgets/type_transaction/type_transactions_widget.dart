import 'package:family_budget/domain/model/type_transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';

class TypeTransactionWidget extends StatelessWidget {
  const TypeTransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    final type = <TypeTrans>[
      TypeTrans(TypeTransaction.income, Colors.green),
      TypeTrans(TypeTransaction.expense, Colors.red),
      TypeTrans(TypeTransaction.all, Colors.blue),
      TypeTrans(TypeTransaction.addIncome, Colors.green.shade200),
      TypeTrans(TypeTransaction.addExpense, Colors.red.shade200),
    ];
    return SizedBox(
      height: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: type
              .map((typeTrans) => GestureDetector(
                    onLongPress: () => model.resetTypeTransaction(context),
                    onTap: () =>
                        model.selectTypeTransaction(context, typeTrans),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                          color: typeTrans.color,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(
                                    typeTrans.name == model.typeTransaction
                                        ? 3
                                        : -3,
                                    typeTrans.name == model.typeTransaction
                                        ? 3
                                        : -3),
                                color: Colors.grey,
                                blurRadius: 2,
                                spreadRadius: 1)
                          ]),
                      // color: Colors.red,
                      child: Center(
                        child: Text(typeTrans.name,
                            style: TextStyle(
                                color: typeTrans.name == model.typeTransaction
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center),
                      ),
                    ).paddingAll(4),
                  ))
              .toList()),
    );
  }
}

// class _GroupListRowWidget extends StatelessWidget {
//   final int indexInList;
//   const _GroupListRowWidget({
//     Key? key,
//     required this.indexInList,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final model = context.read<MainModel>();

//     final group = model.groups[indexInList];

//     return Slidable(
//       actionPane: const SlidableBehindActionPane(),
//       secondaryActions: <Widget>[
//         IconSlideAction(
//           caption: 'Delete',
//           color: Colors.red,
//           icon: Icons.delete,
//           onTap: () => model.deleteUser(indexInList, context),
//         ),
//       ],
//       child: ColoredBox(
//         color: Colors.white,
//         child: ListTile(
//           title: Text(group.name),
//           trailing: const Icon(Icons.chevron_right),
//           onTap: () => model.showTasks(context, indexInList),
//         ),
//       ),
//     );
//   }
// }
