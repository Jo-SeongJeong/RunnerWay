import 'dart:developer';

import 'package:frontend/repositories/course_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/course.dart';
import '../models/ranking.dart';

class CourseService {
  final CourseRepository _repository = CourseRepository();

  // 공식 러닝 전체 조회 (현위치로부터 거리 포함)
  Future<List<Course>> getCoursesWithDistance(Position currentPosition) async {
    final courses = await _repository.getOfficialCourses(
        currentPosition.latitude, currentPosition.longitude);

    // 거리 계산
    return courses.map(
      (course) {
        double distance = _calculateDistance(
          currentPosition.latitude,
          currentPosition.longitude,
          course.lat,
          course.lng,
        );

        log('courseName : ${course.name}, distance : $distance');

        return course.copyWith(distance: distance);
      },
    ).toList();
  }

  // 공식 코스 상세 조회
  Future<Course> getOfficialCourseDetail(int id) async {
    final course = await _repository.getOfficialCourseDetail(id);

    return course;
  }

  // 유저 코스 상세 조회
  Future<Course> getUserCourseDetail(int id) async {
    final course = await _repository.getUserCourseDetail(id);

    return course;
  }

  // 러너 코스 전체 조회
  Future<List<Course>> getRunnerCourse(Position currentPosition) async {
    final courses = await _repository.getRunnerCourse(
      currentPosition.latitude,
      currentPosition.longitude,
    );
    log('러너 코스 조회 service: $courses');

    return courses.map(
      (course) {
        double distance = _calculateDistance(
          currentPosition.latitude,
          currentPosition.longitude,
          course.lat,
          course.lng,
        );

        log('courseName : ${course.name}, distance : $distance');

        return course.copyWith(distance: distance);
      },
    ).toList();
  }

  // 코스 랭킹 조회
  Future<List<Ranking>> getCourseRanking(int id) async {
    final ranking = await _repository.getCourseRanking(id);

    return ranking;
  }

  // 두 지점 간의 거리 계산 (단위: 미터)
  double _calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // 전체 인기 유저 코스 조회
  Future<List<Course>> getMostPickCourse(Position currentPosition) async {
    final courses = await _repository.getMostPickCourse(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    return courses;
  }

  // 최근 인기 유저 코스 조회
  Future<List<Course>> getRecentPickCourse(Position currentPosition) async {
    final courses = await _repository.getRecentPickCours(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    return courses;
  }

  // 코스 경로 데이터 조회
  Future<List<LatLng>> getCoursePoints(int id) async {
    final points = await _repository.getCoursePoints(id);

    return points;
  }
}
