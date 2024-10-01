import 'dart:developer';
import 'package:frontend/repositories/user_course_repository.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:dio/dio.dart';

class UserCourseService {
  final UserCourseRepository _repository = UserCourseRepository();
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto, String token) async {
    try {
      final response = await dioClient.dio.post(
        '/user-course',
        data: userCourseRegistRequestDto,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // 헤더에 토큰을 포함
          },
        ),
      );

      if (response.statusCode == 200) {
        log('유저 코스 추가 응답: $response');
      } else {
        log('유저 코스 등록 실패: $response');
      }
    } catch (e) {
      log('유저 코스 추가 중 문제 발생: ${e}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e}');
    }
  }
}
