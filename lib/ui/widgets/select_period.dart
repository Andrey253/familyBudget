import 'package:flutter/material.dart';

class SelectPeriod extends StatelessWidget {
  const SelectPeriod({
    Key? key,
    required this.setDateTimeRange,
    this.start,
    this.end,
  }) : super(key: key);
  final Function(DateTime? start, DateTime? end) setDateTimeRange;
  final DateTime? start;
  final DateTime? end;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () async {
              final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              if (date == null) return;
              setDateTimeRange(date, null);
            },
            child: Text(
              'Старт \n ${(start ?? '').toString().split(' ').first}',
              textAlign: TextAlign.center,
            )),
        TextButton(
            onPressed: () async {
              final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));

              setDateTimeRange(range?.start, range?.end);
            },
            child: buildRange()),
        TextButton(
            onPressed: () async {
              final end = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              if (end == null) return;
              setDateTimeRange(null, end);
            },
            child: Text('Конец \n ${(end ?? '').toString().split(' ').first}',
                textAlign: TextAlign.center)),
      ],
    );
  }

  Widget buildRange() {
    return Text(
        'Выбрать период \n ${(start ?? '').toString().split(' ').first} ${(end ?? '').toString().split(' ').first}',
        textAlign: TextAlign.center);
  }
}
