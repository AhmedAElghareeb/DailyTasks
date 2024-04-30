import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_design_and_api/components/widgets.dart';
import 'package:testing_design_and_api/cubit/cubit.dart';
import 'package:testing_design_and_api/cubit/states.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return tasks.isEmpty
            ? const Center(
                child: Text(
                  "No Tasks Yet, Please Add Some Tasks :)",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.red),
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(
                  tasks[index],
                  context,
                ),
                separatorBuilder: (context, index) => Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 2,
                  color: Colors.grey[100],
                ),
                itemCount: tasks.length,
              );
      },
    );
  }
}
