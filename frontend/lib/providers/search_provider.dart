import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';

class SearchProvider {
  var dio = Dio();
  final dioClient = DioClient();

  // 검색어 자동완성 리스트 요청
  Future<List<dynamic>> fetchWords(
    String query,
  ) async {
    try {
      final response = await dioClient.dio.get(
        '/search/candidate',
        queryParameters: {
          'searchWord': query,
        },
      );

      // 응답 성공 시 데이터 반환
      if (response.statusCode == 200) {
        log('$response');
        return response.data;
      } else {
        throw Exception('Failed to load courses');
      }
    } on DioException catch (e) {
      // 에러 처리
      print('검색어 자동완성 리스트를 가져오는 중 문제 발생 : ${e.message}');
      throw Exception('검색어 자동완성 리스트 가져오기 실패: ${e.message}');
    }
  }

  // 코스 검색 결과 요청
  Future<Map<String, dynamic>> fetchSearchResults(
    String query,
    int page,
  ) async {
    try {
      // dioClient 요청
      final response = await dioClient.dio.get(
        '/search',
        queryParameters: {
          'searchWord': query,
          'page': page - 1,
        },
      );

      // 요청 성공 시 데이터 반환
      if (response.statusCode == 200) {
        log('검색 결과 provider : ${response}');
        return {
          'courses': response.data['searchCourseList'],
          'totalPages': response.data['totalPages'],
          'totalElements': response.data['totalElements'],
        };
      } else if (response.statusCode == 204) {
        return {};
      } else {
        throw Exception('검색 결과 조회 실패');
      }
    } on DioException catch (e) {
      log('공식 코스 검색 요청 중 오류 발생 : ${e.message}');
      throw Exception(('공식 코스 검색 요청 중 오류 발생 : ${e.message}'));
    }
  }
}
