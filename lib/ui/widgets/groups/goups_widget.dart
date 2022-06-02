import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:family_budget/ui/widgets/groups/goups_widget_model.dart';
import 'package:provider/provider.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  //final model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersWidgetModel>(
      create: (context) => UsersWidgetModel(),
      child: const _GroupsWidgetBody(),
    );
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UsersWidgetModel>().showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final groupsCount = GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ValueListenableBuilder<Box<User>>(
      valueListenable: Hive.box<User>('users_box').listenable(),
      builder: (context, box, _) {
        final transactions = box.values.toList().cast<User>();

        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: transactions.length,
            itemBuilder: (context, index) => TextButton(
                  child: Text(transactions[index].name),
                  onLongPress: () => context.read<UsersWidgetModel>().deleteGroup(index, context),
                  onPressed:() => context.read<UsersWidgetModel>().showTasks(context, index),
                ));
      },
    );
  }
}

// @override
// Widget build2(BuildContext context) {
//   final groupsCount = GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
//   return ListView.separated(
//     itemCount: groupsCount,
//     itemBuilder: (BuildContext context, int index) {
//       return _GroupListRowWidget(indexInList: index);
//     },
//     separatorBuilder: (BuildContext context, int index) {
//       return const Divider(height: 1);
//     },
//   );
// }

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
          onTap: () => model.deleteGroup(indexInList, context),
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
