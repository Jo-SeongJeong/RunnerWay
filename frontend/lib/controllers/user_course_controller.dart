import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/services/user_course_service.dart';
import 'dart:developer';

class UserCourseController extends GetxController {
  final UserCourseService _userCourseService = UserCourseService();
  final AuthController _authController = Get.find<AuthController>();
  final _storage = FlutterSecureStorage(); // 토큰 저장

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // // 유저 코스 등록
  // Future<void> addUserCourse(Course course) async {
  //   isLoading(true);
  //   try {
  //     await _userCourseService.addUserCourse(course);
  //     log('유저코스추가 성공controller: ${course.name}');
  //     Get.snackbar('성공', '유저 코스 추가가 완료되었습니다.');
  //   } catch (e) {
  //     errorMessage('유저 코스 추가 중 오류 발생 controller: $e');
  //     log(errorMessage.value);
  //     Get.snackbar('오류', errorMessage.value);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    isLoading(true);
    try {
      // String? token = await _storage.read(key: 'ACCESS_TOKEN');
      //
      // if (token == null || token.isEmpty) {
      //   log('토큰이 없습니다. 인증이 필요합니다.');
      //   throw Exception('토큰이 없습니다.');
      // }
      // 임의의 Course 데이터 생성
      var userCourseRegistRequestDto = {
        "recordId": 87,
        "name": "싸피코스",
        "address": "유성구",
        "content": "좋아용",
        "memberId": 1,
        "averageTime": "2024-10-01T00:50:00",
        "courseLength": 5.5,
        "courseType": "user",
        "averageCalorie": 200.2,
        "lat": 36.35498566873416,
        "lng": 127.3008971772697,
        "url":
            "https://runnerway.s3.ap-northeast-2.amazonaws.com/test/test2.json",
        "courseImage": {"url": "test.url", "path": "test.path"}
      };

      // 유저 코스 등록 메서드 호출
      await _userCourseService.addUserCourse(userCourseRegistRequestDto);

      log('유저코스추가 성공 controller: ${userCourseRegistRequestDto["name"]}');
      Get.snackbar('성공', '유저 코스 추가가 완료되었습니다.');
    } catch (e) {
      errorMessage('유저 코스 추가 중 오류 발생 controller: $e');
      log(errorMessage.value);
      Get.snackbar('오류', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}
