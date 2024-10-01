import 'dart:developer';
import 'package:frontend/models/course.dart';
import 'package:frontend/repositories/user_course_repository.dart';

class UserCourseService {
  final UserCourseRepository _repository = UserCourseRepository();

  // 유저 코스 등록
  Future<void> addUserCourse(Course course) async {
    try {
      await _repository.addUserCourse(course);
      log('유저 코스 추가 성공');
    } catch (e) {
      log('유저 코스 추가 중 오류 발생 service: $e');
      throw Exception('유저 코스 추가 실패');
    }
  }
}
