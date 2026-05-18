/// Reasons why a liveness check might fail.
enum FailureReason {
  /// No face was detected in the frame.
  noFaceDetected,

  /// More than one face was detected in the frame.
  multipleFacesDetected,

  /// A spoofing attempt was detected.
  spoofDetected,

  /// The detection confidence was too low.
  lowConfidence,

  /// The user did not complete the actions within the allotted time.
  timeout,

  /// The user manually cancelled the process.
  userCancelled,

  /// An error occurred with the camera.
  cameraError,
}
