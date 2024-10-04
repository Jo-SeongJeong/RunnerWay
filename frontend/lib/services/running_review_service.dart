import 'package:get/get.dart';
import '../models/running_review_model.dart';
import '../repositories/running_review_repository.dart';

class RunningReviewService extends GetxService {
  final RunningReviewRepository _repository = RunningReviewRepository();

  Future<dynamic> submitReview(RunningReviewModel review) async {
    try {
      final response = await _repository.submitReview(review);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
