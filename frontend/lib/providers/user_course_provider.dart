import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:frontend/models/course.dart';

class UserCourseProvider {
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(Course course) async {
    try {
      final response = await dioClient.dio.post(
        '/user-course',
        data: course.toJson(),
      );
      if (response.statusCode == 200) {
        log('유저 코스 추가 응답: $response');
      } else {
        log('유저 코스 등록 실패provider: $response');
      }
    } on DioException catch (e) {
      log('유저 코스 추가 중 문제 발생: ${e.message}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }
}
