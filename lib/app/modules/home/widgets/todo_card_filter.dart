import 'package:flutter/material.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/total_tasks_model.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final TotalTasksModel? totalTasksModel;
  final bool selected;
  const TodoCardFilter(
      {Key? key,
      required this.label,
      required this.taskFilter,
      this.totalTasksModel,
      required this.selected})
      : super(key: key);

  double _getPercentFinish() {
    final total = totalTasksModel?.totalTasks ?? 0.0;
    final totalFinish = totalTasksModel?.totalTaskFinish ?? 0.1;

    if (total == 0) {
      return 0.0;
    }
    final percent = (totalFinish * 100) / total;
    return percent / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 110,
        maxWidth: 130,
      ),
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: selected ? context.primaryColor : Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.grey.withOpacity(0.8),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${totalTasksModel?.totalTasks ?? 0} Tasks',
            style: context.titleStyle.copyWith(
              fontSize: 10,
              color: selected ? Colors.white : Colors.grey,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0.0,
              end: _getPercentFinish(),
            ),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                backgroundColor:
                    selected ? context.primaryColorLight : Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                    selected ? Colors.white : context.primaryColor),
                value: value,
              );
            },
            duration: Duration(seconds: 1),
          ),
        ],
      ),
    );
  }
}
