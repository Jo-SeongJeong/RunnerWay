import 'package:flutter/material.dart';
import 'package:frontend/controllers/running_controller.dart';
import 'package:frontend/views/running/widgets/write_map.dart';
import 'package:get/get.dart';
import '../../widgets/button/register_button.dart';
import '../../widgets/map/result_map.dart';
import '../../widgets/review_record_item.dart';
import '../../widgets/review_info_item.dart';
import 'package:frontend/controllers/review_write_controller.dart';

class ReviewWriteView extends StatelessWidget {
  ReviewWriteView({super.key});

  final RunningReviewController controller = Get.put(RunningReviewController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) {
            Get.toNamed('/runner');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: const Text(
              '러닝 기록 작성',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            leading: IconButton(
                onPressed: () {
                  Get.toNamed('/runner');
                },
                icon: Icon(Icons.arrow_back)),
            backgroundColor: Colors.white,
            toolbarHeight: 56,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Obx(() {
                  if (controller.isImageUploading.value) {
                    return Center(
                      child: Text(
                        '이미지 업로드 중',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                        onTap: () => controller.onRegisterTapped(),
                        child: RegisterButton(
                          onItemTapped: (int _) =>
                              controller.onRegisterTapped(),
                        ));
                  }
                }),
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              // 로딩 중일 때 CircularProgressIndicator 표시
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xff1C1516),
                ),
              );
            } else {
              // 로딩이 완료되면 실제 컨텐츠 표시
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0), //
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LocationInfo(
                                  title: controller.name.value,
                                  address: (controller
                                                  .reviewModel.value!.address ==
                                              null ||
                                          controller.reviewModel.value!.address
                                              .isEmpty)
                                      ? '주소 정보 없음'
                                      : controller.reviewModel.value!.address,
                                  time: controller.reviewModel.value!.startDate,
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: controller.pickImage,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.3,
                                        width: screenWidth,
                                        child: controller.selectedImage.value !=
                                                null
                                            ? Image.file(
                                                controller.selectedImage.value!,
                                                fit: BoxFit.cover,
                                                height: 200,
                                                width: double.infinity,
                                              )
                                            : Center(
                                                child: Image.asset(
                                                  'assets/images/main/course_default.png',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                      if (controller.selectedImage.value ==
                                          null)
                                        Positioned(
                                          bottom: screenHeight * 0.1,
                                          right: screenWidth / 2 - 83,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Color(0xFF1EA6FC),
                                            child: Icon(
                                              Icons.add,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                const Text(
                                  '러닝 리뷰',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    hintText: '리뷰를 작성해주세요',
                                    filled: true,
                                    fillColor: Color(0xFFE3E5E5),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  maxLength: 300,
                                  cursorColor: Colors.blueAccent,
                                  onChanged: controller.updateContent,
                                  controller: controller.commentController,
                                ),
                                const SizedBox(height: 50),
                                const Text(
                                  '기록 상세',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ReviewRecordItem(
                                        value: controller
                                            .reviewModel.value!.runningDistance,
                                        label: '운동 거리'),
                                    ReviewRecordItem(
                                        value:
                                            controller.reviewModel.value!.score,
                                        label: '운동 시간'),
                                    ReviewRecordItem(value: 0, label: '러닝 경사도'),
                                    ReviewRecordItem(
                                        value: controller
                                            .reviewModel.value!.calorie,
                                        label: '소모 칼로리'),
                                  ],
                                ),
                                const SizedBox(height: 44),
                              ],
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              height: 300,
                              child: WriteMap(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ));
  }
}
