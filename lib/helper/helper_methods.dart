import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

pushBack([dynamic data]) {
  return Navigator.of(navigatorKey.currentContext!).pop(data);
}
