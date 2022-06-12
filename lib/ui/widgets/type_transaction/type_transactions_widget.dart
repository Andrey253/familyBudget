import 'package:family_budget/domain/model/type_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';

class TypeTransactionWidget extends StatelessWidget {
  const TypeTransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = <TypeTrans>[
      TypeTrans(
          TypeTransaction.all,
           Colors.blue),
      TypeTrans(
          TypeTransaction.income,
          Colors.green),
      TypeTrans(
          TypeTransaction.expense,
           Colors.red),
    ];
    return SizedBox(
      height: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: type
              .map((typeString) => GestureDetector(
                    onLongPress: () =>
                        context.read<MainModel>().resetTypeTransaction(context),
                    onTap: () => context
                        .read<MainModel>()
                        .selectTypeTransaction(context, typeString.name),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                         color: typeString.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: Colors.red,
                      child: Center(
                        child:
                            Text(typeString.name, textAlign: TextAlign.center),
                      ),
                    ).paddingAll(4),
                  ))
              .toList()),
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainModel>();

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
