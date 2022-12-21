import 'package:flutter/material.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/home/widgets/task.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'TASK\'S de HOJE',
          style: context.titleStyle,
        ),
        Column(
          children: [
            Task(),
            Task(),
            Task(),
            Task(),
            Task(),
            Task(),
            Task(),
          ],
        )
      ],
    ));
  }
}
