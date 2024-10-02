import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';

class RecordProvider {
  final dioClient = DioClient();

// 러닝 기록 목록 조회
  Future<List<dynamic>> fetchRecordCourse(int year, int month, int day) async {
    try {
      final response = await dioClient.dio.get('/record',
          queryParameters: {'year': year, 'month': month, 'day': day});
      if (response.statusCode == 200) {
        log('Response data: ${response.data}');
        return response.data;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception('러닝 기록 목록 조회 중 문제 발생');
      }
    } on DioException catch (e) {
      log('러닝 기록 목록 조회 provider: ${e.message}');
      throw Exception('러닝 기록 목록 조회 : ${e.message}');
    }
  }

  // 월별 러닝 기록 분석 조회
  Future<Map<String, dynamic>> fetchMonthAnalyze(int year, int month) async {
    try {
      final response = await dioClient.dio.get('/record/analyze',
          queryParameters: {'year': year, 'month': month});

      if (response.statusCode == 200) {
        log('Response data: ${response.data}');
        return response.data;
      } else {
        throw Exception('러닝 기록 분석 조회 중 문제 발생');
      }
    } on DioException catch (e) {
      log('러닝 기록 분석 조회 provider 오류 발생 : ${e.message}');
      throw Exception('러닝 기록 분석 조회 provider 오류 발생 : ${e.message}');
    }
  }
}
