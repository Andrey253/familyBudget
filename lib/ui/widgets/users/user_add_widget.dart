import 'package:family_budget/ui/widgets/users/users_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddWidget extends StatefulWidget {
  const UserAddWidget({Key? key}) : super(key: key);

  @override
  _UserAddWidgetState createState() => _UserAddWidgetState();
}

class _UserAddWidgetState extends State<UserAddWidget> {
  // final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersWidgetModel>(
      create: (contex) => UsersWidgetModel(),
      child: const _GroupFormWidgetBody(),
    );
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление пользователя'),
      ),
      body: Center(
        child: Container(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _GroupNameWidget(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UsersWidgetModel>().saveGroup(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<UsersWidgetModel>();
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Имя группы',
      ),
      onChanged: (value) => model.groupName = value,
      onEditingComplete: () => model.saveGroup(context),
    );
  }
}
