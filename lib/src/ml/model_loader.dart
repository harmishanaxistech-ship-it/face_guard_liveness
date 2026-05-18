import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ModelLoader {
  static Future<File> loadModelFromAssets(String assetPath) async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = join(dbDir.path, assetPath);

    final file = File(dbPath);
    if (!await file.exists()) {
      await file.create(recursive: true);
      final byteData = await rootBundle.load('assets/$assetPath');
      await file.writeAsBytes(byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ));
    }
    return file;
  }
}
