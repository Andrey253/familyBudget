import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/type_transaction_model.dart';
import 'package:family_budget/ui/widgets/users/users_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TypeTransactionWidget extends StatelessWidget {
  const TypeTransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<String>>(
      valueListenable: Hive.box<String>(HiveDbName.typeBox).listenable(),
      builder: (context, box, _) {
        final types = box.values.toList();

        return SizedBox(
          height: 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: types.length,
                    itemBuilder: (context, index) => TextButton(
                          child: Text(types[index]),
                          onLongPress: () => context.read<TypeTransactionsWidgetModel>().deleteGroup(index, context),
                          onPressed: () =>
                              context.read<UsersWidgetModel>().selectTypeTransaction(context, types[index]),
                        )),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.read<TypeTransactionsWidgetModel>().addCategory(context),
                )
              ],
            ),
          ),
        );
      },
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
