import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:aplicacion_tcu/helper-functions/qr_functions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Todo {
  Todo({required this.name, required this.checked, required this.price});
  final String name;
  bool checked;
  final String price;
}

// Define a custom Form widget.
class ListaCompras extends StatefulWidget {
  const ListaCompras({Key? key}) : super(key: key);

  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _ListaComprasState extends State<ListaCompras> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  String result = " ";
  String product = " ";
  double price = 0;
  String priceStr = " ";
  String currency = " ";
  double total = 0;
  final FlutterTts tts = FlutterTts();

  Future _addToCart(String item) async {
    tts.setLanguage("es-US");
    tts.setSpeechRate(0.4);
    Navigator.pop(context, 'OK');
    _addTodoItem(product, priceStr);
    tts.speak("producto agregado al carrito");
  }

  Future _discardProduct() async {
    tts.setLanguage("es-US");
    tts.setSpeechRate(0.4);
    Navigator.pop(context, 'Cancel');
    tts.speak("Producto descartado");
  }

  Future _scanQR() async {
    tts.setLanguage("es-US");
    tts.setSpeechRate(0.4);
    try {
      var qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.rawContent;
        product = getProduct(result);
        price = getPrice(result);
        priceStr = price.toString();
        currency = getCurrency(result);
        tts.speak("Producto escaneado:" +
            product +
            ". Precio: " +
            priceStr +
            " " +
            currency);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(product),
            content: Text('Precio: ' + priceStr + " " + currency),
            actions: <Widget>[
              TextButton(
                onPressed: () => _discardProduct(),
                child: const Text('Descartar'),
              ),
              TextButton(
                onPressed: () => _addToCart(product),
                child: const Text('Agregar al carrito'),
              ),
            ],
          ),
        );
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "Permisos a la cámara denegados";
        });
      } else {
        setState(() {
          result = "Error desconocido: $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Nada fue escaneado";
      });
    } catch (ex) {
      setState(() {
        result = "Error desconocido: $ex";
      });
    }
  }

  void _addTodoItem(String name, String price) {
    setState(() {
      _todos.add(Todo(name: name, checked: false, price: price));
    });
    _textFieldController.clear();
    _textFieldController2.clear();
    total = total + double.parse(price);
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir objeto a la lista'),
          content: TextField(
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: 'Escribe el objeto a añadir'),
          ),
          actions: <Widget>[
            TextField(
              controller: _textFieldController2,
              decoration: const InputDecoration(hintText: 'Precio'),
            ),
            TextButton(
              child: const Text('Añadir'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(
                    _textFieldController.text, _textFieldController2.text);
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                _handleTodoChange(_todos[index]);
                              },
                              title: Text(_todos[index].name,
                                  style: _getTextStyle(_todos[index].checked)),
                              subtitle: Text(_todos[index].price + ' CRC'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      total = total - double.parse(_todos[index].price);
                                      setState(() {
                                        _todos.remove(_todos[index]);
                                      });
                                    },
                                    child: const Text('BORRAR')),
                                const SizedBox(width: 8),
                              ],
                            )
                          ]),
                    );
                  })),
                  SizedBox(height: 175, width: 300, child: Container(
                  margin: const EdgeInsets.only(bottom: 100.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white70)),
                  child: Text(
                    'Total: ' + total.toString() + ' CRC',
                    style: const TextStyle(fontSize: 25),
                  ),
                ),)
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _displayDialog(),
            heroTag: null,
          ),
          SizedBox(width: 50,),
          FloatingActionButton(
            child: const Icon(Icons.camera_alt),
            onPressed: _scanQR,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
