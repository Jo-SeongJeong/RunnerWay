import 'dart:developer';
import 'package:frontend/providers/user_course_provider.dart';

class UserCourseRepository {
  final UserCourseProvider _provider = UserCourseProvider();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      await _provider.addUserCourse(userCourseRegistRequestDto);
      log('유저 코스 등록 성공');
    } catch (e) {
      log('유정 코스 등록 중 오류 repo: $e');
      throw Exception('유저 코스 추가 실패');
    }
  }
}
