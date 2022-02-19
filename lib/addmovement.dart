import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localMovementsFile async {
    final path = await _localPath;
    return File('$path/movements.txt');
  }

  Future<File> writeMovements(String movimientos) async {
    final file = await _localMovementsFile;

    return file.writeAsString(movimientos, mode: FileMode.append);
    // Write the file
    //return file.writeAsString(movimientos.toString());
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class AddMovement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agregar movimiento',
      home: CustomForm(storage: CounterStorage()),
    );
  }
}

class CustomForm extends StatefulWidget {
  const CustomForm({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<CustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final textController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Column(children: [
        const Text('Monto de la transacción'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: textController,
          ),
        ),
        const Text('Detalle de la transacción'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: amountController,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          widget.storage.writeCounter(int.parse(amountController.text));
          widget.storage.writeMovements(textController.text);
          Navigator.pop(context);
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
