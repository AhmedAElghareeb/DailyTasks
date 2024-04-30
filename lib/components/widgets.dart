import 'package:flutter/material.dart';
import 'package:testing_design_and_api/cubit/cubit.dart';

Widget buildTaskItem(Map model, BuildContext context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDatabase(
        id: model['id'],
      );
    },
    child: Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            child: Center(
              child: Text(
                "${model['time']}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "${model['date']}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: "done",
                id: model["id"],
              );
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: "archive",
                id: model["id"],
              );
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
  );
}
