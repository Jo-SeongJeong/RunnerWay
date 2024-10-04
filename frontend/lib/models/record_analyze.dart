class RecordAnalyze {
  final double totalDistance;
  final double averageFace;
  final String totalScore;
  final double totalCalorie;

  RecordAnalyze({
    required this.totalDistance,
    required this.averageFace,
    required this.totalScore,
    required this.totalCalorie,
  });

  // JSON 데이터를 받아서 RecordAnalyze 객체를 생성하는 팩토리 메서드
  factory RecordAnalyze.fromJson(Map<String, dynamic> json) {
    return RecordAnalyze(
      totalDistance: (json['totalDistance'] as num).toDouble(),
      averageFace: (json['averageFace'] as num).toDouble(),
      totalScore: json['totalScore'],
      totalCalorie: (json['totalCalorie'] as num).toDouble(),
    );
  }

  // RecordAnalyze 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'totalDistance': totalDistance,
      'averageFace': averageFace,
      'totalScore': totalScore,
      'totalCalorie': totalCalorie,
    };
  }

  // copyWith 메서드 추가
  RecordAnalyze copyWith({
    double? totalDistance,
    double? averageFace,
    String? totalScore,
    double? totalCalorie,
  }) {
    return RecordAnalyze(
      totalDistance: totalDistance ?? this.totalDistance,
      averageFace: averageFace ?? this.averageFace,
      totalScore: totalScore ?? this.totalScore,
      totalCalorie: totalCalorie ?? this.totalCalorie,
    );
  }
}
