import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';

class UserCourseProvider {
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response = await dioClient.dio.post('/user-course',
          data: userCourseRegistRequestDto,
          options: Options(responseType: ResponseType.plain));
      if (response.statusCode == 200) {
        log('유저 코스 성공: $response');
      } else {
        log('유저 코스 등록 실패 provider: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('유저 코스 추가 중 문제 발생 provider: ${e.message}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }
}
