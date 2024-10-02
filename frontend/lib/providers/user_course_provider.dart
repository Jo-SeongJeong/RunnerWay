import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:frontend/models/course.dart';

class UserCourseProvider {
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response = await dioClient.dio.post('/user-course',
          data: userCourseRegistRequestDto,
          options: Options(responseType: ResponseType.plain));

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      if (response.statusCode == 200) {
        log('유저 코스 성공: $response');
      } else {
        log('유저 코스 등록 실패provider: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('유저 코스 추가 중 문제 발생 provider: ${e.message}');
      log('Response data during error: ${e.response?.data}');
      log('Response headers during error: ${e.response?.headers}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }
}
