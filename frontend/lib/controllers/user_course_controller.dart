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
      userCourseRegistRequestDto['recordId'] = recordId;
      userCourseRegistRequestDto['memberId'] = memberId;
      log('usercousrse컨트롤러 data: $userCourseRegistRequestDto');

      // 유저 코스 등록 메서드 호출
      await _userCourseService.addUserCourse(userCourseRegistRequestDto);
      Get.snackbar('성공', '유저 코스 추가가 완료되었습니다.');
    } catch (e) {
      errorMessage('유저 코스 추가 중 오류 발생 controller: $e');
      log(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}
