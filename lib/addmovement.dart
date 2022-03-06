import 'package:flutter/material.dart';
import 'storage.dart';
import 'page_views.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  MovementForm createState() => MovementForm();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class MovementForm extends State<AddMovement> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final detailController = TextEditingController();
  final balanceController = TextEditingController();
  int balance = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readBalance().then((int value) {
      setState(() {
        balance = value;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    detailController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Movimiento'),
      ),
      body: Column(children: [
        const Text('Monto de la transacción'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: balanceController,
          ),
        ),
        const Text('Detalle de la transacción'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: detailController,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.storage
              .writeBalance(int.parse(balanceController.text) + balance);
          widget.storage
              .writeMovements(detailController.text, balanceController.text);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PageViews(),
            ),
          );
        },
        tooltip: 'Agregar movimiento',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
