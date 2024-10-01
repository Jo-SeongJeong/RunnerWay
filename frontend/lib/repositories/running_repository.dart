import 'package:frontend/providers/running_provider.dart';

class RunningRepository {
  final RunningProvider _runningProvider = RunningProvider();

  // Submit running record to the API and get recordId
  Future<String> submitRunningRecord() async {
    return await _runningProvider.submitRunningRecord();
  }
}
