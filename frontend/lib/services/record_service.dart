import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/record_analyze.dart';
import 'package:frontend/repositories/record_repository.dart';
import 'package:frontend/models/record.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

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

  // 러닝기록 상세 조회
  Future<dynamic> fetchRecordDetail(int recordId) async {
    try {
      final response = await _repository.fetchRecordDetail(recordId);
      log('service : ${response.toString()}');

      int? id = int.tryParse(Get.parameters['id'] ?? '1');
      Record updatedRecord = response.copyWith(recordId: id);

      return updatedRecord;
    } catch (e) {
      log('service detail: ${e.toString()}');
      throw Exception('러닝 기록 상세 조회 중 오류 service: $e');
    }
  }

  // 러닝 기록 수정
  Future<dynamic> patchRecord(Map<String, dynamic> updateData) async {
    try {
      final response = await _repository.patchRecord(updateData);
      log('service: ${response.toString()}');
      // int? id = int.tryParse(Get.parameters['id'] ?? '1');
      // Record updatedRecord = response.copyWith(recordId: id);
      return response;
    } catch (e) {
      throw Exception('기록수정오류service: $e');
    }
  }

  Future<Polyline?> loadPresetPath(int recordId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      // recordId에 따라 파일 경로 동적 설정
      final filePath = '${directory.path}/preset_path_$recordId.json';
      final file = File(filePath);

      // 파일이 존재할 경우 데이터 읽기
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);

        // JSON 데이터를 LatLng 리스트로 변환
        List<LatLng> presetPath = jsonList
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList();

        // Polyline 생성하여 반환
        return Polyline(
          polylineId: PolylineId('presetPath_$recordId'),
          color: Colors.green, // 기존 경로의 색상 지정
          width: 5,
          points: presetPath,
        );
      } else {
        print('Preset path file does not exist for recordId $recordId.');
        return null;
      }
    } catch (e) {
      print('Error loading preset path for recordId $recordId: $e');
      return null;
    }
  }
}
