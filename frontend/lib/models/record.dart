class Record {
  final int recordId;
  final int courseId;
  final String courseName;
  // final String? comment;
  final double runningDistance;
  final String score;
  final double averageFace;
  // final double calorie;
  // final String? url;

  Record({
    required this.recordId,
    required this.courseId,
    required this.courseName,
    // this.comment,
    required this.runningDistance,
    required this.score,
    required this.averageFace,
    // required this.calorie,
    // this.url,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      recordId: json['recordId'] ?? 0,
      courseId: json['courseId'] ?? 0,
      courseName: json['courseName'] ?? '자유코스',
      // comment: json['comment'],

      runningDistance:
          (json['runningDistance'] as num).toDouble() ?? 0.0, // 숫자 변환
      score: json['score'] ?? '00:00:00',
      averageFace:
          (json['averageFace'] as num?)?.toDouble() ?? 0.0, // null 처리 및 기본값
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'courseId': courseId,
      'courseName': courseName,
      'runningDistance': runningDistance,
      'score': score,
      'averageFace': averageFace,
    };
  }
}
