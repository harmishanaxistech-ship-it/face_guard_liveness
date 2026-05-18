import 'package:flutter/material.dart';
import 'src/enums/liveness_action.dart';
import 'src/models/liveness_result.dart';
import 'src/widgets/liveness_camera_view.dart';

export 'src/core/flutter_face_liveness.dart';
export 'src/core/face_verifier.dart';
export 'src/enums/liveness_action.dart';
export 'src/enums/failure_reason.dart';
export 'src/models/liveness_result.dart';
export 'src/models/face_verification_result.dart';
export 'src/widgets/liveness_camera_view.dart';

/// The main entry point for the Face Guard Liveness SDK.
class FaceGuardLiveness {
  /// Internal constructor.
  const FaceGuardLiveness._();

  /// Initializes the SDK and necessary services.
  static Future<void> initialize() async {
    // Global initialization if needed
  }

  /// Starts the liveness check process.
  ///
  /// Displays a camera view and guides the user through a series of [actions].
  /// Returns a [LivenessResult] when completed or `null` if the user cancels.
  static Future<LivenessResult?> startLivenessCheck(
    BuildContext context, {
    List<LivenessAction> actions = const [
      LivenessAction.blink,
      LivenessAction.smile,
    ],
  }) async {
    return await Navigator.of(context).push<LivenessResult>(
      MaterialPageRoute(
        builder: (context) => LivenessCameraView(
          actions: actions,
          onCompleted: (result) {
            Navigator.of(context).pop(result);
          },
        ),
      ),
    );
  }
}
