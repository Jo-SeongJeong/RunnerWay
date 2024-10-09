import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:frontend/utils/env.dart';

class UserCourseProvider {
  final dioClient = DioClient();
  final dio = Dio();

  // 유저 코스 등록
  Future<dynamic> addUserCourse(
      Map<String, Object> userCourseRegistRequestDto) async {
    try {
      final response = await dioClient.dio.post('/user-course',
          data: userCourseRegistRequestDto,
          options: Options(responseType: ResponseType.plain));
      if (response.statusCode == 200) {
        log('유저 코스 성공: $response');
        return jsonDecode(response.data);
      } else {
        log('유저 코스 등록 실패 provider: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('유저 코스 추가 중 문제 발생 provider: ${e.message}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }

  Future<bool> uploadJson(File file, String recordId) async {
    log('${recordId}');
    try {
      int fileLength = await file.length();
      log('${fileLength}');
      log('${Env.s3Region}');
      log('${Env.s3Name}');

      final response = await dio.put(
        'https://${Env.s3Name}.s3.${Env.s3Region}.amazonaws.com/upload/course/${recordId}.json',
        data: file.openRead(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Content-Length': fileLength
        }),
      );

      if (response.statusCode == 200) {
        log('유저 코스 s3 등록 성공: $response');
        return true;
      } else {
        log('유저 코스 s3 등록 실패 provider: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      log('유저 코스 추가 중 문제 발생 provider: ${e.message}');
      throw Exception('유저 코스 추가 중 문제 발생: ${e.message}');
    }
  }
}
