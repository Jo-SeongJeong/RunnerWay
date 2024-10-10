import 'dart:developer';

import 'package:frontend/controllers/filter_controller.dart';
import 'package:frontend/controllers/location_controller.dart';
import 'package:frontend/services/course_service.dart';
import 'package:get/get.dart';
import 'package:frontend/models/course.dart';

class MainController extends GetxController {
  // var currentPosition = Rxn<Position>(); // 현재 위치 정보를 관리
  var courses = <Course>[].obs; // 코스 리스트
  var isLoading = true.obs; // 로딩 상태 관리
  var filteredCourses = <Course>[].obs; // 필터링 및 정렬된 코스 결과

  final CourseService _courseService = CourseService();
  final LocationController locationController = Get.find<LocationController>();
  final FilterController filterController = Get.find<FilterController>();

  @override
  void onInit() {
    super.onInit();
    // 위치 정보를 기다린 후 fetchOfficialCourses 호출
    locationController.getCurrentLocation().then((_) {
      if (locationController.currentPosition.value != null) {
        fetchOfficialCourses();
      } else {
        log('위치 정보를 가져오지 못했습니다.');
      }
    });

    // 필터 적용 콜백 설정
    filterController.onMainFilterUpdated = _applyFiltersToCourses;
  }

  // 코스를 불러오는 함수
  Future<void> fetchOfficialCourses() async {
    isLoading(true);

    try {
      log('${locationController.currentPosition.value}');
      final fetchedCourses = await _courseService
          .getCoursesWithDistance(locationController.currentPosition.value!);

      courses.assignAll(fetchedCourses); // 코스 데이터 업데이트
      filteredCourses.assignAll(courses);
    } catch (e) {
      print('코스를 가져오는 중 오류 발생: $e');
    } finally {
      isLoading(false);
    }
  }

  // 코스 리스트 업데이트 함수
  void _applyFiltersToCourses() {
    var filteredList = courses.toList();

    // 1. 난이도 필터링
    filteredList = filteredList.where((course) {
      return filterController.selectedDifficulty.contains(course.level);
    }).toList();

    // 2. 거리 필터링
    filteredList = filteredList.where((course) {
      final selectedLength = filterController.selectedLength;

      return selectedLength.any((length) {
        if (length == 3) {
          return course.courseLength <= 3;
        } else if (length == 5) {
          return course.courseLength > 3 && course.courseLength <= 5;
        } else if (length == 10) {
          return course.courseLength > 5 && course.courseLength <= 10;
        } else if (length == 'over') {
          return course.courseLength > 10;
        }

        return false;
      });
    }).toList();

    // 정렬 기준에 맞게 정렬
    switch (filterController.sortCondition.value) {
      case '인기순':
        // 인기순인 경우, count가 큰 순서로 정렬
        filteredList.sort((a, b) => b.count.compareTo(a.count));
        break;
      case '거리순':
        // 거리순인 경우, distance가 작은 순서로 정렬
        filteredList.sort((a, b) {
          if (a.distance == null && b.distance == null) return 0;
          if (a.distance == null) return 1; // distance가 null인 코스는 뒤로
          if (b.distance == null) return -1;
          return a.distance!.compareTo(b.distance!);
        });
        break;
      default:
        // 추천순인 경우 정렬 구현 x
        break;
    }

    // 필터링 및 정렬된 리스트 업데이트
    filteredCourses.assignAll(filteredList);
  }
}
