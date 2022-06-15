import 'package:family_budget/domain/sourse/string.dart';
import 'package:flutter/material.dart';

class DrawerReport extends StatelessWidget {
  const DrawerReport({
    Key? key,
    required this.selectReport,
    this.userName,
  }) : super(key: key);

  final void Function(int i, [String? userName]) selectReport;
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Center(child: Text('Отчеты', style: TextStyle(fontSize: 32))),
        const SizedBox(height: 10),
        ...itemsDrawer.map((e) => TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              selectReport(e.idex, userName);
            },
            icon: const Icon(Icons.arrow_right),
            label: Text(e.name))),
      ],
    ));
  }
}
