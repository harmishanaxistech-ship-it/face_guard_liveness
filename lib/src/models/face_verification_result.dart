/// Represents the result of a face verification comparison.
class FaceVerificationResult {
  /// Whether the two faces are considered a match based on the threshold.
  final bool matched;

  /// The similarity score between the two faces, typically between 0 and 1.
  final double similarity;

  /// The distance between the face embeddings. Smaller values mean more similar faces.
  final double embeddingDistance;

  /// Creates a [FaceVerificationResult].
  FaceVerificationResult({
    required this.matched,
    required this.similarity,
    required this.embeddingDistance,
  });
}
