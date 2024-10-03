import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/models/ranking_upload_model.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:frontend/utils/env.dart';

class RunningProvider {
  final dioClient = DioClient();
  var dio = Dio();

  Future<dynamic> submitRunningRecord() async {
    try {
      final reseponse = await dioClient.dio.post('record');
      if (reseponse.statusCode == 201) {
        return reseponse.data['runningRecordId'];
      } else {
        throw Exception('Failed to submit running record');
      }
    } catch (e) {
      throw Exception('Error submitting running record: $e');
    }
  }

  // 코스 경로 데이터 S3에서 가져오기
  Future<List<dynamic>> fetchRankingCoursePoints(int id) async {
    try {
      log('${Env.s3Region}');
      log('${Env.s3Name}');
      log('${id}');
      final response = await dio.get(
        'https://${Env.s3Name}.s3.${Env.s3Region}.amazonaws.com/upload/ranking/${id}.json',
      );

      log('$response');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('코스 데이터 조회 중 문제 발생');
      }
    } on DioException catch (e) {
      log('코스 경로 데이터 조회 중 오류 발생 : ${e.message}');
      throw Exception('코스 경로 데이터 조회 중 오류 발생 : ${e.message}');
    }
  }

  // 랭킹등록 가능여부 판단
  Future<dynamic> getRegistRanking(int courseId, String elapsedTime) async {
    log('코스아이디: ${courseId}');
    log('score: ${elapsedTime}');

    try {
      final response = await dioClient.dio.get('ranking/check',
          queryParameters: {'courseId': courseId, 'score': elapsedTime},
          options: Options(headers: {'Accept': ''}));
      log('response: ${response}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('랭킹 등록 확인 중 문제 발생');
      }
    } catch (e) {
      log('An unexpected error occurred: $e');
      throw Exception('Unexpected error: $e');
    }
  }

//  랭커 등록
  Future<dynamic> registRanking(RankingUploadModel model) async {
    try {
      final response = await dioClient.dio.post('ranking',
          data: model.toJson(), options: Options(headers: {'Accept': ''}));
      log('response: ${response}');
      if (response.statusCode == 201) {
        log('여기는? ${response}');
        return response.data;
      } else {
        throw Exception('랭킹 등록 확인 중 문제 발생');
      }
    } catch (e) {
      log('An unexpected error occurred: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
