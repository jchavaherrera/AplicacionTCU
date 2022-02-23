import 'package:flutter/material.dart';
import 'lista_compras_page.dart';
import 'estado_cuenta_page.dart';

class PageViews extends StatefulWidget {
  const PageViews({Key? key}) : super(key: key);
  @override
  _PageViewsState createState() => _PageViewsState();
}

class _PageViewsState extends State<PageViews> {
  final PageController _controller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: const [
        EstadoCuenta(),
        ListaCompras(), //lista de compras
      ],
    );
  }
}
