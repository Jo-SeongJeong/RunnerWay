import 'package:get/get.dart';
import '../models/running_review_model.dart';
import '../providers/running_review_provider.dart';

class RunningReviewRepository {
  final RunningReviewProvider _provider = RunningReviewProvider();

  Future<void> submitReview(RunningReviewModel review) async {
    try {
      await _provider.submitReview(review);
    } catch (e) {
      throw e;
    }
  }
}
