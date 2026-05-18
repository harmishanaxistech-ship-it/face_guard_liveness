import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class SmileDetector {
  static bool isSmiling(Face face) {
    return (face.smilingProbability ?? 0.0) > 0.7;
  }
}
