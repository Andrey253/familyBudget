import 'package:family_budget/ui/widgets/reports/drawer_report.dart';
import 'package:family_budget/ui/widgets/reports/income_expenses/income_expenses_report.dart';
import 'package:family_budget/ui/widgets/reports/transaction/transaction_report.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({Key? key, this.userName, required this.initialPage})
      : super(key: key);

  final String? userName;
  final int initialPage;
  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  int selected = 0;
  late PageController pageController;
  List<Widget> listWigget = [];
  @override
  void initState() {
    listWigget = [
      TransactionListMain(userName: widget.userName),
      IncomeExpensesReportWidget(userName: widget.userName)
    ];
    pageController = PageController(initialPage: widget.initialPage);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerReport(changePage: changePage),
      appBar: AppBar(
        title:const Text('Отчеты'),
      ),
      body: PageView(
        controller: pageController,
        children: listWigget,
        onPageChanged: (i) => changePage(i),
      ),
    );
  }

  changePage(int i) async {

    await pageController.animateToPage(i,
        duration:const Duration(milliseconds: 500), curve: Curves.linear);
  }
}
