import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/services/user_course_service.dart';
import 'dart:developer';

class UserCourseController extends GetxController {
  final UserCourseService _userCourseService = UserCourseService();
  final AuthController _authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    isLoading(true);
    try {
      // 임의의 Course 데이터 생성
      var userCourseRegistRequestDto = {
        "recordId": 94,
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
