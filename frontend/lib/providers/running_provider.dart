import 'package:frontend/utils/dio_client.dart';

class RunningProvider {
  final dioClient = DioClient();

  Future<dynamic> submitRunningRecord() async {
    try {
      final reseponse = await dioClient.dio.post('record');
      if (reseponse.statusCode == 201) {
        return reseponse.data['runningRecordId'];
      } else {
        throw Exception('Failed to submit running record');
      }
    } catch (e) {
      throw Exception('Error submitting running record: $e');
    }
  }
}
