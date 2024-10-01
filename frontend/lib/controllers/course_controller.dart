import 'dart:developer';

import 'package:frontend/models/ranking.dart';
import 'package:frontend/services/course_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/course.dart';

class CourseController extends GetxController {
  var isDetailLoading = true.obs;
  var isRankingLoading = true.obs;
  var course = Rxn<Course>();
  var ranking = <Ranking>[].obs;
  var coursePoints = <LatLng>[].obs;

  final CourseService _courseService = CourseService();

  @override
  void onInit() {
    super.onInit();

    // Get.parameters에서 courseId와 type 가져옴
    final String? idString = Get.parameters['id']; // 'id'는 String으로 받아옴
    final String? type = Get.parameters['type'];

    // idString을 int로 변환
    if (idString != null && type != null) {
      final int? id = int.tryParse(idString); // String을 int로 변환 시도

      if (id != null) {
        if (type == 'official') {
          // 공식 코스 상세 정보 가져오기
          _fetchOfficialCourseDetail(id);
        } else if (type == 'user') {
          // 유저 코스 상세 정보 가져오기
          _fetchUserCourseDetail(id);
        }

        // 코스 랭킹 가져오기
        _fetchCourseRanking(id);
      } else {
        log('Invalid ID or type');
      }
    }
  }

  // 공식 코스 상세 정보 가져오기
  Future<void> _fetchOfficialCourseDetail(int id) async {
    // 로딩 상태 true
    isDetailLoading(true);

    try {
      final fetchedOfficialCourseDetail =
          await _courseService.getOfficialCourseDetail(id);

      // 코스 상세 정보 업데이트
      course.value = fetchedOfficialCourseDetail;

      // 코스 상세 정보가 존재하면 AWS S3에서 경로 데이터를 받아온다
      if (fetchedOfficialCourseDetail != null) {
        await _fetchCoursePoints(fetchedOfficialCourseDetail.courseId);
      }
    } catch (e) {
      log('코스 상세 조회 중 문제 발생 : $e');
    } finally {
      isDetailLoading(false);
    }
  }

  // AWS S3에서 경로 데이터를 가져오기
  Future<void> _fetchCoursePoints(int id) async {
    try {
      final fetchedCoursePoints = await _courseService.getCoursePoints(id);

      // 경로 데이터 업데이트
      coursePoints.value = fetchedCoursePoints;
    } catch (e) {
      log('AWS S3에서 경로 데이터를 가져오는 중 오류 발생: $e');
    }
  }

  // 유저 코스 상세 정보 가져오기
  Future<void> _fetchUserCourseDetail(int id) async {
    // 로딩 상태 true
    isDetailLoading(true);

    try {
      final fetchedUserCourseDetail =
          await _courseService.getUserCourseDetail(id);

      // 코스 상세 정보 업데이트
      course.value = fetchedUserCourseDetail;

      // 코스 상세 정보가 존재하면 AWS S3에서 경로 데이터를 받아온다
      if (fetchedUserCourseDetail != null) {
        await _fetchCoursePoints(fetchedUserCourseDetail.courseId);
      }
    } catch (e) {
      log('코스 상세 조회 중 문제 발생 : $e');
    } finally {
      isDetailLoading(false);
    }
  }

  // 코스 랭킹 가져오기
  Future<void> _fetchCourseRanking(int id) async {
    isRankingLoading(true);

    try {
      final fetchedCourseRanking = await _courseService.getCourseRanking(id);

      // 랭킹 정보 업데이트
      ranking.assignAll(fetchedCourseRanking);
    } catch (e) {
      log('코스 랭킹 조회 중 문제 발생 : $e');
    } finally {
      isRankingLoading(false);
    }
  }
}
