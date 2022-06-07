import 'package:family_budget/ui/widgets/user_profile/user_profile_model.dart';
import 'package:family_budget/ui/widgets/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategoryInProfile extends StatefulWidget {
  const ListCategoryInProfile({Key? key}) : super(key: key);

  @override
  State<ListCategoryInProfile> createState() => _ListCategoryInProfileState();
}

class _ListCategoryInProfileState extends State<ListCategoryInProfile> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProfileModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: model.listTypes.length,
            itemBuilder: (context, index) => Card(
                  elevation: 8,
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () => model.addTransaction(context, model.listTypes[index]),
                        icon: const Icon(Icons.add)),
                    leading: Text(model.listTypes[index].type),
                    title: TextButton(
                        onPressed: () => {},
                        child: Text(
                            '${model.listTypes[index].nameCategory} ${model.listTypes[index].type}')),
                  ),
                )),
      ],
    );
  }
}
