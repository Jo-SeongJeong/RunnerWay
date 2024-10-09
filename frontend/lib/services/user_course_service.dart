import 'dart:developer';
import 'dart:io';
import 'package:frontend/repositories/user_course_repository.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class UserCourseService {
  final UserCourseRepository userCourseRepository = UserCourseRepository();
  final dioClient = DioClient();

  // 유저 코스 등록
  Future<String> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response =
          await userCourseRepository.addUserCourse(userCourseRegistRequestDto);
      return response;
    } catch (e) {
      log('유저 코스 추가 중 문제 발생 service: $e');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.toString()}');
    }
  }

  Future<bool> uploadJson(String courseId, String recordId) async {
    log('uploadjson 서비스');
    log('123123');
    log('${courseId}');
    log('${recordId}');

    try {
      final directory = await getApplicationDocumentsDirectory();
      final File tmpFile = File('${directory.path}/${recordId}.json');
      log('${directory.path}');
      log('${tmpFile.toString()}');
      if (await tmpFile.exists()) {
        final response =
            await userCourseRepository.uploadJson(tmpFile, courseId.toString());
        return response;
      } else {
        print('tmp.json does not exist');
        return false;
      }
    } catch (e) {
      print('Error renaming file: $e');
      throw e; // 에러를 상위로 전파하여 RunningController에서 처리할 수 있게 함
    }
  }
}
