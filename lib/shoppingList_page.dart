import 'package:flutter/material.dart';

class Todo {
  Todo({required this.name, required this.checked, required this.price});
  final String name;
  bool checked;
  final String price;
}

// Define a custom Form widget.
class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
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

    return TextStyle(
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
class _TodoListState extends State<TodoList> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  void _addTodoItem(String name, String price) {
    setState(() {
      _todos.add(Todo(name: name, checked: false, price: price));
    });
    _textFieldController.clear();
    _textFieldController2.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
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
      body: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  onTap: () {
                    _handleTodoChange(_todos[index]);
                  },
                  title: Text(_todos[index].name,
                      style: _getTextStyle(_todos[index].checked)),
                  subtitle: Text(_todos[index].price),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
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
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }
}
