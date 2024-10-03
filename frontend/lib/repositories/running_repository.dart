import 'dart:developer';

import 'package:frontend/models/ranking_upload_model.dart';
import 'package:frontend/models/running_record_model.dart';
import 'package:frontend/providers/running_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningRepository {
  final RunningProvider _runningProvider = RunningProvider();

  // Submit running record to the API and get recordId
  Future<String> submitRunningRecord() async {
    return await _runningProvider.submitRunningRecord();
  }

  Future<String> getRankingLog(int id) async {
    try {
      final response = await _runningProvider.getRankingLog(id);
      log('Response type: ${response.runtimeType}');
      return response;
    } catch (e) {
      log('Error fetching ranking course points: $e');
      return '';
    }
  }

  // 랭킹 데이터 조회
  Future<List<RunningRecord>> getRankingCoursePoints(String url) async {
    try {
      final response = await _runningProvider.fetchRankingCoursePoints(url);
      // 시작 시간을 첫 번째 기록의 시간으로 설정
      DateTime? startTime;
      if (response.isNotEmpty && response[0]['timestamp'] != null) {
        startTime = DateTime.parse(response[0]['timestamp']);
      }

      return response.map<RunningRecord>((point) {
        log('포인트: ${point}');
        if (point['elapsedTime'] != null) {
          return RunningRecord(
            latitude: point['latitude'] as double,
            longitude: point['longitude'] as double,
            elapsedTime: Duration(seconds: point['elapsedTime'] as int),
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
      log('Error fetching ranking course points: $e');
      return [];
    }
  }

  Future<bool> getRegistRanking(int courseId, String elapsedTime) async {
    final response =
        await _runningProvider.getRegistRanking(courseId, elapsedTime);
    return response == '등록 가능';
  }

  Future<bool> registRanking(RankingUploadModel model) async {
    final response = await _runningProvider.registRanking(model);
    return response == '랭킹 등록 완료!!';
  }
}
