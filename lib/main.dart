import 'package:aplicacion_tcu/login_page.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF151026);
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: LoginPage(),
    );
  }
}
