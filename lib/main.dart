import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_design_and_api/helper/helper_methods.dart';
import 'package:testing_design_and_api/layouts/home_layout.dart';
import 'package:testing_design_and_api/observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: false,
        platform: TargetPlatform.iOS,
      ),
      home: HomeLayoutView(),
    );
  }
}
