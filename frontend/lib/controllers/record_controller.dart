import 'dart:developer';

import 'package:frontend/models/record_analyze.dart';
import 'package:get/get.dart';
import 'package:frontend/models/record.dart';
import 'package:frontend/services/record_service.dart';
// import 'package:frontend/services/course_service.dart';

class RecordController extends GetxController {
  final RecordService _recordService = RecordService();
  // final CourseService _courseService = CourseService();
  var courseName = ''.obs;
  var startDate = ''.obs;
  var comment = ''.obs;

  var dayRecords = <Record>[].obs;
  var monthRecords = Rxn<RecordAnalyze>();
  var isDayRecordLoading = false.obs;
  var isMonthRecordLoading = false.obs;
  var isStampLoading = false.obs;
  var errorMessage = ''.obs;
  var stampDays = <DateTime>[].obs;
  var selectedRecordId = 0.obs;
  var recordList = <Record>[].obs;
  var recordDetail = Rxn<Record>();

  var isLoading = false.obs;
  var courseId = 0.obs; // 0이면 자유코스

  var selectedDate = Rxn<DateTime>(); // 선택된 날짜
  var focusedDate = Rxn<DateTime>(); // 포커스된 날짜

  @override
  void onInit() {
    super.onInit();

    // 기본적으로 오늘 날짜로 기록 로드
    setFocusedDate(DateTime.now());
    setSelectedDate(DateTime.now());
    // fetchMonthRecord(focusedDate.value!.year, focusedDate.value!.month);
    // fetchRecordList(selectedDate.value!.year, selectedDate.value!.month,
    //     selectedDate.value!.day);
  }

  // 날짜 설정 및 기록 조회
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchRecordList(selectedDate.value!.year, selectedDate.value!.month,
        selectedDate.value!.day);
  }

  // 날짜 포커스 설정 메서드
  void setFocusedDate(DateTime date) {
    focusedDate.value = date;
    log('$focusedDate');
    fetchMonthRecord(focusedDate.value!.year, focusedDate.value!.month);
    fetchStamps(focusedDate.value!.year, focusedDate.value!.month);
  }

  // 기록 목록에서 기록 선택 시 실행
  void selectRecord(int recordId) {
    selectedRecordId.value = recordId;
    fetchRecordDetail(recordId); // 상세 정보 조회
  }

  // 월별 러닝 기록 분석 조회
  Future<void> fetchMonthRecord(int year, int month) async {
    isMonthRecordLoading(true);
    try {
      final fetchedMonthRecord =
          await _recordService.fetchMonthAnalyze(year, month);
      // stampDays.value = fetchedMonthRecord ?? <DateTime>[];
      log('fetched month record : $fetchedMonthRecord');

      monthRecords.value = fetchedMonthRecord;
      log('${monthRecords.value.toString()}');
    } catch (e) {
      log('월별 러닝 기록 조회 중 오류 발생 : $e');
    } finally {
      isMonthRecordLoading(false);
    }
  }

  // 일별 러닝 목록 조회
  Future<void> fetchRecordList(int year, int month, int day) async {
    isDayRecordLoading(true);
    try {
      final fetchedRecords =
          await _recordService.fetchRecordList(year, month, day);

      dayRecords.value = fetchedRecords;
    } catch (e) {
      errorMessage.value = '러닝 기록 목록 조회 중 오류 발생: $e';
    } finally {
      isDayRecordLoading(false);
    }
  }

  // 월별 스탬프를 찍을 날짜 조회
  Future<void> fetchStamps(int year, int month) async {
    isStampLoading.value = true;
    try {
      final fetchedRecordDays = await _recordService.fetchRecordDaysByMonth(
        year,
        month,
      );
      log('$fetchedRecordDays');

      stampDays.value = fetchedRecordDays;
    } catch (e) {
      log('스탬프 날짜 조회 중 오류 발생 : $e');
    } finally {
      isStampLoading.value = false;
    }
  }

  // 러닝 기록 상세 조회
  Future<void> fetchRecordDetail(int recordId) async {
    log('$recordId');
    isLoading(true);
    try {
      var detail = await _recordService.fetchRecordDetail(recordId);
      log('record controller: $detail');
      if (detail != null) {
        recordDetail.value = detail; // 이 부분을 활성화하여 데이터를 설정
      }
    } catch (e) {
      log('상세정보조회실패: $e');
    } finally {
      isLoading(false);
    }
  }

  // 러닝 기록 수정
  Future<dynamic> patchRecord(Map<String, dynamic> updateData) async {
    try {
      final response = await _recordService.patchRecord(updateData);
      log('기록성공controller');
    } catch (e) {
      log('기록수정실패: $e');
    }
  }

// 러닝 사진 변경
}
