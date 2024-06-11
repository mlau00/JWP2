import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter_front/core/providers/tasks_provider.dart';
import 'package:todo_flutter_front/core/providers/user_provider.dart';
import 'package:todo_flutter_front/gui/screens/login_screen.dart';
import 'package:todo_flutter_front/gui/screens/my_home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TaskProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/mainScreen': (context) => const MyHomePage(),
        '/loginScreen': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: '/loginScreen',
      // const MyHomePage(),
    );
  }
}
