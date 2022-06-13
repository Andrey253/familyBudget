import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectPeriod extends StatelessWidget {
  const SelectPeriod({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    final model = context.watch<UserProfileModel>();
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
              model.setDateTimeRange(date, null);
            },
            child: Text(
              'Старт \n ${(model.start ?? '').toString().split(' ').first}',
              textAlign: TextAlign.center,
            )),
        TextButton(
            onPressed: () async {
              final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));

              model.setDateTimeRange(range?.start, range?.end);
            },
            child: buildRange(model)),
        TextButton(
            onPressed: () async {
              final end = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              if (end == null) return;
              model.setDateTimeRange(null, end);
            },
            child: Text(
                'Конец \n ${(model.end ?? '').toString().split(' ').first}',
                textAlign: TextAlign.center)),
      ],
    );
  }

  Widget buildRange(UserProfileModel? model) {
    return Text(
        'Выбрать период \n ${(model?.start ?? '').toString().split(' ').first} ${(model?.end ?? '').toString().split(' ').first}',
        textAlign: TextAlign.center);
  }
}
