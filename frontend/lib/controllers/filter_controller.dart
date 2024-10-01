import 'dart:developer';
import 'package:frontend/controllers/location_controller.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  // 정렬 기준
  var sortCondition = '추천순'.obs;

  // LocationController
  final LocationController locationController = Get.find<LocationController>();

  // 필터 상태 : 난이도와 거리 필터
  var selectedDifficulty = <int>[1, 2, 3].obs;
  var selectedLength = <dynamic>[3, 5, 10, 'over'].obs;

  // 난이도 라벨과 실제 값 매핑
  final difficultyLabels = {
    1: 'Lv. 1',
    2: 'Lv. 2',
    3: 'Lv. 3',
  };

  // 거리 라벨과 실제 값 매핑
  final lengthLabels = {
    3: '~ 3km',
    5: '3 ~ 5km',
    10: '5 ~10km',
    'over': '10km ~',
  };

  // 현재 필터가 적용될 타겟
  String? filterTarget;

  // 필터 업데이트 시 호출될 콜백 함수
  Function? onMainFilterUpdated;
  Function? onSearchFilterUpdated;

  // 타겟 설정 함수
  void setFilterTarget(String target) {
    filterTarget = target;
  }

  // 필터 조건 초기화 메서드
  void resetFilters() {
    sortCondition.value = '추천순'; // 기본 정렬 조건으로 초기화
    selectedDifficulty.assignAll([1, 2, 3]); // 난이도 필터 초기화
    selectedLength.assignAll([3, 5, 10, 'over']); // 거리 필터 초기화
  }

  // 정렬 기준 업데이트
  void updateSortCondition(String newCondition) {
    log('$newCondition');

    // controller의 value 변경
    sortCondition.value = newCondition;
    // target controller로 변경된 정렬 기준 전달
    _applyFiltersToTarget();
  }

  void updateFilterCondition() {
    locationController.getCurrentLocation();
    _applyFiltersToTarget();
  }

  void _applyFiltersToTarget() {
    if (filterTarget == 'main' && onMainFilterUpdated != null) {
      // 메인 컨트롤러에만 필터 적용
      onMainFilterUpdated!();
    } else if (filterTarget == 'runner' && onSearchFilterUpdated != null) {
      // 검색 컨트롤러에만 필터 적용
      onSearchFilterUpdated!();
    }
  }
}
