import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/firebase_options.dart';
import 'package:to_do_list_app/routes/routes.dart';
import 'package:to_do_list_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list_app/services/user_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (_) => Auth()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'Todo List',
        initialRoute: RouteManager.loginPage,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
