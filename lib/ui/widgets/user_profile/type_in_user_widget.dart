import 'package:family_budget/domain/model/type_transaction.dart';
import 'package:family_budget/domain/sourse/string.dart';
import 'package:family_budget/extentions.dart';
import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TypeInUserProfile extends StatelessWidget {
  const TypeInUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();
    final type = <TypeTrans>[
      TypeTrans(TypeTransaction.all, Colors.blue),
      TypeTrans(TypeTransaction.income, Colors.green),
      TypeTrans(TypeTransaction.expense, Colors.red),
    ];

    return SizedBox(
      height: 80,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: type
              .map((typeTrans) => GestureDetector(
                    onLongPress: () =>
                        model.resetTypeTransaction(context, typeTrans.name),
                    onTap: () =>
                        model.selectTypeTransaction(context, typeTrans.name),
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: typeTrans.color,
                      ),
                      // color: Colors.red,
                      child: Center(
                        child: Text(
                          typeTrans.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: typeTrans.name == model.typeTransaction
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ).paddingAll(4),
                  ))
              .toList()),
    );
  }
}
