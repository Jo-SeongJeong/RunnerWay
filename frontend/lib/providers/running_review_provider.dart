import 'dart:developer';

import 'package:frontend/utils/dio_client.dart';
import 'package:get/get.dart';
import '../models/running_review_model.dart';

class RunningReviewProvider {
  final dioClient = DioClient();

  Future<dynamic> submitReview(RunningReviewModel review) async {
    log('리뷰다: ${review.toString()}');
    log('리뷰다: ${review.toJson()}');
    try {
      final response = await dioClient.dio.post(
        '/record',
        data: review.toJson(),
      );
      log('${response}');
      return response;
    } catch (e) {
      throw e;
    }
  }
}
