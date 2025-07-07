import 'package:flutter/material.dart';
import 'package:to_do_list_app/pages/login_page.dart';

class RouteManager {
  static const String loginPage = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      default:
        throw FormatException("Route not found! Check routes again!");
    }
  }
}
