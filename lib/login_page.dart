import 'dart:async';

import 'package:flutter/material.dart';
import 'package:aplicacion_tcu/page_views.dart';
import 'package:local_auth/local_auth.dart';
import 'storage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 15),
            child: const Text(
              'TCU 748:\nAsistente\nfinanciero para\npersonas con\ndiscapacidad\nvisual',
              style: TextStyle(
                fontSize: 35,
              ),
            )),
        TextButton(
          child: const Text(
            'Ingresar',
            style: TextStyle(fontSize: 35),
          ),
          onPressed: () async {
            bool isAuthenticated =
                await Authentication.authenticateWithBiometrics();

            if (true) {
              //isAuthenticated) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PageViews(),
                ),
              );
            }
          },
        ),
      ],
    )));
  }
}

class Authentication {
  static Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        biometricOnly: true,
      );
    }

    return isAuthenticated;
  }
}
