import 'package:flutter/material.dart';
import 'package:nanotech_app/funcoes/session_manager.dart';
import 'package:nanotech_app/telas/dashboard.dart';
import 'package:nanotech_app/telas/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SessionManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanotech - Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/formulario': (context) => Dashboard(),
      },
    );
  }
}
