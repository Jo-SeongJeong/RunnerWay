import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Future<String> getAddress(LatLng gps) async {
    final response = await _provider.getAddress(gps);
    return response;
  }
}
