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

  // 월별 러닝 기록 조회
  Future<List<dynamic>> fetchRecords(int year, int month) async {
    try {
      final response = await dioClient.dio
          .get('/record', queryParameters: {'year': year, 'month': month});
      if (response.statusCode == 200) {
        log('월별 기록 조회 Response data: ${response.data}');
        return response.data;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception('러닝 기록 목록 조회 중 문제 발생');
      }
    } on DioException catch (e) {
      log('러닝 기록 조회 provider 오류 발생 : ${e.message}');
      throw Exception('러닝 기록 조회 provider 오류 발생 : ${e.message}');
    }
  }

  // 러닝 기록 상세 조회
  Future<dynamic> fetchRecordDetail(int recordId) async {
    log('러닝 기록 상세 pro: $recordId');
    try {
      final response = await dioClient.dio.get('/record/detail/$recordId');
      if (response.statusCode == 200 && response.data != null) {
        log('response.data provider: ${response.data}');
        return response.data;
      } else {
        throw Exception('러닝 기록 상세 조회 중 문제 provider : 데이터가 없당');
      }
    } on DioException catch (e) {
      throw Exception('러닝 기록 상세 조회 실패: provider: ${e.toString()}');
    }
  }

  // 러닝 기록 수정
  Future<dynamic> patchRecord(Map<String, dynamic> updateData) async {
    try {
      final response =
          await dioClient.dio.patch('/record/comment', data: updateData);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('러닝 기록 수정문제 pro: 데이터 없어');
      }
    } on DioException catch (e) {
      throw Exception('러닝 수정 실패: pro: ${e.toString()}');
    }
  }
// 러닝 사진 수정
}
