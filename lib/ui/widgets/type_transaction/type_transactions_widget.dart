import 'package:family_budget/extentions.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
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
                IconButton(
                  icon: const Icon(Icons.done_all),
                  onPressed: () => context.read<MainModel>().resetTypeTransaction(context),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: types.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onLongPress: () => context.read<MainModel>().deleteTypeTransaction(index, context),
                          onTap: () => context.read<MainModel>().selectTypeTransaction(context, types[index]),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              // color: Colors.primaries[index],
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [Colors.primaries[(index + 4) % 18], Colors.primaries[(index + 10) % 18]]),
                            ),
                            // color: Colors.red,
                            child: Center(
                              child: Text(types[index]),
                            ),
                          ).paddingAll(4),
                        )),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.read<MainModel>().addType(context),
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
