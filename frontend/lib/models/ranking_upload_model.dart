class RankingUploadModel {
  final int courseId;
  final String score;
  final String logPath;

  RankingUploadModel({
    required this.courseId,
    required this.score,
    required this.logPath,
  });

  factory RankingUploadModel.fromJson(Map<String, dynamic> json) {
    return RankingUploadModel(
      courseId: json['courseId'],
      score: json['score'],
      logPath: json['logPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'score': score,
      'logPath': logPath,
    };
  }
}
