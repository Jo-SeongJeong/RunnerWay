class Record {
  final int? recordId;
  final int courseId;
  final String courseName;
  final String? comment;
  final double runningDistance;
  final String score;
  final double averageFace;
  final String? startDate;
  final double? calorie;
  final String? url;

  Record({
    this.recordId,
    required this.courseId,
    required this.courseName,
    this.comment,
    required this.runningDistance,
    required this.score,
    required this.averageFace,
    this.startDate,
    this.calorie,
    this.url,
  });

  // JSON 데이터를 기반으로 Record 객체 생성
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      recordId: json['recordId'] != null ? json['recordId'] : null,
      courseId: json['courseId'] != null ? json['courseId'] : null,
      courseName: json['courseName'],
      comment: json['comment'] as String?,
      runningDistance: json['runningDistance'] != null
          ? (json['runningDistance'] as num).toDouble()
          : 0.0,
      score: json['score'],
      averageFace: (json['averageFace'] as num).toDouble(),
      startDate: json['startDate'] as String?,
      calorie: json['calorie'] != null
          ? (json['calorie'] as num).toDouble()
          : null, // null을 안전하게 처리
      url: json['url'] as String?,
    );
  }

  // Record 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'courseId': courseId,
      'courseName': courseName,
      'comment': comment,
      'runningDistance': runningDistance,
      'score': score,
      'averageFace': averageFace,
      'startDate': startDate,
      'calorie': calorie,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'Record(recordId: $recordId, courseId: $courseId, courseName: $courseName, runningDistance: $runningDistance, score: $score, averageFace: $averageFace, startDate: $startDate, calorie: $calorie, url: $url)';
  }
}
