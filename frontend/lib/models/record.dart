class Record {
  final int recordId;
  final int courseId;
  final String courseName;
  final double runningDistance;
  final String score;
  final double averageFace;
  final String? startDate;

  Record({
    required this.recordId,
    required this.courseId,
    required this.courseName,
    required this.runningDistance,
    required this.score,
    required this.averageFace,
    this.startDate,
  });

  // JSON 데이터를 기반으로 Record 객체 생성
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      recordId: json['recordId'],
      courseId: json['courseId'],
      courseName: json['courseName'],
      runningDistance: (json['runningDistance'] as num).toDouble(),
      score: json['score'],
      averageFace: (json['averageFace'] as num).toDouble(),
      startDate: json['startDate'],
    );
  }

  // Record 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'courseId': courseId,
      'courseName': courseName,
      'runningDistance': runningDistance,
      'score': score,
      'averageFace': averageFace,
      'startDate': startDate,
    };
  }
}
