import 'package:get/get.dart';
import '../models/running_review_model.dart';
import '../repositories/running_review_repository.dart';

class RunningReviewService extends GetxService {
  final RunningReviewRepository _repository = RunningReviewRepository();

  Future<void> submitReview(RunningReviewModel review) async {
    try {
      await _repository.submitReview(review);
    } catch (e) {
      throw e;
    }
  }
}
