import 'dart:async';
import 'pageViews.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('Ingresar'),
          onPressed: () async {
            bool isAuthenticated =
                await Authentication.authenticateWithBiometrics();

            if (isAuthenticated) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageViews(),
                ),
              );
            }

            ///Navigator.push(context, MaterialPageRoute(builder: (context) {
            ///  return HomeScreen();
            ///}));
          },
        ),
      ),
    );
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
