class LivenessConfig {
  final double blinkThreshold;
  final double smileThreshold;
  final double headTurnThreshold;
  final Duration timeout;
  final bool enableAntiSpoofing;

  const LivenessConfig({
    this.blinkThreshold = 0.2,
    this.smileThreshold = 0.7,
    this.headTurnThreshold = 20.0,
    this.timeout = const Duration(seconds: 30),
    this.enableAntiSpoofing = true,
  });
}
