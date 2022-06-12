import 'package:family_budget/domain/entity/transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/main.dart';
import 'package:family_budget/ui/widgets/indicators/indicator_type.dart';
import 'package:family_budget/ui/widgets/user_profile/list_category_in_profile.dart';
import 'package:family_budget/ui/widgets/type_transaction/select_period_main.dart';
import 'package:family_budget/ui/widgets/user_profile/select_period.dart';
import 'package:family_budget/ui/widgets/user_profile/type_in_user_widget.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/gestures.dart';
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
      child: const TransactionsWidgetBody(),
    );
  }
}

class TransactionsWidgetBody extends StatelessWidget {
  const TransactionsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final title = model.user?.name ?? '';
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      drawer: Drawer(
          child: TextButton.icon(
              onPressed: () {}, icon: Icon(Icons.add), label: Text('First'))),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          const TypeInUserProfile(),
          const ListCategoryInProfile(),
          const SelectPeriod(),
          IndicatorFamalyBudget(
              userName: model.user?.name, dateTimeRange: model.dateTimeRange),
        ],
      ),
    );
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
