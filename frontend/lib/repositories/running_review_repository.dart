import 'package:get/get.dart';
import '../models/running_review_model.dart';
import '../providers/running_review_provider.dart';

class RunningReviewRepository {
  final RunningReviewProvider _provider = RunningReviewProvider();

  Future<dynamic> submitReview(RunningReviewModel review) async {
    try {
      final response = await _provider.submitReview(review);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
