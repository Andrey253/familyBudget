import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectPeriodMain extends StatelessWidget {
  const SelectPeriodMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
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
              model.dateTimeRange = DateTimeRange(
                  start: date, end: model.dateTimeRange?.end ?? DateTime(2220));

              model.setState();
            },
            child: Text(
              'Старт \n ${model.dateTimeRange?.start.toString().split(' ').first ?? ''}',
              textAlign: TextAlign.center,
            )),
        TextButton(
            onPressed: () async {
              model.dateTimeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));

              model.setState();
            },
            child: buildRange(model.dateTimeRange)),
        TextButton(
            onPressed: () async {
              final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              if (date == null) return;
              model.dateTimeRange = DateTimeRange(
                  start: model.dateTimeRange?.start ?? DateTime(0), end: date);

              model.setState();
            },
            child: Text(
                'Конец \n ${model.dateTimeRange?.end.toString().split(' ').first ?? ''}',
                textAlign: TextAlign.center)),
      ],
    );
  }

  Widget buildRange(DateTimeRange? dateTimeRange) {
    return Text(
        'Выбрать период \n ${dateTimeRange?.start.toString().split(' ').first ?? ''} ${dateTimeRange?.end.toString().split(' ').first ?? ''}',
        textAlign: TextAlign.center);
  }
}
