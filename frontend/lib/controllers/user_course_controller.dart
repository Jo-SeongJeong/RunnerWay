import 'package:get/get.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/services/user_course_service.dart';
import 'dart:developer';

import '../models/course_image.dart';

class UserCourseController extends GetxController {
  final UserCourseService _userCourseService = UserCourseService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 유저 코스 등록
  Future<void> addUserCourse(Course course) async {
    isLoading(true);
    try {
      await _userCourseService.addUserCourse(course);
      log('유저코스추가 성공controller: ${course.name}');
      Get.snackbar('성공', '유저 코스 추가가 완료되었습니다.');
    } catch (e) {
      errorMessage('유저 코스 추가 중 오류 발생 controller: $e');
      log(errorMessage.value);
      Get.snackbar('오류', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTestUserCourse() async {
    isLoading(true);
    try {
      Course course = Course(
        courseId: 7, // 예시 데이터
        count: 0,
        level: 0,
        name: '싸피코스',
        address: '유성구',
        content: '좋아용',
        memberId: 1, // 필수값이 아니므로 null로 설정
        averageTime: '2024-10-01T00:50:00',
        courseLength: 5.5,
        courseType: 'user',
        averageCalorie: 200.2,
        lat: 36.35498566873416,
        lng: 127.3008971772697,
        // url:
        //     'https://runnerway.s3.ap-northeast-2.amazonaws.com/test/test2.json', // 선택적 필드
        courseImage: CourseImage(
          courseId: 0,
          url: 'test.url',
          path: 'test.path',
        ), // 코스 이미지 데이터
      );

      // 유저 코스 등록 메서드 호출
      await _userCourseService.addUserCourse(course);

      log('유저코스추가 성공 controller: ${course.name}');
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
