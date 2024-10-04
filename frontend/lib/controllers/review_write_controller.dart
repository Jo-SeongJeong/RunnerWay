import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:frontend/controllers/course_controller.dart';
import 'package:frontend/controllers/running_controller.dart';
import 'package:frontend/models/personal_image.dart';
import 'package:frontend/services/file_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/running_review_model.dart';
import '../services/running_review_service.dart';
import 'package:frontend/utils/s3_image_upload.dart'; // Import the renamed file

class RunningReviewController extends GetxController {
  final RunningController runningController = Get.find<RunningController>();
  final CourseController courseController = Get.isRegistered<CourseController>()
      ? Get.find<CourseController>()
      : Get.put(CourseController());
  final RunningReviewService _service = RunningReviewService();
  final S3ImageUpload s3ImageUpload = S3ImageUpload();
  late final FileService _fileService = FileService();
  final TextEditingController commentController = TextEditingController(); // 추가

  // RunningReviewModel 인스턴스를 Rxn으로 관리하여 null 가능성도 포함
  var reviewModel = Rxn<RunningReviewModel>();
  var name = ''.obs;

  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();

    initializeReview();
    commentController.text = reviewModel.value?.comment ?? '';
  }

  // 리뷰 모델 초기화 메서드
  void initializeReview() {
    log('review 작성 초기화 시작');

    double totalDistance =
        runningController.value.value.totalDistance; // 전체 거리 (킬로미터)
    int totalTime =
        runningController.value.value.elapsedTime.inSeconds; // 전체 시간 (초)

    double averagePace =
        calculateAveragePace(totalTime, totalDistance); // 평균 페이스 계산

    reviewModel.value = RunningReviewModel(
      courseId: courseController.course.value?.courseId ?? 0,
      score: runningController.value.value.elapsedTime.inSeconds,
      runningDistance: runningController.value.value.totalDistance,
      calorie: calculateCalorie(),
      averagePace: averagePace,
      comment: '',
      address: '봉명동',
      startDate: DateTime.now()
          .subtract(runningController.value.value.elapsedTime)
          .copyWith(millisecond: 0, microsecond: 0),
      finishDate: DateTime.now().copyWith(millisecond: 0, microsecond: 0),
      lat: runningController.startPoint?.latitude ?? 0.0,
      lng: runningController.startPoint?.longitude ?? 0.0,
      personalImage: PersonalImage(url: '', path: ''),
    );

    name.value = runningController.typeKorean.toString() == '자유'
        ? '자유 코스'
        : '${courseController.course.value?.name}';
  }

  // 리뷰 내용 업데이트 (간단하게 comment만 업데이트)
  void updateContent(String value) {
    reviewModel.value = reviewModel.value?.copyWith(comment: value);
    reviewModel.refresh(); // 상태를 반영하기 위해 refresh 호출
  }

  double calculateAveragePace(
      int totalTimeInSeconds, double totalDistanceInKm) {
    if (totalDistanceInKm == 0) return 0.0; // 거리가 0이면 0으로 반환
    double totalTimeInMinutes = totalTimeInSeconds / 60.0;
    return totalTimeInMinutes / totalDistanceInKm; // 분/킬로미터
  }

  // 이미지 선택 및 업로드 (간단하게 처리)
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
        // copyWith를 사용해 personalImage 업데이트
        reviewModel.value = reviewModel.value?.copyWith(
          personalImage: PersonalImage(
            url: uploadedImageUrl,
            path: selectedImage.value!.path,
          ),
        );
        reviewModel.refresh(); // 상태를 반영하기 위해 refresh 호출
        log('Success Image uploaded successfully: $uploadedImageUrl');
      }
    }
  }

  // 리뷰 등록 메서드
  Future<void> onRegisterTapped() async {
    try {
      if (reviewModel.value != null) {
        // TODO
        // 사진 넣어야 함
        // 리뷰 제출
        final response = await _service.submitReview(reviewModel.value!);
        log('${response.data["recordId"]}');

        Get.snackbar('Success', 'Review submitted successfully');

        try {
          final tempRecordId = '${response.data["recordId"]}';
          await _fileService.renameFile2(tempRecordId);

          log('Running session ended. Data saved as: $tempRecordId.json');
        } catch (e) {
          log('Error ending running session: $e');
          Get.snackbar(
            'Error',
            'Failed to save running record',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
        }

        Get.toNamed('/record/detail/${response.data["recordId"]}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review: $e');
      log('Error: $e');
    }
  }

  // 시간 계산 메서드
  String calculateTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double calculateCalorie() {
    return 2 * runningController.value.value.elapsedTime.inMinutes.toDouble();
  }
}
