import 'dart:developer';

import 'package:frontend/models/course.dart';
import 'package:frontend/models/ranking.dart';
import 'package:frontend/providers/course_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CourseRepository {
  final CourseProvider _provider = CourseProvider();

  // 위치 정보를 받아 코스 목록을 반환
  Future<List<Course>> getOfficialCourses(
      double latitude, double longitude) async {
    final response = await _provider.fetchOfficialCourses(latitude, longitude);
    return response.map((courseData) => Course.fromJson(courseData)).toList();
  }

  // 공식 코스 상세 정보 조회
  Future<Course> getOfficialCourseDetail(int id) async {
    final response = await _provider.fetchOfficialCourseDetail(id);

    // response가 JSON 문자열일 경우 파싱
    return Course.fromJson(response);
  }

  // 유저 코스 상세 조회
  Future<Course> getUserCourseDetail(int id) async {
    final response = await _provider.fetchUserCourseDetail(id);

    return Course.fromJson(response);
  }

  // 코스 랭킹 정보 조회
  Future<List<Ranking>> getCourseRanking(int id) async {
    final response = await _provider.fetchCourseRanking(id);

    return response
        .map((courseRanking) => Ranking.fromJson(courseRanking))
        .toList();
  }

  // 유저 코스 전체 조회
  Future<List<Course>> getRunnerCourse(
      double latitude, double longitude) async {
    final response = await _provider.fetchRunnerCourse(latitude, longitude);
    log('repository: $response');

    return response.map((course) => Course.fromJson(course)).toList();
  }

  // 전체 인기 유저 코스 조회
  Future<List<Course>> getMostPickCourse(
      double latitude, double longitude) async {
    final response = await _provider.fetchMostPickCourse(latitude, longitude);
    log('전체 인기 유저 코스 조회 repository: $response');

    return response.map((course) => Course.fromJson(course)).toList();
  }

  // 최근 인기 유저 코스 조회
  Future<List<Course>> getRecentPickCours(
      double latitude, double longitude) async {
    final response = await _provider.fetchRecentPickCourse(latitude, longitude);

    return response.map((course) => Course.fromJson(course)).toList();
  }

  // 경로 데이터 조회
  Future<List<LatLng>> getCoursePoints(int id) async {
    final response = await _provider.fetchCoursePoints(id);

    return response.map<LatLng>(
      (point) {
        return LatLng(
          point['latitude'] as double, // latitude 값
          point['longitude'] as double, // longitude 값
        );
      },
    ).toList();
  }
}
