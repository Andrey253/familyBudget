import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/type_transaction/transaction_dialog.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:family_budget/ui/widgets/users/users_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatefulWidget {
  final int groupKey;
  const UserProfileWidget({
    Key? key,
    required this.groupKey,
  }) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  //late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    //   _model = TasksWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileModel(userKey: widget.groupKey),
      child: const TasksWidgetBody(),
    );
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final title = model.user?.name ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.addTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<UserProfileModel>();
    return Column(
      children: [
        Text('Name user: ${model.user?.name}'),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TransactionDialog(onClickedDone: addTransaction,nameUser: model.user!.name,nameCategory: ''),
              ));
            },
            child: Text('Add Transaction')),
            ValueListenableBuilder<Box<Transaction>>(
      valueListenable: Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
      builder: (context, box, _) {
        final users = box.values.toList().cast<Transaction>();
        return SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: users.length,
                    itemBuilder: (context, index) => TextButton(
                        child: Text('${users[index].name} : ${users[index].amount}'),
                        onLongPress: () => context.read<UsersWidgetModel>().deleteGroup(index, context),
                        onPressed: () => context.read<UsersWidgetModel>().showTasks(context, index))),
              ),
              IconButton(
                  icon: const Icon(Icons.add), onPressed: () => context.read<UsersWidgetModel>().showForm(context))
            ],
          ),
        );
      },
    )
      ],
    );
  }

  Future addTransaction(String name, double amount, bool isExpense,String nameUser,String nameCategory) async {
    final transaction = Transaction()
      ..name = name
      ..createdDate = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense
      ..nameUser = nameUser
      ..nameCategory= nameCategory;

    final box =await Hive.openBox<Transaction>(HiveDbName.transactionBox);
  await  box.add(transaction);

  }
}
// class _TaskListWidget extends StatelessWidget {
//   const _TaskListWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final groupsCount = context.watch<TasksWidgetModel>().tasks.length ;
//     return ListView.separated(
//       itemCount: groupsCount,
//       itemBuilder: (BuildContext context, int index) {
//         return _TaskListRowWidget(indexInList: index);
//       },
//       separatorBuilder: (BuildContext context, int index) {
//         return const Divider(height: 1);
//       },
//     );
//   }
// }

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<UserProfileModel>();
    final user = model.user;

    // final icon = task.isDone ? Icons.done : null;
    // final style = task.isDone
    //     ? const TextStyle(
    //         decoration: TextDecoration.lineThrough,
    //       )
    //     : null;

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => null,
        ),
      ],
      child: ColoredBox(
        color: Colors.white,
        child: ListTile(
          title: Text(
            user?.name ?? '',
            // style: style,
          ),
          //  trailing: Icon(icon),
          onTap: () => null,
        ),
      ),
    );
  }
}
