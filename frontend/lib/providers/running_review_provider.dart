import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/dio_client.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/running_review_model.dart';

class RunningReviewProvider {
  final dioClient = DioClient();
  final dio = Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> getGoogleApiKey() async {
    return await storage.read(key: 'GOOGLE_MAP_API_KEY');
  }

  Future<dynamic> submitReview(RunningReviewModel review) async {
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

  // Google Geocoding API를 이용한 주소 변환
  Future<String> getAddress(LatLng gps) async {
    String? googleApiKey = await getGoogleApiKey();

    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${gps.latitude},${gps.longitude}&key=$googleApiKey&language=ko';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          String address = data['results'][0]['formatted_address'];
          return address;
        } else {
          log('No address found for the given coordinates.');
        }
      } else {
        log('Failed to fetch address: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching address: $e');
    }
    return '';
  }
}
