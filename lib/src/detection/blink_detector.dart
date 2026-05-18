import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class BlinkDetector {
  static bool isBlinking(Face face) {
    final leftEye = face.leftEyeOpenProbability ?? 1.0;
    final rightEye = face.rightEyeOpenProbability ?? 1.0;
    return leftEye < 0.2 && rightEye < 0.2;
  }
}
