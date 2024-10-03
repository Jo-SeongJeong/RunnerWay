import 'package:frontend/models/running_record_model.dart';
import 'package:frontend/providers/running_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningRepository {
  final RunningProvider _runningProvider = RunningProvider();

  // Submit running record to the API and get recordId
  Future<String> submitRunningRecord() async {
    return await _runningProvider.submitRunningRecord();
  }

  // 랭킹 데이터 조회
  Future<List<RunningRecord>> getRankingCoursePoints(int id) async {
    try {
      final response = await _runningProvider.fetchRankingCoursePoints(id);

      // 시작 시간을 첫 번째 기록의 시간으로 설정
      DateTime? startTime;
      if (response.isNotEmpty && response[0]['timestamp'] != null) {
        startTime = DateTime.parse(response[0]['timestamp']);
      }

      return response.map<RunningRecord>((point) {
        if (point['elapsedTime'] != null) {
          return RunningRecord(
            latitude: point['latitude'] as double,
            longitude: point['longitude'] as double,
            elapsedTime: Duration(milliseconds: point['elapsedTime'] as int),
          );
        } else if (point['timestamp'] != null && startTime != null) {
          return RunningRecord.fromTimestamp(
            latitude: point['latitude'] as double,
            longitude: point['longitude'] as double,
            timestamp: DateTime.parse(point['timestamp']),
            startTime: startTime,
          );
        } else {
          // 필요한 데이터가 없는 경우 기본값 사용
          return RunningRecord(
            latitude: point['latitude'] ?? 0.0,
            longitude: point['longitude'] ?? 0.0,
            elapsedTime: Duration.zero,
          );
        }
      }).toList();
    } catch (e) {
      print('Error fetching ranking course points: $e');
      return [];
    }
  }
}
