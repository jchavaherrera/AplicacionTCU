import 'package:flutter/material.dart';
import 'package:aplicacion_tcu/home.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Center(
        child: FlatButton(
          child: Text('Ingresar'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          },
        ),
      ),
    );
  }
}
