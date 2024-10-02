class Record {
  final int recordId;
  final int courseId;
  final String courseName;
  final double runningDistance;
  final String score;
  final double averageFace;

  Record({
    required this.recordId,
    required this.courseId,
    required this.courseName,
    required this.runningDistance,
    required this.score,
    required this.averageFace,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      recordId: json['recordId'],
      courseId: json['courseId'],
      courseName: json['courseName'],
      runningDistance: (json['runningDistance'] as num).toDouble(), // 숫자 변환
      score: json['score'],
      averageFace: (json['averageFace'] as num).toDouble(), // 숫자 변환
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
