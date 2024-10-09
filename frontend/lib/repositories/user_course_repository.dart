import 'dart:developer';
import 'dart:io';
import 'package:frontend/providers/user_course_provider.dart';

class UserCourseRepository {
  final UserCourseProvider _provider = UserCourseProvider();

  // 유저 코스 등록
  Future<String> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response =
          await _provider.addUserCourse(userCourseRegistRequestDto);
      log('유저 코스 등록 성공');

      if (response['courseId'] != null) {
        return response['courseId'].toString();
      } else {
        return '';
      }
    } catch (e) {
      log('유저 코스 등록 중 오류 repo: $e');
      throw Exception('유저 코스 추가 실패');
    }
  }

  Future<bool> uploadJson(File file, String recordId) async {
    log('uploadjson 프로바이더');
    try {
      final response = await _provider.uploadJson(file, recordId);
      log('${response}');
      return response;
    } catch (e) {
      log('유정 코스 등록 중 오류 repo: $e');
      throw Exception('유저 코스 추가 실패');
    }
  }
}
