import 'package:flutter/material.dart';
import 'package:family_budget/ui/widgets/task_form/task_form_widget_model.dart';
import 'package:provider/provider.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({
    Key? key,
    required this.groupKey,
  }) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=> TaskFormWidgetModel(groupKey: widget.groupKey),
      child: const _TextFormWidgetBody(),
    );
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: Center(
        child: Container(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _TaskTextWidget(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TaskFormWidgetModel>().saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<TaskFormWidgetModel>();
    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Текст задачи',
      ),
      onChanged: (value) => model.taskText = value,
      onEditingComplete: () => model.saveTask(context),
    );
  }
}
