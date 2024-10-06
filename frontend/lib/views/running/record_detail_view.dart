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
    final double screenHeight = MediaQuery.of(context).size.height;
    final RecordController recordController = Get.find<RecordController>();

    log('parameter : ${Get.parameters['id']}');
    final int recordId = int.tryParse(Get.parameters['id'] ?? '0') ?? 0;

    recordController.fetchRecordDetail(recordId);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('', style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
      ),
      body: Container(
        // padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (recordController.isLoading.isTrue) {
            return Center(child: CircularProgressIndicator());
          }

          if (recordController.recordDetail.value == null) {
            return Center(child: Text('기록없음'));
          }

          final record = recordController.recordDetail.value!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LocationInfo(
                    title: record.courseName,
                    address: (record.address == null || record.address!.isEmpty)
                        ? '주소 정보 없음'
                        : record.address!,
                    time: DateTime.parse(record.startDate ?? ''),
                  ),
                ),
                SizedBox(height: 20),
                // Image.asset(
                //   'assets/images/review_default_image.png',
                //   fit: BoxFit.cover,
                // ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 0.2,
                        child: record.url != null && record.url!.isNotEmpty
                            ? Image.network(
                                record.url!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // 이미지 로드 중 에러 발생 시 기본 이미지 표시
                                  return Container(
                                    height: screenHeight * 0.2,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/main/course_default.png',
                                        width: 80, // 이미지 너비를 80으로 설정
                                        height: 80, // 이미지 높이를 80으로 설정
                                        fit: BoxFit
                                            .cover, // 이미지를 Container 안에 맞게 조정
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: screenHeight * 0.2,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/main/course_default.png',
                                    width: 80, // 이미지 너비를 80으로 설정
                                    height: 80, // 이미지 높이를 80으로 설정
                                    fit:
                                        BoxFit.cover, // 이미지를 Container 안에 맞게 조정
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 28),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '러닝 리뷰',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                            onPressed: () {
                              _showEditReviewModal(context, record);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ReviewRecordItem(
                            value: record.runningDistance ?? 0.0,
                            label: '운동 거리',
                          ),
                          ReviewRecordItem(
                            value: (record.finishDate != null &&
                                    record.startDate != null)
                                ? DateTime.parse(record.finishDate!)
                                    .difference(
                                        DateTime.parse(record.startDate!))
                                    .inSeconds // 초 단위로 계산하여 전달
                                : 0,
                            label: '운동 시간',
                          ),
                          ReviewRecordItem(
                            value: recordController
                                    .courseDetail.value?.averageSlope ??
                                0.0,
                            label: '러닝 경사도',
                          ),
                          ReviewRecordItem(
                            value: record.calorie ?? 0.0,
                            label: '소모 칼로리',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: SizedBox(height: 300, child: const ResultMap()),
                ),
                SizedBox(height: 80),
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
      text: record.comment ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라올 때 스크롤되도록 설정
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드와 충돌 방지
          ),
          child: SizedBox(
            height: 250, // TODO 모달 높이 _ 반응형으로 추후 변경
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white, // 배경색
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 30, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      '러닝 리뷰',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _reviewController,
                          maxLines: 5, // 최대 5줄까지 입력 가능하게 둠
                          maxLength: 200,
                          style: TextStyle(
                            color: Color(0xFF72777A),
                          ),
                          decoration: InputDecoration(
                            hintText: '러너웨이와 함께 달리기를 마치셨네요.\n오늘을 기억하며 기록해보세요.',
                            hintStyle: TextStyle(
                                color: Color(0xFF72777A),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
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
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFFA0A0A0),
                          ),
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            String updatedComment = _reviewController.text;
                            if (updatedComment.isNotEmpty) {
                              Record updatedRecord =
                                  record.copyWith(comment: updatedComment);
                              Map<String, dynamic> updateData = {
                                'recordId': updatedRecord.recordId,
                                'comment': updatedComment,
                              };
                              recordController.patchRecord(updateData);
                              Get.back();
                            }
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF1EA6FC)),
                          child: Text('저장'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
