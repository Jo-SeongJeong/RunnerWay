class Record {
  final int? recordId;
  final int courseId;
  final String courseName;
  final String? comment;
  final double runningDistance;
  final String score;
  final double averageFace;
  final String? startDate;
  final String? finishDate; // 추가된 finishDate
  final double? calorie;
  final String? url;
  final String? address;
  final double? lat; // 추가된 lat
  final double? lng; // 추가된 lng

  Record({
    this.recordId,
    required this.courseId,
    required this.courseName,
    this.comment,
    required this.runningDistance,
    required this.score,
    required this.averageFace,
    this.startDate,
    this.finishDate, // 추가
    this.calorie,
    this.url,
    this.address,
    this.lat, // 추가
    this.lng, // 추가
  });

  // JSON 데이터를 기반으로 Record 객체 생성
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      recordId: json['recordId'] as int?,
      courseId: json['courseId'] as int,
      courseName: json['courseName'] as String,
      comment: json['comment'] as String?,
      runningDistance: json['runningDistance'] != null
          ? (json['runningDistance'] as num).toDouble()
          : 0.0,
      score: json['score'] as String,
      averageFace: (json['averageFace'] as num).toDouble(),
      startDate: json['startDate'] as String?,
      finishDate: json['finishDate'] as String?, // 추가
      calorie:
          json['calorie'] != null ? (json['calorie'] as num).toDouble() : null,
      url: json['url'] as String?,
      address: json['address'] as String?,
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null, // 추가
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null, // 추가
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
      'finishDate': finishDate, // 추가
      'calorie': calorie,
      'url': url,
      'address': address,
      'lat': lat, // 추가
      'lng': lng, // 추가
    };
  }

  // copyWith 메서드
  Record copyWith({
    int? recordId,
    int? courseId,
    String? courseName,
    String? comment,
    double? runningDistance,
    String? score,
    double? averageFace,
    String? startDate,
    String? finishDate, // 추가
    double? calorie,
    String? url,
    String? address,
    double? lat, // 추가
    double? lng, // 추가
  }) {
    return Record(
      recordId: recordId ?? this.recordId,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      comment: comment ?? this.comment,
      runningDistance: runningDistance ?? this.runningDistance,
      score: score ?? this.score,
      averageFace: averageFace ?? this.averageFace,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate, // 추가
      calorie: calorie ?? this.calorie,
      url: url ?? this.url,
      address: address ?? this.address,
      lat: lat ?? this.lat, // 추가
      lng: lng ?? this.lng, // 추가
    );
  }

  @override
  String toString() {
    return 'Record(recordId: $recordId, courseId: $courseId, courseName: $courseName, runningDistance: $runningDistance, score: $score, averageFace: $averageFace, startDate: $startDate, finishDate: $finishDate, calorie: $calorie, url: $url, address: $address, lat: $lat, lng: $lng)';
  }
}
