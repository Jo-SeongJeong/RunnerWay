class CourseImage {
  final int courseId;
  final String url;
  final String path;

  CourseImage({
    required this.courseId,
    required this.url,
    required this.path,
  });

  // JSON 데이터를 파싱하여 CourseImage 객체 생성
  factory CourseImage.fromJson(Map<String, dynamic> json) {
    return CourseImage(
      courseId: json['courseId'],
      url: json['url'],
      path: json['path'],
    );
  }

  // toJson 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'url': url,
      'path': path,
    };
  }
}
