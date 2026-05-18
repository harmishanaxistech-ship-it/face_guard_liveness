import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;

  Future<void> loadModel(String modelPath) async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  Interpreter? get interpreter => _interpreter;

  void dispose() {
    _interpreter?.close();
  }
}
