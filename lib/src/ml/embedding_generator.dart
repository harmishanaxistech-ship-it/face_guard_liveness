import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'tflite_service.dart';

class EmbeddingGenerator {
  final TFLiteService _tfliteService;

  EmbeddingGenerator(this._tfliteService);

  Future<List<double>> generateEmbedding(img.Image faceImage) async {
    if (_tfliteService.interpreter == null) {
      throw Exception('TFLite model not loaded');
    }

    // Preprocess image (resize, normalize)
    // Assume model input is 112x112 for MobileFaceNet
    final resizedImage = img.copyResize(faceImage, width: 112, height: 112);
    final input = _imageToByteListFloat32(resizedImage, 112, 127.5, 127.5);

    final output = List<double>.filled(192, 0).reshape([1, 192]);
    _tfliteService.interpreter!.run(input, output);

    return List<double>.from(output[0]);
  }

  Uint8List _imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
