import '../enums/liveness_action.dart';
import '../enums/failure_reason.dart';

/// Represents the result of a face liveness check.
class LivenessResult {
  /// Whether the liveness check was successful.
  final bool isLive;

  /// The confidence score of the liveness detection.
  final double confidence;

  /// The list of actions that were successfully completed by the user.
  final List<LivenessAction> completedActions;

  /// The reason for failure, if [isLive] is false.
  final FailureReason? failureReason;

  /// The file path to the captured face image, if successful.
  final String? faceImagePath;

  /// Creates a [LivenessResult].
  LivenessResult({
    required this.isLive,
    this.confidence = 0.0,
    this.completedActions = const [],
    this.failureReason,
    this.faceImagePath,
  });

  /// Factory for a successful liveness result.
  factory LivenessResult.success({
    required double confidence,
    required List<LivenessAction> completedActions,
    String? faceImagePath,
  }) {
    return LivenessResult(
      isLive: true,
      confidence: confidence,
      completedActions: completedActions,
      faceImagePath: faceImagePath,
    );
  }

  /// Factory for a failed liveness result.
  factory LivenessResult.failure({
    required FailureReason reason,
    List<LivenessAction> completedActions = const [],
  }) {
    return LivenessResult(
      isLive: false,
      failureReason: reason,
      completedActions: completedActions,
    );
  }
}
