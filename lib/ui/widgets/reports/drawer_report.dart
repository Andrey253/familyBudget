import 'package:flutter/material.dart';

class DrawerReport extends StatelessWidget {
  const DrawerReport({
    Key? key,
    this.userName,
    required this.changePage,
  }) : super(key: key);
  final String? userName;
  final Function(int i) changePage;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Center(child: Text('Отчеты', style: TextStyle(fontSize: 32))),
        const SizedBox(height: 10),
        TextButton.icon(
            onPressed: () {
                  Navigator.pop(context);
              changePage(0);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('Транзакции')),
        TextButton.icon(
           onPressed: () {
                  Navigator.pop(context);
              changePage(1);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('Доходы/Расходы')),
        TextButton.icon(
            onPressed: () {
                  Navigator.pop(context);
              changePage(2);
            },
            icon: const Icon(Icons.arrow_right),
            label: const Text('По категориям')),
      ],
    ));
  }
}
