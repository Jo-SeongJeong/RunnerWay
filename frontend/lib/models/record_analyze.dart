class RecordAnalyze {
  final double totalDistance;
  final double averagePace;
  final String totalScore;
  final int totalCalorie;

  RecordAnalyze({
    required this.totalDistance,
    required this.averagePace,
    required this.totalScore,
    required this.totalCalorie,
  });

  // JSON 데이터를 받아서 RecordAnalyze 객체를 생성하는 팩토리 메서드
  factory RecordAnalyze.fromJson(Map<String, dynamic> json) {
    return RecordAnalyze(
      totalDistance: (json['totalDistance'] as num).toDouble(),
      averagePace: (json['averagePace'] as num).toDouble(),
      totalScore: json['totalScore'],
      totalCalorie: json['totalCalorie'],
    );
  }

  // RecordAnalyze 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'totalDistance': totalDistance,
      'averagePace': averagePace,
      'totalScore': totalScore,
      'totalCalorie': totalCalorie,
    };
  }
}
