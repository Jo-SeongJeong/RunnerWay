import 'package:flutter/material.dart';
import 'package:frontend/controllers/record_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:frontend/widgets/empty.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/button/back_button.dart';
import 'package:intl/intl.dart';
import 'package:frontend/views/record/widget/running_list.dart';
import '../../widgets/line.dart';
import 'widget/calendar.dart';

class RecordView extends StatelessWidget {
  const RecordView({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX로 컨트롤러 등록
    final RecordController _recordController = Get.put(RecordController());

    var isMonthLoading = _recordController.isMonthRecordLoading;

    return PopScope(
      onPopInvokedWithResult: (popType, result) async {
        // 뷰가 사라질 때 컨트롤러 삭제
        Get.delete<RecordController>();
      },
      child: BaseView(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              CustomBackButton(),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '러닝 기록',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 48,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          Obx(
                            () {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image.asset(
                                    'assets/icons/black_run_shoe.png',
                                    width: 50,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '러닝 키로수',
                                        style: TextStyle(
                                          color: Color(0xFFA0A0A0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        isMonthLoading.value
                                            ? '-'
                                            : '${_recordController.monthRecords.value?.totalDistance} km',
                                        style: TextStyle(
                                            color: Color(0xFF1C1516),
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 20),

                          Obx(
                            () {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_recordController.monthRecords.value?.averageFace.truncate()}\' ${((_recordController.monthRecords.value?.averageFace ?? 0) * 100 % 100).toInt()}\"',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '평균 페이스',
                                          style: TextStyle(
                                              color: Color(0xFFA0A0A0),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_recordController.monthRecords.value?.totalScore}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '러닝 시간',
                                          style: TextStyle(
                                              color: Color(0xFFA0A0A0),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_recordController.monthRecords.value?.totalCalorie.toInt()}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '칼로리',
                                          style: TextStyle(
                                              color: Color(0xFFA0A0A0),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 10),
                          Line(),
                          SizedBox(height: 10),
                          // 날짜 선택 Calendar (GetX로 상태 관리)
                          Calendar(),

                          Line(),
                          // 클릭 날짜
                          // 클릭된 날짜에 따른 결과
                          Obx(() {
                            final selectedDate =
                                _recordController.selectedDate.value;
                            if (selectedDate != null) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        DateFormat('EEE').format(selectedDate),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1EA6FC)),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        DateFormat('dd').format(selectedDate),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1EA6FC)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  // 기록에 따른 RunningCard 표시
                                  if (_recordController
                                      .isDayRecordLoading.value)
                                    CircularProgressIndicator()
                                  else if (_recordController.dayRecords.isEmpty)
                                    // 기록 empty state 처리
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Empty(mainContent: '기록이 없습니다'),
                                    )
                                  else
                                    Column(
                                      children: [
                                        ..._recordController.dayRecords
                                            .map(
                                              (record) => RunningCard(
                                                recordId: record.recordId,
                                                courseId: record.courseId,
                                                courseName: record.courseName,
                                                runningDistance:
                                                    record.runningDistance,
                                                score: record.score,
                                                averageFace: record.averageFace,
                                              ),
                                            )
                                            .toList(),
                                        // 여기서 SizedBox를 추가합니다.
                                        SizedBox(height: 80),
                                      ],
                                    ),
                                ],
                              );
                            }
                            return Container();
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
