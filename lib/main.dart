// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          //Los márgenes a los lados de las páginas:
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
          child: PageViews(),
        ),
      ),
    );
  }
}

class PageViews extends StatefulWidget {
  @override
  _PageViewsState createState() => _PageViewsState();
}

class _PageViewsState extends State<PageViews> {
  final PageController _controller = PageController(
    initialPage: 0,
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
      children: [
        Page1(),
        Page2(),
        Page3(),
        ItemListPage(),
        ScanQRPage(),
      ],
    );
  }
}

class ScanQRPage extends StatefulWidget {
  @override
  ScanQRPageState createState() {
    return ScanQRPageState();
  }
}

class ItemListPage extends StatefulWidget {
  @override
  State createState() => DynamicList();
}

class DynamicList extends State<ItemListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito"),
      ),
      body: ListView.builder(
        itemCount: listaCompras.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Text(listaCompras[index]);
        },
      ),
    );
  }
}

class ScanQRPageState extends State<ScanQRPage> {
  String result = "Escáner QR";
  String product = " ";
  int price = 0;
  String priceStr = " ";
  String currency = " ";
  final FlutterTts tts = FlutterTts();

  // FUNCIONES ON PRESSED (_)
  Future _addToCart(String item) async {
    tts.setLanguage("es-US");
    tts.setSpeechRate(0.4);
    listaCompras.add(item);
    Navigator.pop(context, 'OK');
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
        tts.speak("Producto escaneado:" + product + ". Precio: " + priceStr + " " + currency);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escáner QR"),
      ),
      body: const Center(
        child: Text(
          "Escáner QR",
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.camera_alt),
        label: const Text("Escanear Código"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//COLORES
const lightBlue = Color(0xff00bbff);
const mediumBlue = Color(0xff00a2fc);
const darkBlue = Color(0xff0075c9);

final lightGreen = Colors.green.shade300;
final mediumGreen = Colors.green.shade600;
final darkGreen = Colors.green.shade900;

final lightRed = Colors.red.shade300;
final mediumRed = Colors.red.shade600;
final darkRed = Colors.red.shade900;

List<String> listaCompras = [];

//Elementos de relleno (placeholders)
class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  const MyBox(this.color, {this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        color: color,
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}

//  Páginas de relleno (placeholders) utilizadas para demostrar la funcionalidad
// de deslizar entre pantallas
class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkGreen, height: 50),
          ],
        ),
        Row(
          children: [
            MyBox(lightGreen),
            MyBox(lightGreen),
          ],
        ),
        MyBox(mediumGreen, text: 'Página 1'),
        Row(
          children: [
            MyBox(lightGreen, height: 200),
            MyBox(lightGreen, height: 200),
          ],
        ),
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: const [
            MyBox(darkBlue, height: 50),
            MyBox(darkBlue, height: 50),
          ],
        ),
        Row(
          children: const [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
        const MyBox(mediumBlue, text: 'Página 2'),
        Row(
          children: const[
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
      ],
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkRed),
            MyBox(darkRed),
          ],
        ),
        MyBox(mediumRed, text: 'Página 3'),
        Row(
          children: [
            MyBox(lightRed),
            MyBox(lightRed),
            MyBox(lightRed),
          ],
        ),
      ],
    );
  }
}


// FUNCIONES DE AYUDA PARA SIMPLIFICAR EL ORDEN

String getProduct (String qrData) {
  const start = 'Producto:"';
  const end = '"';
  final startIndex = qrData.indexOf(start);
  final endIndex = qrData.indexOf(end, startIndex + start.length);

  return qrData.substring(startIndex + start.length, endIndex);
}

int getPrice (String qrData) {
  const start = 'Precio:"';
  const end = '"';
  final startIndex = qrData.indexOf(start);
  final endIndex = qrData.indexOf(end, startIndex + start.length);

  return int.parse(qrData.substring(startIndex + start.length, endIndex));
}

String getCurrency (String qrData) {
  const start = 'Moneda:"';
  const end = '"';
  final startIndex = qrData.indexOf(start);
  final endIndex = qrData.indexOf(end, startIndex + start.length);

  return qrData.substring(startIndex + start.length, endIndex);
}
