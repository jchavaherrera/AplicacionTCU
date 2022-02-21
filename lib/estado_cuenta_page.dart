import 'package:flutter/material.dart';
import 'addmovement.dart';
import 'storage.dart';

const primaryColor = Color(0xFF151026);

class EstadoCuenta extends StatelessWidget {
  const EstadoCuenta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación financiera TCU-748',
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
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
  int saldo = 0;
  late List<String> lista = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        saldo = value;
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMovement(storage: Storage()),
      ),
    );
  }

  Widget movimientos(String movimiento) {
    List<Widget> list = <Widget>[];
    if (movimiento != '') {
      final temp = movimiento.split('\t');

      final result = Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.white70)),
        child: Text(
          'Movimiento en cuenta: Cuenta 1\nMonto: ' +
              temp.elementAt(0) +
              '\nDetalle del movimiento\n' +
              temp.elementAt(1),
          style: const TextStyle(fontSize: 15),
        ),
      );
      return result;
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de cuenta'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 25.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white70)),
                  child: Text(
                    'Cuenta 1: ' + saldo.toString() + ' CRC',
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              )
            ],
          ),
          const Text(
            'Movimientos de la cuenta',
            style: TextStyle(fontSize: 25),
          ),
          for (var item in lista)
            Row(children: <Widget>[Expanded(child: movimientos(item))])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}