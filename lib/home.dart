import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('doodi!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
