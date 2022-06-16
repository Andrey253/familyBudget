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
              final showDatePickerStart = await showDatePicker(
                  context: context,
                  initialDate:start?? DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2025));
              if (showDatePickerStart == null) return;
              setDateTimeRange(showDatePickerStart, null);
            },
            child: Text(
              'Старт \n ${(start ?? '').toString().split(' ').first}',
              textAlign: TextAlign.center,
            )),
        TextButton(
            onPressed: () async {
              final range = await showDateRangePicker(
                  context: context,
                  initialDateRange:DateTimeRange(start: start??DateTime.now(), end: end??DateTime.now()),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));

              setDateTimeRange(range?.start, range?.end);
            },
            child: buildRange()),
        TextButton(
            onPressed: () async {
              final showDatePickerEnd = await showDatePicker(
                  context: context,
                  initialDate:end?? DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              if (showDatePickerEnd == null) return;
              setDateTimeRange(null, showDatePickerEnd);
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
