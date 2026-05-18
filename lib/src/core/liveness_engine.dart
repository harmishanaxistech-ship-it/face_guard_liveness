import 'dart:async';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../enums/liveness_action.dart';
import '../enums/failure_reason.dart';
import '../models/liveness_result.dart';
import '../detection/blink_detector.dart';
import '../detection/smile_detector.dart';
import '../detection/head_pose_detector.dart';

class LivenessEngine {
  final List<LivenessAction> requiredActions;
  final Duration timeout;
  
  int _currentActionIndex = 0;
  final List<LivenessAction> _completedActions = [];
  bool _isCompleted = false;
  Timer? _timeoutTimer;

  LivenessEngine({
    required this.requiredActions,
    this.timeout = const Duration(seconds: 30),
  });

  LivenessAction? get currentAction => 
    _currentActionIndex < requiredActions.length ? requiredActions[_currentActionIndex] : null;

  double get progress => requiredActions.isEmpty ? 1.0 : _completedActions.length / requiredActions.length;

  void start(Function(FailureReason) onTimeout) {
    _timeoutTimer = Timer(timeout, () {
      if (!_isCompleted) {
        onTimeout(FailureReason.timeout);
      }
    });
  }

  bool processFace(Face face) {
    if (_isCompleted) return true;

    final action = currentAction;
    if (action == null) {
      _isCompleted = true;
      _timeoutTimer?.cancel();
      return true;
    }

    bool success = false;
    switch (action) {
      case LivenessAction.blink:
        success = BlinkDetector.isBlinking(face);
        break;
      case LivenessAction.smile:
        success = SmileDetector.isSmiling(face);
        break;
      case LivenessAction.turnLeft:
        success = HeadPoseDetector.isLookingLeft(face);
        break;
      case LivenessAction.turnRight:
        success = HeadPoseDetector.isLookingRight(face);
        break;
      case LivenessAction.lookUp:
        success = HeadPoseDetector.isLookingUp(face);
        break;
      case LivenessAction.lookDown:
        success = HeadPoseDetector.isLookingDown(face);
        break;
    }

    if (success) {
      _completedActions.add(action);
      _currentActionIndex++;
      if (_currentActionIndex >= requiredActions.length) {
        _isCompleted = true;
        _timeoutTimer?.cancel();
        return true;
      }
    }

    return false;
  }

  LivenessResult getResult() {
    if (_isCompleted && _completedActions.length == requiredActions.length) {
      return LivenessResult.success(
        confidence: 1.0, // Simplified
        completedActions: _completedActions,
      );
    } else {
      return LivenessResult.failure(
        reason: FailureReason.timeout,
        completedActions: _completedActions,
      );
    }
  }

  void dispose() {
    _timeoutTimer?.cancel();
  }
}
