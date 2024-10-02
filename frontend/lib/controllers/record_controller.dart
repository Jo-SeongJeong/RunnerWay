import 'dart:developer';

import 'package:frontend/models/record_analyze.dart';
import 'package:get/get.dart';
import 'package:frontend/models/record.dart';
import 'package:frontend/services/record_service.dart';

class RecordController extends GetxController {
  final RecordService _recordService = RecordService();

  var dayRecords = <Record>[].obs;
  var monthRecords = Rxn<RecordAnalyze>();
  var isDayRecordLoading = false.obs;
  var isMonthRecordLoading = false.obs;
  var errorMessage = ''.obs;

  // TODO : 월별 러닝 기록 분석 조회
  Future<void> fetchMonthRecord(int year, int month) async {
    isMonthRecordLoading(true);
    try {
      // final fetchedMonthRecord =
      //     await _recordService.fetchMonthRecord(year, month);
    } catch (e) {
      log('월별 러닝 기록 조회 중 오류 발생 : $e');
    } finally {
      isMonthRecordLoading(false);
    }
  }

  // TODO : 일별 러닝 목록 조회
  Future<void> fetchRecordList(int year, int month, int day) async {
    isDayRecordLoading(true);
    try {
      final fetchedRecords =
          await _recordService.fetchRecordList(year, month, day);
      if (fetchedRecords.isEmpty) {
      } else {}
      dayRecords.value = fetchedRecords;
    } catch (e) {
      errorMessage.value = '러닝 기록 목록 조회 중 오류 발생: $e';
    } finally {
      isDayRecordLoading(false);
    }
  }
}
