import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:get/get.dart';

class UserCourseProvider {
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response = await dioClient.dio.post(
        '/user-course',
        data: userCourseRegistRequestDto,
      );

      // 상태 코드만을 기준으로 처리
      log('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // 200일 때: 성공 처리
        log('유저 코스 성공');
        Get.snackbar('성공', '유저 코스 추가가 완료되었습니다.');
      } else if (response.statusCode == 209) {
        // 209일 때: 특정 처리
        log('209 상태 처리: ${response.statusCode}');
      } else if (response.statusCode == 401) {
        // 401일 때: 인증 오류 처리
        log('401 인증 오류');
        Get.snackbar('오류', '인증 오류가 발생했습니다.');
      } else {
        // 기타 상태 코드 처리
        log('유저 코스 등록 실패: ${response.statusCode}');
        Get.snackbar('오류', '유저 코스 추가 중 오류 발생.');
      }
    } on DioException catch (e) {
      log('유저 코스 추가 중 문제 발생: ${e.message}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }
}
