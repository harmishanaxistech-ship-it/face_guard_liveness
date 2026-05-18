/// Different actions a user can be asked to perform during liveness detection.
enum LivenessAction {
  /// User should blink their eyes.
  blink,

  /// User should smile.
  smile,

  /// User should turn their head to the left.
  turnLeft,

  /// User should turn their head to the right.
  turnRight,

  /// User should look up.
  lookUp,

  /// User should look down.
  lookDown,
}
