import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testing_design_and_api/cubit/states.dart';
import 'package:testing_design_and_api/modules/archived.dart';
import 'package:testing_design_and_api/modules/done.dart';
import 'package:testing_design_and_api/modules/tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int index = 0;

  late Database db;

  List<Widget> screens = [
    const TasksView(),
    const DoneView(),
    const ArchivedView(),
  ];

  List<String> titles = [
    "Tasks",
    "Done",
    "Archived",
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  bool isOpened = false;

  IconData icon = Icons.edit;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var title = TextEditingController();
  var time = TextEditingController();
  var date = TextEditingController();

  void changeIndex(int idx) {
    index = idx;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isOpened = isShow;
    icon = icon;

    emit(AppChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)",
            )
            .then((value) {})
            .catchError((error) {
          error.toString();
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);
      },
    ).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await db.transaction((txn) => txn
            .rawInsert(
                "INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'new')")
            .then((value) {
          emit(AppInsertDatabaseState());
          getDataFromDatabase(db);
        }).catchError((error) {
          error.toString();
        }));
  }

  void getDataFromDatabase(db) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    db
        .rawQuery(
      "SELECT * FROM tasks",
    )
        .then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    db.rawUpdate(
      "UPDATE tasks SET status = ? WHERE id = ?",
      [status, id],
    ).then((value) {
      getDataFromDatabase(db);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteFromDatabase({
    required int id,
  }) async {
    db.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(db);
      emit(AppDeleteFromDatabaseState());
    });
  }
}
