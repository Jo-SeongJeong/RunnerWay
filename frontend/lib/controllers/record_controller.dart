// import 'dart:math';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:frontend/models/record.dart';
import 'package:frontend/services/record_service.dart';

class RecordController extends GetxController {
  final RecordService _recordService = RecordService();

  var records = <Record>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 러닝 목록 조회
  Future<void> fetchRecordList(int year, int month, int day) async {
    isLoading(true);
    try {
      final fetchedRecords =
          await _recordService.fetchRecordList(year, month, day);
      if (fetchedRecords.isEmpty) {
      } else {}
      records.value = fetchedRecords;
    } catch (e) {
      errorMessage.value = '러닝 기록 목록 조회 중 오류 발생: $e';
    } finally {
      isLoading(false);
    }
  }

  // 러닝 기록 상세 조회
  Future<void> fetchRecordDetail(int recordId) async {
    try {
      var detail = await _recordService.fetchRecordDetail(recordId);
    } catch (e) {
      log('상세정보조회실패: $e');
    }
  }
}
