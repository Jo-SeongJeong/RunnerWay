import 'course_image.dart';

class Course {
  final int courseId;
  final String name;
  final String address;
  final String? content;
  final int count;
  final int level;
  final double courseLength;
  final double lat;
  final double lng;
  final double? distance;
  final double? averageSlope;
  final String? averageTime;
  final double? averageCalorie;
  final String? courseType;
  final CourseImage? courseImage;
  final double? averageDownhill;
  final int? memberId;
  final String? memberNickname;
  final DateTime? registDate;
  final int? recordId;

  Course({
    required this.courseId,
    required this.name,
    required this.address,
    this.content,
    required this.level,
    required this.count,
    required this.courseLength,
    required this.lat,
    required this.lng,
    this.courseImage,
    this.distance,
    this.averageSlope,
    this.averageTime,
    this.averageCalorie,
    this.courseType,
    this.averageDownhill,
    this.memberId,
    this.memberNickname,
    this.registDate,
    this.recordId,
  });

  // JSON 데이터를 파싱하여 Course 객체 생성
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      name: json['name'],
      address: json['address'],
      content: json['content'],
      level: json['level'],
      count: json['count'],
      courseLength: (json['courseLength'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      courseImage: json['courseImage'] != null
          ? CourseImage.fromJson(json['courseImage'])
          : null,
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
      averageSlope: json['averageSlope'] != null
          ? (json['averageSlope'] as num).toDouble()
          : null,
      averageTime: json['averageTime'],
      averageCalorie: json['averageCalorie'] != null
          ? (json['averageCalorie'] as num).toDouble()
          : null,
      courseType: json['courseType'],
      averageDownhill: json['averageDownhill'] != null
          ? (json['averageDownhill'] as num).toDouble()
          : null,
      memberId: json['memberId'],
      memberNickname: json['memberNickname'],
      registDate: json['registDate'] != null
          ? DateTime.parse(json['registDate'])
          : null,
    );
  }

  // copyWith 메서드
  Course copyWith({
    int? courseId,
    String? name,
    String? address,
    String? content,
    int? count,
    int? level,
    double? courseLength,
    double? lat,
    double? lng,
    double? distance,
    double? averageSlope,
    String? averageTime,
    double? averageCalorie,
    String? courseType,
    CourseImage? courseImage,
    double? averageDownhill,
    int? memberId,
    String? memberNickname,
    DateTime? registDate,
  }) {
    return Course(
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      address: address ?? this.address,
      content: content ?? this.content,
      count: count ?? this.count,
      level: level ?? this.level,
      courseLength: courseLength ?? this.courseLength,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distance: distance ?? this.distance,
      averageSlope: averageSlope ?? this.averageSlope,
      averageTime: averageTime ?? this.averageTime,
      averageCalorie: averageCalorie ?? this.averageCalorie,
      courseType: courseType ?? this.courseType,
      courseImage: courseImage ?? this.courseImage,
      averageDownhill: averageDownhill ?? this.averageDownhill,
      memberId: memberId ?? this.memberId,
      memberNickname: memberNickname ?? this.memberNickname,
      registDate: registDate ?? this.registDate,
    );
  }

  // toJson 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'name': name,
      'address': address,
      'content': content,
      'level': level,
      'count': count,
      'courseLength': courseLength,
      'lat': lat,
      'lng': lng,
      'courseImage': courseImage?.toJson(), // courseImage가 있다면 toJson 사용
      'distance': distance,
      'averageSlope': averageSlope,
      'averageTime': averageTime,
      'averageCalorie': averageCalorie,
      'courseType': courseType,
      'averageDownhill': averageDownhill,
      'memberId': memberId,
      'memberNickname': memberNickname,
      'registDate': registDate?.toIso8601String(), // DateTime을 ISO 8601 형식으로 변환
    };
  }

  // toString 메서드 오버라이드
  @override
  String toString() {
    return 'Course(courseId: $courseId, name: $name, address: $address, '
        'content: $content, count: $count, level: $level, courseLength: $courseLength, '
        'lat: $lat, lng: $lng, distance: $distance, averageSlope: $averageSlope, '
        'averageTime: $averageTime, averageCalorie: $averageCalorie, courseType: $courseType, '
        'averageDownhill: $averageDownhill, memberId: $memberId, memberNickname: $memberNickname, '
        'registDate: $registDate)';
  }
}
