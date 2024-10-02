import 'dart:developer';
import 'package:frontend/repositories/user_course_repository.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:dio/dio.dart';

class UserCourseService {
  final UserCourseRepository _repository = UserCourseRepository();
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<dynamic> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response = await dioClient.dio.post(
        '/user-course',
        data: userCourseRegistRequestDto,
        // options: Options(responseType: ResponseType.plain),
      );

      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        log('유저 코스 추가 성공: ${response.data}');
      } else if (response.statusCode == 409) {
        log('중복 등록 감지: ${response.data}');
        throw Exception('중복 등록 오류: 코스가 이미 등록되어 있습니다.');
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

  // // 유저 코스 등록 중복 체크
  // Future<bool> checkAndAddUserCourse(
  //     Map<String, Object> userCourseRegistRequestDto) async {
  //   try {
  //     final response = await dioClient.dio.post('/user-course',
  //         data: userCourseRegistRequestDto,
  //         options: Options(responseType: ResponseType.plain));
  //
  //     if (response.statusCode == 409) {
  //       log('중복 등록 에러 발생: ${response.statusCode}');
  //       return false;
  //     }
  //     log('유저 코스 등록 성공 혹은 기타 응답: ${response.statusCode}');
  //     return true;
  //   } on DioException catch (e) {
  //     log('유저 코스 등록 중 예외 발생 service: ${e.toString()}');
  //     throw Exception('유저 코스 등록 중 예외 발생: ${e.message}');
  //   }
  // }
}
