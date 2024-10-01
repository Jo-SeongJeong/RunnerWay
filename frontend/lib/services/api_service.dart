import 'package:dio/dio.dart';

// 수정 필요
class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://your-api-base-url.com'; // API 기본 URL을 여기에 입력하세요

  Future<String> submitRunningRecord() async {
    try {
      final response =
          await _dio.post('$_baseUrl/submit-record'); // 실제 엔드포인트로 변경하세요
      if (response.statusCode == 200) {
        return response.data['recordId']; // API 응답에서 recordId를 추출
      } else {
        throw Exception('Failed to submit running record');
      }
    } catch (e) {
      throw Exception('Error submitting running record: $e');
    }
  }
}
