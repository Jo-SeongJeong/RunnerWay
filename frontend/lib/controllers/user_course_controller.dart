import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/services/user_course_service.dart';
import 'dart:developer';
import '../models/course_image.dart';

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
      String? token = await _storage.read(key: 'ACCESS_TOKEN');

      if (token == null || token.isEmpty) {
        log('토큰이 없습니다. 인증이 필요합니다.');
        throw Exception('토큰이 없습니다.');
      }
      // 임의의 Course 데이터 생성
      var userCourseRegistRequestDto = {
        "name": "테스트 코스",
        "address": "서울",
        "content": "테스트 코스 설명입니다.",
        "memberId": _authController.id.value, // AuthController에서 사용자 ID 가져오기
        "level": 1,
        "averageSlope": 10,
        "averageDownhill": 5,
        "averageTime": "2024-10-01T07:30:00", // LocalDateTime 형식으로 수정
        "courseLength": 5.5,
        "courseType": "OFFICIAL", // Enum 타입 (백엔드와 맞추기)
        "averageCalorie": 500.5,
        "lat": 37.5665,
        "lng": 126.9780,
        "area": "서울",
        "courseImage": {
          "url": "https://example.com/course.png" // 이미지 URL
        },
        "recordId": 1001
      };

      // 유저 코스 등록 메서드 호출
      await _userCourseService.addUserCourse(userCourseRegistRequestDto, token);

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
