import 'package:frontend/repositories/record_repository.dart';
import 'package:frontend/models/record.dart';

class RecordService {
  final RecordRepository _repository = RecordRepository();

  Future<List<Record>> fetchRecordList(int year, int month, int day) async {
    try {
      final records = await _repository.fetchRecordList(year, month, day);
      return records;
    } catch (e) {
      throw Exception('러닝 기록 조회 중 오류 발생 service: $e');
    }
  }
}
