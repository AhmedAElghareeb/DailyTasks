import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:testing_design_and_api/components/txt_field.dart';
import 'package:testing_design_and_api/cubit/cubit.dart';
import 'package:testing_design_and_api/cubit/states.dart';
import 'package:testing_design_and_api/helper/helper_methods.dart';

//create database
//create tables
//open database
//insert
//get
//update
//delete

class HomeLayoutView extends StatelessWidget {
  const HomeLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            pushBack();
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: AppCubit.get(context).scaffoldKey,
            appBar: buildAppBar(context),
            body: state is AppGetDatabaseLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : AppCubit.get(context).screens[AppCubit.get(context).index],
            floatingActionButton: buildFloatingActionButton(context),
            bottomNavigationBar: buildBottomNavigationBar(context),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(
        AppCubit.get(context).titles[AppCubit.get(context).index],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        if (AppCubit.get(context).isOpened) {
          if (AppCubit.get(context).formKey.currentState!.validate()) {
            AppCubit.get(context).insertToDatabase(
              title: AppCubit.get(context).title.text,
              time: AppCubit.get(context).time.text,
              date: AppCubit.get(context).date.text,
            );
          }
        } else {
          AppCubit.get(context)
              .scaffoldKey
              .currentState!
              .showBottomSheet(
                (context) => buildSheet(context),
              )
              .closed
              .then((value) {
            AppCubit.get(context).changeBottomSheetState(
              isShow: false,
              icon: Icons.edit,
            );
          });
          AppCubit.get(context).changeBottomSheetState(
            isShow: true,
            icon: Icons.add,
          );
        }
      },
      child: Icon(AppCubit.get(context).icon),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.task,
            ),
            label: "Tasks"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
            ),
            label: "Done"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.archive,
            ),
            label: "Archived"),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: AppCubit.get(context).index,
      onTap: (idx) {
        AppCubit.get(context).changeIndex(idx);
      },
    );
  }

  Container buildSheet(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsetsDirectional.all(
        15,
      ),
      child: Form(
        key: AppCubit.get(context).formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultTxtField(
              controller: AppCubit.get(context).title,
              type: TextInputType.text,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Title must not be Empty";
                }
                return null;
              },
              label: "Title",
              prefix: Icons.title,
            ),
            const SizedBox(
              height: 15,
            ),
            defaultTxtField(
              controller: AppCubit.get(context).time,
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  AppCubit.get(context).time.text =
                      value!.format(context).toString();
                });
              },
              type: TextInputType.datetime,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Time must not be Empty";
                }
                return null;
              },
              label: "Time",
              prefix: Icons.watch_later_outlined,
            ),
            const SizedBox(
              height: 15,
            ),
            defaultTxtField(
              controller: AppCubit.get(context).date,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse(
                    "2025-01-01",
                  ),
                ).then((value) {
                  AppCubit.get(context).date.text =
                      DateFormat.yMMMd().format(value!);
                });
              },
              type: TextInputType.datetime,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Date must not be Empty";
                }
                return null;
              },
              label: "Date",
              prefix: Icons.calendar_month,
            ),
          ],
        ),
      ),
    );
  }
}
