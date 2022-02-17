import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'addmovement.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> get _localMovementsFile async {
    final path = await _localPath;
    return File('$path/movements.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<List<String>> readMovimientos() async {
    try {
      final file = await _localMovementsFile;

      // Read the file
      String contents = await file.readAsString();
      var movements = contents.split('\n');

      return movements;
    } catch (e) {
      // If encountering an error, return 0
      return <String>[];
    }
  }

  Future<File> writeMovements(List<String> movimientos) async {
    final file = await _localMovementsFile;

    return file.writeAsString(movimientos.toString());

    // Write the file
    //return file.writeAsString(movimientos.toString());
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;
  late List<String> lista;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
    widget.storage.readMovimientos().then((value) {
      setState(() {
        lista = value;
        lista.length;
      });
    });
  }

  void _incrementCounter() {
    //Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMovement(),
      ),
    );
    // Write the variable as a string to the file.
    //return widget.storage.writeMovements(lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Column(
        children: <Widget>[for (var item in lista) Text(item)],
        /*child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),*/
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
