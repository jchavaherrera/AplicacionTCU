import 'package:flutter/material.dart';
import 'lista_compras_page.dart';
import 'estado_cuenta_page.dart';

int bottomSelectedIndex = 0;

List<BottomNavigationBarItem> buildBottomNavbarItems() {
  return [
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_balance),
      label: 'Cuenta',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Carrito',
    )
  ];
}

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

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      _controller.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: const [
          EstadoCuenta(),
          ListaCompras(), //lista de compras
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
      },
        items: buildBottomNavbarItems(),
      ),
    );
  }
}
