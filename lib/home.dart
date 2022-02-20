import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addmovement.dart';
import 'storage.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      home: FlutterDemo(storage: Storage()),
    );
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

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
    setState(() {
      _counter++;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMovement(storage: Storage()),
      ),
    );
  }

  Widget movimientos(String movimiento) {
    List<Widget> list = <Widget>[];
    final temp = movimiento.split('\t');
    [for (var item in temp) list.add(Text(item))];
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Column(
        children: <Widget>[for (var item in lista) movimientos(item)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
