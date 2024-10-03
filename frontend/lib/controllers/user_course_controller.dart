import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/record_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/services/user_course_service.dart';
import 'dart:developer';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserCourseController extends GetxController {
  final UserCourseService _userCourseService = UserCourseService();
  final AuthController _authController = Get.find<AuthController>();
  final RecordController recordController = Get.put(RecordController());
  final _storage = FlutterSecureStorage();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isButtonActive = false.obs;

  // 유저 코스 등록
  Future<void> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    isLoading(true);
    try {
      // 토큰 storage에서 가져오기
      String? token = await _storage.read(key: 'ACCESS_TOKEN');
      if (token == null) {
        throw Exception('토큰이 없어요');
      }

      // 디코드해서 memberId 추출
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String memberId = decodedToken['id'].toString();
      log('Decoded memberId: $memberId');

      // 유효한 recordId 가져오기
      final recordId = recordController.recordDetail.value?.recordId ?? 0;
      if (recordId == 0) {
        throw Exception('유효한 recordId가 필요합니다.');
      }

      // 데이터가 제대로 들어가 있는지 확인
      log('usercousrse컨트롤러 data: $userCourseRegistRequestDto');

      // 임의의 Course 데이터 생성
      // var userCourseRegistRequestDto = {
      //   "recordId": 94,
      //   "name": "싸피코스",
      //   "address": "유성구",
      //   "content": "좋아용",
      //   "memberId": 1,
      //   "averageTime": "2024-10-01T00:50:00",
      //   "courseLength": 5.5,
      //   "courseType": "user",
      //   "averageCalorie": 200.2,
      //   "lat": 36.35498566873416,
      //   "lng": 127.3008971772697,
      //   "url":
      //       "https://runnerway.s3.ap-northeast-2.amazonaws.com/test/test2.json",
      //   "courseImage": {"url": "test.url", "path": "test.path"}
      // };

      // userCourseRegistRequestDto에 memberId 추가
      userCourseRegistRequestDto['recordId'] = recordId;

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
