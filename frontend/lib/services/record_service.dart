import 'package:frontend/models/record_analyze.dart';
import 'package:frontend/repositories/record_repository.dart';
import 'package:frontend/models/record.dart';

class RecordService {
  final RecordRepository _repository = RecordRepository();

  // 일별 러닝 기록 조회
  Future<List<Record>> fetchRecordList(int year, int month, int day) async {
    try {
      final records = await _repository.fetchRecordList(year, month, day);
      return records;
    } catch (e) {
      throw Exception('러닝 기록 조회 중 오류 발생 service: $e');
    }
  }

  // 월별 러닝 기록 분석 가져오기
  Future<RecordAnalyze> fetchMonthAnalyze(int year, int month) async {
    try {
      final analyze = await _repository.fetchMonthAnalyze(year, month);

      return analyze;
    } catch (e) {
      throw Exception('월별 러닝 기록 분석 가져오는 중 오류 발생: $e');
    }
  }

  // 러닝기록 상세 조회
  Future<void> fetchRecordDetail(int recordId) async {
    try {
      final response = await _repository.fetchRecordDetail(recordId);
      return response;
    } catch (e) {
      throw Exception('러닝 기록 상세 조회 중 오류 service: $e');
    }
  }
}
