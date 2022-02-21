import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter2.txt');
  }

  Future<File> get _localMovementsFile async {
    final path = await _localPath;
    return File('$path/movimientos2.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  Future<List<String>> readMovimientos() async {
    try {
      final file = await _localMovementsFile;

      String contents = await file.readAsString();
      var movements = contents.split('\n');

      return movements;
    } catch (e) {
      return <String>[];
    }
  }

  Future<File> writeMovements(String movimientos, String monto) async {
    final file = await _localMovementsFile;
    return file.writeAsString('$monto\t$movimientos\n', mode: FileMode.append);
  }
}
