import 'package:flutter/material.dart';
import 'package:to_do_list_app/pages/login_page.dart';
import 'package:to_do_list_app/pages/register_page.dart';
import 'package:to_do_list_app/pages/task_page.dart';

class RouteManager {
  static const String loginPage = "/";
  static const String registerPage = "/registerPage";
  static const String taskPage = "/taskPage";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data;
    if (settings.arguments != null) {
      data = settings.arguments;
    }
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case registerPage:
        return MaterialPageRoute(builder: (context) => RegisterPage());
      case taskPage:
        return MaterialPageRoute(builder: (context) => TaskPage(data));
      default:
        throw FormatException("Route not found! Check routes again!");
    }
  }
}
