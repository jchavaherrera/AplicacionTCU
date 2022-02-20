import 'package:flutter/material.dart';
import 'storage.dart';

import 'home.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<AddMovement> {
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
            controller: amountController,
          ),
        ),
        const Text('Detalle de la transacción'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: textController,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.storage.writeCounter(int.parse(amountController.text));
          widget.storage
              .writeMovements(textController.text, amountController.text);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        },
        tooltip: 'Agregar movimiento',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
