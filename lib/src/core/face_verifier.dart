import 'dart:math';
import '../models/face_verification_result.dart';

/// Utility class for verifying face identity using embeddings.
class FaceVerifier {
  /// Compares two embeddings and returns a similarity score (Cosine Similarity).
  static double compare(List<double> embedding1, List<double> embedding2) {
    return _cosineSimilarity(embedding1, embedding2);
  }

  static double _cosineSimilarity(List<double> v1, List<double> v2) {
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < v1.length; i++) {
      dotProduct += v1[i] * v2[i];
      normA += pow(v1[i], 2);
      normB += pow(v2[i], 2);
    }
    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  static double _euclideanDistance(List<double> v1, List<double> v2) {
    double sum = 0.0;
    for (int i = 0; i < v1.length; i++) {
      sum += pow(v1[i] - v2[i], 2);
    }
    return sqrt(sum);
  }

  /// Verifies if two embeddings belong to the same person based on a [threshold].
  static FaceVerificationResult verify(List<double> embedding1, List<double> embedding2, {double threshold = 0.8}) {
    final similarity = _cosineSimilarity(embedding1, embedding2);
    final distance = _euclideanDistance(embedding1, embedding2);
    
    return FaceVerificationResult(
      matched: similarity >= threshold,
      similarity: similarity,
      embeddingDistance: distance,
    );
  }
}
