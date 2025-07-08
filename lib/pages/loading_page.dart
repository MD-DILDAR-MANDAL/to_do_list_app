import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/constants.dart';
import 'package:to_do_list_app/routes/routes.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool isLogin = false;
  String userId = "";

  startTimer() {
    Future.delayed(Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      isLogin = prefs.getBool("isLogin") ?? false;
      userId = prefs.getString("userId") ?? "";

      if (!isLogin) {
        Navigator.popAndPushNamed(context, RouteManager.loginPage);
      } else {
        if (userId.isNotEmpty) {
          Navigator.popAndPushNamed(
            context,
            RouteManager.taskPage,
            arguments: userId,
          );
        } else {
          Navigator.popAndPushNamed(context, RouteManager.loginPage);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Constants _constants = Constants();
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: _constants.primaryColor),
      ),
    );
  }
}
