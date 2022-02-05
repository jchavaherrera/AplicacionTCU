// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "Escáner QR";
  final FlutterTts tts = FlutterTts();

  Future _scanQR() async {
    tts.setLanguage("es-US");
    tts.setSpeechRate(0.4);

    try {
      var qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.rawContent;
        tts.speak(result);
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
      body: Center(
        child: Text(
          result,
          style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
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
