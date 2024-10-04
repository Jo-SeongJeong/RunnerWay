class RunningRecord {
  final double latitude;
  final double longitude;
  final Duration elapsedTime;

  RunningRecord({
    required this.latitude,
    required this.longitude,
    required this.elapsedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'elapsedTime': elapsedTime.inSeconds, // 초 단위로 저장
    };
  }

  factory RunningRecord.fromJson(Map<String, dynamic> json) {
    return RunningRecord(
      latitude: json['latitude'],
      longitude: json['longitude'],
      elapsedTime: json['elapsedTime'] is int
          ? Duration(seconds: json['elapsedTime'])
          : Duration(seconds: 0), // elapsedTime이 없는 경우 0으로 처리
    );
  }

  // timestamp를 elapsedTime으로 변환하는 팩토리 생성자
  factory RunningRecord.fromTimestamp({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    required DateTime startTime,
  }) {
    return RunningRecord(
      latitude: latitude,
      longitude: longitude,
      elapsedTime: timestamp.difference(startTime),
    );
  }

  @override
  String toString() {
    return 'RunningRecord(latitude: $latitude, longitude: $longitude, elapsedTime: ${elapsedTime.inSeconds} seconds)';
  }
}
