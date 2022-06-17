import 'package:family_budget/domain/model/type_transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:family_budget/extentions.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';

class TypeTransactionWidget extends StatelessWidget {
  const TypeTransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    final type = model.type();
    return SizedBox(
      height: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: type
              .map((typeT) => GestureDetector(
                    onLongPress: () => model.resetTypeTransaction(context),
                    onTap: () => model.selectTypeTransaction(context, typeT),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                          color: typeT.color,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(
                                    typeT.name == model.typeTransaction
                                        ? 0
                                        : -3,
                                    typeT.name == model.typeTransaction
                                        ? 0
                                        : -3),
                                color: Colors.grey,
                                blurRadius: 2,
                                spreadRadius: 1)
                          ]),
                      // color: Colors.red,
                      child: Center(
                        child: Text(typeT.name,
                            style: TextStyle(
                                color: typeT.name == model.typeTransaction
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center),
                      ),
                    ).paddingAll(4),
                  ))
              .toList()),
    );
  }
}
