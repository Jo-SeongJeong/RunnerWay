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

      // totalDistance를 소수점 한 자리로 자르기
      final modifiedAnalyze = analyze.copyWith(
        totalDistance: double.parse(analyze.totalDistance.toStringAsFixed(1)),
      );

      return modifiedAnalyze;
    } catch (e) {
      throw Exception('월별 러닝 기록 분석 가져오는 중 오류 발생: $e');
    }
  }

  // 월별 러닝 기록의 날짜 가져오기
  Future<List<DateTime>> fetchRecordDaysByMonth(int year, int month) async {
    try {
      final records = await _repository.fetchRecords(year, month);

      // 날짜만 추출하고, null이 아닌 경우만 변환하여 중복 제거
      Set<DateTime> days = records
          .where((record) => record.startDate != null) // null인 startDate는 제외
          .map(
        (record) {
          // String을 DateTime으로 변환하고, 시간 부분을 0으로 설정
          DateTime fullDate = DateTime.parse(record.startDate!);
          return DateTime(fullDate.year, fullDate.month, fullDate.day); // 시간 제거
        },
      ).toSet();

      return days.toList();
    } catch (e) {
      throw Exception('월별 러닝 기록 날짜들 가져오기 중 오류 발생 : $e');
    }
  }
}
