import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:family_budget/ui/widgets/tasks/tasks_widget_model.dart';
import 'package:provider/provider.dart';

class TasksWidget extends StatefulWidget {
  final int groupKey;
  const TasksWidget({
    Key? key,
    required this.groupKey,
  }) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  //late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    //   _model = TasksWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksWidgetModel(userKey: widget.groupKey),
      child: const TasksWidgetBody(),
    );
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TasksWidgetModel>();
    final title = model.user?.name ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<TasksWidgetModel>();
    return Column(
      children: [Text('Name user: ${model.user?.name}')],
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
    final model = context.read<TasksWidgetModel>();
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
            user?.name??'',
           // style: style,
          ),
        //  trailing: Icon(icon),
          onTap: () => null,
        ),
      ),
    );
  }
}
