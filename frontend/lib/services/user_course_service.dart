import 'dart:developer';
import 'package:frontend/repositories/user_course_repository.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:dio/dio.dart';

class UserCourseService {
  final UserCourseRepository _repository = UserCourseRepository();
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response = await dioClient.dio.post('/user-course',
          data: userCourseRegistRequestDto,
          options: Options(responseType: ResponseType.plain));

      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        log('유저 코스 추가 성공: ${response.data}');
      } else {
        log('유저 코스 등록 실패 service: Status Code: ${response.statusCode}, Data: ${response.data}');
      }
    } on DioException catch (e, stacktrace) {
      log('유저 코스 추가 중 문제 발생 service: ${e.toString()}');
      log('Stacktrace: $stacktrace'); // 스택 트레이스 추가 로깅

      // log('Response during error: ${e.response?.data} ${e.response?.headers}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }
}
