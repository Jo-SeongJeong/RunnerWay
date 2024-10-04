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
  final RunningReviewController controller = Get.put(RunningReviewController());

  ReviewWriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          '러닝 기록 작성',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: RegisterButton(
                onItemTapped: (int _) => controller.onRegisterTapped(),
              )
              // TODO
              // int로 반환값 있어서 위에 코드로 변경
              // child: RegisterButton(onItemTapped: controller.onRegisterTapped),
              ),
        ],
      ),
      body: Obx(() => Column(
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
                              address: controller
                                      .courseController.course.value?.address ??
                                  '미상',
                              time: controller.reviewModel.value!.startDate,
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: controller.pickImage,
                              child: controller.selectedImage.value != null
                                  ? Image.file(
                                      controller.selectedImage.value!,
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    )
                                  : Image.asset(
                                      'assets/images/review_default_image.png',
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
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
                                hintText: '리뷰를 작성해주세요...',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: controller.updateContent,
                              controller: TextEditingController(
                                text: controller.reviewModel.value!.comment,
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReviewRecordItem(
                                    value: controller
                                        .reviewModel.value!.runningDistance,
                                    label: '운동 거리'),
                                ReviewRecordItem(
                                    value: controller.reviewModel.value!.score,
                                    label: '운동 시간'),
                                ReviewRecordItem(value: 0, label: '러닝 경사도'),
                                ReviewRecordItem(
                                    value:
                                        controller.reviewModel.value!.calorie,
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
          )),
    );
  }
}
