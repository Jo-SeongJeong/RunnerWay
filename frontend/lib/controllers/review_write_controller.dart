import 'dart:developer';
import 'package:frontend/models/personal_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/running_review_model.dart';
import '../services/running_review_service.dart';
import 'package:frontend/utils/s3_image_upload.dart'; // Import the renamed file

class RunningReviewController extends GetxController {
  final RunningReviewService _service = RunningReviewService();
  final S3ImageUpload s3ImageUpload =
      S3ImageUpload(); // Use the renamed S3ImageUpload class

  final details = <String, dynamic>{
    // Changed to dynamic to allow nullable String
    'title': "유성천 옆 산책로",
    'address': "대전광역시 문화원로 80",
    'time': DateTime(2024, 9, 6, 9, 24, 27),
    'image': '',
    'content': "",
  }.obs;

  final records = [10.0, 4016, 0.0, 480].obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final content = "".obs;
  final courseId = 0.obs;

  void updateContent(String value) {
    content.value = value;
    details['content'] = value;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);

      // S3에 이미지 업로드 및 URL 반환
      String? uploadedImageUrl = await s3ImageUpload.uploadImage2(
        selectedImage.value!,
        "uploads/running_images",
      );

      if (uploadedImageUrl != null) {
        details['image'] = uploadedImageUrl; // 업로드된 이미지 URL 저장
        Get.snackbar(
            'Success', 'Image uploaded successfully: $uploadedImageUrl');
        log('Image URL: $uploadedImageUrl'); // 로그에 이미지 URL 출력
      }
    }
  }

  Future<void> onRegisterTapped() async {
    try {
      double distance = records[0].toDouble(); // Distance in meters
      int timeInSeconds = records[1].toInt(); // Time in seconds
      String score = calculateTime(timeInSeconds); // Convert time to string

      final review = RunningReviewModel(
        courseId: courseId.value,
        score: score,
        runningDistance: distance,
        calorie: records[3].toDouble(),
        averagePace: records[2].toDouble(),
        comment: content.value,
        startDate: details['time'] as DateTime,
        finishDate:
            (details['time'] as DateTime).add(Duration(seconds: timeInSeconds)),
        personalImage: PersonalImage(
          url: details['image'], // Use uploaded image URL
          path: selectedImage.value?.path ?? '',
        ),
      );

      await _service.submitReview(review);
      Get.snackbar('Success', 'Review submitted successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review: $e');
      log('Error: $e');
    }
  }

  String calculateTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
