class PredictionResult {
  final String code;
  final String description;
  final double score;
  final double frequency;

  PredictionResult({
    required this.code,
    required this.description,
    required this.score,
    required this.frequency,
  });

  @override
  String toString() {
    return 'PredictionResult{code: $code, score: ${score.toStringAsFixed(4)}, frequency: ${frequency.toStringAsFixed(4)}}';
  }
}