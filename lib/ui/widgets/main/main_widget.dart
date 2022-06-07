import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/main/circular_bar.dart';
import 'package:family_budget/ui/widgets/type_transaction/list_category_transaction.dart';
import 'package:family_budget/ui/widgets/type_transaction/type_transactions_widget.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:family_budget/domain/entity/user.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //final model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (context) => MainModel(),
      child: const _GroupsWidgetBody(),
    );
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Члены семьи'),
      ),
      body: Column(
        children: [
          _UserListWidget(),
          Text('Типы транзакций'),
          TypeTransactionWidget(),
          ListCategoryTransaction(),
          Expanded(
            child: ValueListenableBuilder<Box<Transaction>>(
              valueListenable: Hive.box<Transaction>(HiveDbName.transactionBox).listenable(),
              builder: (context, box, _) {
                final transactions = box.values
                    .toList()
                    .cast<Transaction>()
                    .where((element) =>
                        model.typeTransaction != null ? element.typeTransaction == model.typeTransaction : true)
                    .toList();
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) => Card(
                          elevation: 5,
                          child: ListTile(
                            leading: Text(transactions[index].typeTransaction),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: transactions[index].delete,
                            ),
                            subtitle: Text(
                                '${transactions[index].createdDate} ${transactions[index].nameUser} ${transactions[index].nameCategory} ${transactions[index].name} '),
                            title: Text('${transactions[index].name} : ${transactions[index].amount}'),
                          ),
                        ));
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<MainModel>().showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UserListWidget extends StatelessWidget {
  const _UserListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(
      valueListenable: Hive.box<User>(HiveDbName.userBox).listenable(),
      builder: (context, box, _) {
        final users = box.values.toList().cast<User>();
        return SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onLongPress: () => context.read<MainModel>().deleteUser(index, context),
                          onTap: () => context.read<MainModel>().showTasks(context, index),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              //  color: Colors.primaries[index],
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [Colors.primaries[index % 18], Colors.primaries[(index * 2 + 1) % 18]]),
                            ),
                            // color: Colors.red,
                            child: Center(
                              child: Text(users[index].name),
                            ),
                          ).paddingAll(4),
                        )),
              ),
              GestureDetector(
                onTap: () => context.read<MainModel>().showForm(context),
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    // color: Colors.primaries[9],
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [Colors.primaries[10], Colors.primaries[12]]),
                  ),
                  // color: Colors.red,
                  child: const Center(child: Text('Добавить члена семьи', textAlign: TextAlign.center)),
                ),
              ).paddingAll(4),
            ],
          ),
        );
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
