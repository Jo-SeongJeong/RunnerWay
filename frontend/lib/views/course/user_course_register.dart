import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/user_course_controller.dart';
import 'package:get/get.dart';
import '../../controllers/record_controller.dart';
import '../../widgets/button/wide_button.dart';
import '../../widgets/map/result_map.dart';
import '../../widgets/review_record_item.dart';
import '../../widgets/review_info_item.dart';

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController reviewController =
      TextEditingController(); // 리뷰 입력 필드 추가
  final UserCourseController userCourseController =
      Get.put(UserCourseController());
  final RecordController recordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    final int recordId =
        int.tryParse(Get.parameters['id'] ?? '0') ?? 0; // URL에서 recordId 가져오기

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('러닝 코스 등록',
            style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obx로 감싸서 실시간 반응 처리
              Obx(
                () {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: courseNameController,
                        onChanged: (value) {
                          userCourseController.isButtonActive.value =
                              value.isNotEmpty;
                        },
                        decoration: InputDecoration(
                            labelText: '코스 이름을 입력해주세요',
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent))),
                        cursorColor: Colors.blueAccent,
                        cursorErrorColor: Colors.red,
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/images/review_default_image.png',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 28),
                      Text(
                        '러닝 리뷰',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: reviewController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                      SizedBox(height: 50),
                      recordController.isLoading.isTrue
                          ? Center(child: CircularProgressIndicator())
                          : recordController.recordDetail.value == null
                              ? Center(child: Text('No record data available'))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '기록 상세',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ReviewRecordItem(
                                          value: recordController.recordDetail
                                              .value!.runningDistance,
                                          label: '운동 거리',
                                        ),
                                        ReviewRecordItem(
                                          value: recordController
                                              .recordDetail.value!.courseId,
                                          label: '운동 시간',
                                        ),
                                        ReviewRecordItem(
                                          value: recordController
                                              .recordDetail.value!.courseId,
                                          label: '러닝 경사도',
                                        ),
                                        ReviewRecordItem(
                                          value: recordController.recordDetail
                                                  .value!.calorie ??
                                              0.0,
                                          label: '소모 칼로리',
                                        ),
                                      ],
                                    ),
                                    AbsorbPointer(
                                      absorbing: true,
                                      child: SizedBox(
                                        height: 300,
                                        child: const ResultMap(),
                                      ),
                                    ),
                                  ],
                                ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.all(20),
            child: WideButton(
              text: '유저 코스 등록',
              isActive: userCourseController.isButtonActive.value &&
                  recordController.recordDetail.value != null,
              onTap: userCourseController.isButtonActive.value &&
                      recordController.recordDetail.value != null
                  ? () async {
                      final record = recordController.recordDetail.value!;
                      log('$record');

                      // TODO 데이터 변경_ address lat lng 받아서 변경하기
                      userCourseController.addUserCourse({
                        'name': courseNameController.text,
                        'recordId': record.recordId ?? 0,
                        'address': '유성구',
                        'content': reviewController.text.isNotEmpty
                            ? reviewController.text
                            : '리뷰 없음', // 비어 있는 경우 기본 값 설정
                        'averageTime': record.startDate ?? '',
                        'courseLength': record.runningDistance,
                        'courseType': 'user',
                        'averageCalorie': record.calorie ?? 0.0,
                        'lat': 36.35498566873416,
                        'lng': 127.3008971772697,
                        'url':
                            'https://runnerway.s3.ap-northeast-2.amazonaws.com/test/test2.json',
                        'courseImage': {'url': 'test.url', 'path': 'test.path'},
                      });
                    }
                  : null,
            ),
          )),
    );
  }
}
