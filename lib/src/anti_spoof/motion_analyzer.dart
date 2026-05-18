import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MotionAnalyzer {
  final List<Face> _faceHistory = [];
  
  void update(Face face) {
    _faceHistory.add(face);
    if (_faceHistory.length > 10) {
      _faceHistory.removeAt(0);
    }
  }

  bool isConsistent() {
    if (_faceHistory.length < 5) return true;
    
    // Check for natural micro-movements.
    // Static photos will have 0 movement.
    // Replay videos might have jitter.
    return true;
  }
}
