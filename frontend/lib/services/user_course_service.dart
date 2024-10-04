import 'dart:developer';
import 'package:frontend/repositories/user_course_repository.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:dio/dio.dart';

class UserCourseService {
  final UserCourseRepository userCourseRepository = UserCourseRepository();
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response =
          await userCourseRepository.addUserCourse(userCourseRegistRequestDto);
      return response;
    } catch (e) {
      log('유저 코스 추가 중 문제 발생 service: $e');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.toString()}');
    }
  }
}
