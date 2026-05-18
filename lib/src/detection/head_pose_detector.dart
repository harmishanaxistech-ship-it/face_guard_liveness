import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class HeadPoseDetector {
  static bool isLookingLeft(Face face) => (face.headEulerAngleY ?? 0.0) > 20;
  static bool isLookingRight(Face face) => (face.headEulerAngleY ?? 0.0) < -20;
  static bool isLookingUp(Face face) => (face.headEulerAngleX ?? 0.0) > 15;
  static bool isLookingDown(Face face) => (face.headEulerAngleX ?? 0.0) < -15;
}
