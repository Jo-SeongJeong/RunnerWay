// providers/course_provider.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:frontend/utils/env.dart';

class CourseProvider {
  final dioClient = DioClient();
  var dio = Dio();

  // 공식 코스 리스트 가져오기
  Future<List<dynamic>> fetchOfficialCourses(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await dioClient.dio.get(
        'official-course/list',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
        },
      );
      log('$response');

      // 응답이 성공적이면 데이터 반환
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception('Failed to load courses');
      }
    } on DioException catch (e) {
      // 에러 처리
      print('코스를 가져오는 중 문제 발생 : ${e.message}');
      throw Exception('코스 가져오기 실패: ${e.message}');
    }
  }

  // 공식 코스 상세 조회 가져오기
  Future<Map<String, dynamic>> fetchOfficialCourseDetail(int id) async {
    try {
      final response = await dioClient.dio.get(
        '/official-course/detail/${id}',
      );

      log('$response');

      // 응답이 성공적이면 데이터 반환
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.statusCode == 404) {
        // 404 : 데이터 없음
        return {};
      } else {
        throw Exception('Failed to load courses');
      }
    } on DioException catch (e) {
      // 에러 처리
      print('공식 코스 상세 정보를 가져오는 중 문제 발생 : ${e.message}');
      throw Exception('코스 가져오기 실패: ${e.message}');
    }
  }

  // 유저 코스 상세 조회
  Future<Map<String, dynamic>> fetchUserCourseDetail(int id) async {
    try {
      final response = await dioClient.dio.get(
        '/user-course/detail/$id',
      );

      log('$response');

      // 응답이 성공적이면 데이터 반환
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.statusCode == 404) {
        // 404 : 데이터 없음
        return {};
      } else {
        throw Exception('Failed to load courses');
      }
    } on DioException catch (e) {
      // 에러 처리
      print('유저 코스 상세 정보를 가져오는 중 문제 발생 : ${e.message}');
      throw Exception('코스 가져오기 실패: ${e.message}');
    }
  }

  // 코스 랭킹 정보 요청
  Future<List<dynamic>> fetchCourseRanking(int id) async {
    try {
      final response = await dioClient.dio.get(
        '/ranking/${id}',
      );
      log('ranking: $response');

      // 응답이 성공적이면 데이터 반환
      if (response.statusCode == 200) {
        return List<dynamic>.from(response.data);
      } else if (response.statusCode == 204) {
        // 204 상태코드면, 빈 리스트 반환
        return [];
      } else {
        throw Exception('Failed to load courses');
      }
    } on DioException catch (e) {
      // 에러 처리
      log('코스 랭킹 정보 가져오는 중 문제 발생 : ${e.message}');
      throw Exception('코스 랭킹 가져오기 실패 : ${e.message}');
    }
  }

  // 러너 코스 요청 API
  Future<List<dynamic>> fetchRunnerCourse(
      double latitude, double longitude) async {
    try {
      final response =
          await dioClient.dio.get('/user-course/list', queryParameters: {
        'lat': latitude,
        'lng': longitude,
      });

      log('러너 코스 조회 응답: $response');

      if (response.statusCode == 200) {
        // 응답 성공 시 요청 데이터 반환
        return response.data;
      } else if (response.statusCode == 204) {
        // 204 : 러너 코스 없음
        return [];
      } else {
        throw Exception('러너 코스 요청 실패');
      }
    } on DioException catch (e) {
      log('러너 코스 조회 중 문제 발생 : ${e.message}');
      throw Exception('러너 코스 조회 중 문제 발생 : ${e.message}');
    }
  }

  // 전체 인기 유저 코스 조회
  Future<List<dynamic>> fetchMostPickCourse(
      double latitude, double longitude) async {
    try {
      final response = await dioClient.dio.get(
        '/user-course/popularity/all',
        queryParameters: {'lat': latitude, 'lng': longitude},
      );
      log('전체 인기 유저 코스 API 통신 결과 : $response');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('전체 인기 유저 코스 조회 중 문제 발생');
      }
    } on DioException catch (e) {
      log('전체 인기 유저 코스 조회 중 문제 발생 : ${e.message}');
      throw Exception('전체 인기 유저 코스 조회 중 문제 발생 : ${e.message}');
    }
  }

  // 최근 인기 유저 코스 조회
  Future<List<dynamic>> fetchRecentPickCourse(
      double latitude, double longitude) async {
    try {
      final response = await dioClient.dio.get(
        '/user-course/popularity/lately',
        queryParameters: {'lat': latitude, 'lng': longitude},
      );
      log('최근 인기 유저 코스 API 통신 결과 : $response');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('최근 인기 유저 코스 조회 중 문제 발생');
      }
    } on DioException catch (e) {
      log('최근 인기 유저 코스 조회 : ${e.message}');
      throw Exception('최근 인기 유저 코스 조회 : ${e.message}');
    }
  }

  // 코스 경로 데이터 S3에서 가져오기
  Future<List<dynamic>> fetchCoursePoints(int id) async {
    try {
      log('${Env.s3Region}');
      log('${Env.s3Name}');
      log('${id}');
      final response = await dio.get(
        'https://${Env.s3Name}.s3.${Env.s3Region}.amazonaws.com/upload/course/${id}.json',
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
}
