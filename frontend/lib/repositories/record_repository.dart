import 'dart:developer';

import 'package:frontend/models/record.dart';
import 'package:frontend/models/record_analyze.dart';
import 'package:frontend/providers/record_provider.dart';

class RecordRepository {
  final RecordProvider _provider = RecordProvider();

  // 러닝 기록 목록 조회
  Future<List<Record>> fetchRecordList(int year, int month, int day) async {
    final response = await _provider.fetchRecordCourse(year, month, day);
    return response.map<Record>((record) => Record.fromJson(record)).toList();
  }

  // 월별 러닝 기록 분석 조회
  Future<RecordAnalyze> fetchMonthAnalyze(int year, int month) async {
    final response = await _provider.fetchMonthAnalyze(year, month);

    return RecordAnalyze.fromJson(response);
  }
}
