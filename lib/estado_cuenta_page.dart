import 'package:flutter/material.dart';
import 'addmovement.dart';
import 'storage.dart';

class Summary extends StatelessWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SummaryWidget(storage: Storage());
  }
}

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  int saldo = 0;
  late List<String> lista = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readBalance().then((int value) {
      setState(() {
        saldo = value;
      });
    });
    widget.storage.readMovements().then((value) {
      setState(() {
        lista = value;
        lista.length;
      });
    });
  }

  void addMovement() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMovement(storage: Storage()),
      ),
    );
  }

  Widget movements(String movimiento) {
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
            'Movimientos de la cuenta:\n',
            style: TextStyle(fontSize: 25),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(child: movements(lista[index]));
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMovement,
        tooltip: 'Agregar movimiento',
        child: const Icon(Icons.add),
      ),
    );
  }
}
