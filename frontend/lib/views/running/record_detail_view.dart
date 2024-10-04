import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/record.dart';
import 'package:get/get.dart';
import '../../controllers/record_controller.dart';
import '../../widgets/map/result_map.dart';
import '../../widgets/review_info_item.dart';
import '../../widgets/review_record_item.dart';

class RecordDetailView extends StatelessWidget {
  RecordDetailView({super.key});

  final List<num> records = const [10, 4016, 67, 480];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final RecordController recordController = Get.find<RecordController>();

    log('parameter : ${Get.parameters['id']}');
    final int recordId = int.tryParse(Get.parameters['id'] ?? '0') ?? 0;

    // ID가 유효한 경우에만 fetchRecordDetail 호출
    if (recordId != 0) {
      recordController.fetchRecordDetail(recordId);
    } else {
      print("Error: Record ID is 0");
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('', style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (recordController.isLoading.isTrue) {
            return Center(child: CircularProgressIndicator());
          }

          if (recordController.recordDetail.value == null) {
            return Center(child: Text('No record data available'));
          }

          final record = recordController.recordDetail.value!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationInfo(
                  title: record.courseName,
                  address: '',
                  time: DateTime.parse(record.startDate ?? ''),
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
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditReviewModal(context, record);
                  },
                ),
                SizedBox(height: 16),
                Text(
                  (record.comment?.isNotEmpty ?? false)
                      ? record.comment!
                      : '리뷰 없음',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffA0A0A0),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '기록 상세',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 44),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReviewRecordItem(
                      value: record.runningDistance,
                      label: '운동 거리',
                    ),
                    ReviewRecordItem(
                      value: record.courseId, // 운동 시간 값으로 수정 필요
                      label: '운동 시간',
                    ),
                    ReviewRecordItem(
                      value: record.courseId, // 경사도 값으로 수정 필요
                      label: '러닝 경사도',
                    ),
                    ReviewRecordItem(
                      value: record.calorie ?? 0.0,
                      label: '소모 칼로리',
                    ),
                  ],
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: SizedBox(height: 300, child: const ResultMap()),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: Obx(() => Visibility(
            visible: recordController.recordDetail.value?.courseId == 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Get.toNamed('/register/$recordId');
                  },
                  label: Text(
                    '유저 코스 등록',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  icon: Container(),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showEditReviewModal(BuildContext context, Record record) {
    final RecordController recordController = Get.find<RecordController>();
    TextEditingController _reviewController = TextEditingController(
      text: record.comment ?? '', // 기존 리뷰를 TextField에 미리 넣음
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 padding 추가
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '리뷰 수정',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '리뷰를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('취소'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String updatedComment = _reviewController.text;
                      if (updatedComment.isNotEmpty) {
                        Record updatedRecord =
                            record.copyWith(comment: updatedComment);
                        Map<String, dynamic> updateData = {
                          'recordId': updatedRecord.recordId, // recordId
                          'comment': updatedComment,
                        };
                        recordController.patchRecord(updateData);
                        Get.back(); // 모달 닫기
                        Get.snackbar('성공', '리뷰가 수정되었습니다.');
                      }
                    },
                    child: Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
