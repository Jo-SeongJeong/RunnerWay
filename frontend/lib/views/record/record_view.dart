import 'package:flutter/material.dart';
import 'package:frontend/controllers/record_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/button/back_button.dart';
import 'package:intl/intl.dart';
import 'package:frontend/views/record/widget/running_list.dart';
import '../../widgets/line.dart';
import 'widget/calendar.dart';

class RecordView extends StatefulWidget {
  const RecordView({super.key});

  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  DateTime? selectedDate;
  final RecordController _recordController = Get.put(RecordController());

  @override
  Widget build(BuildContext context) {
    return BaseView(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '30.2',
                style: TextStyle(
                    color: Color(0xFF1C1516),
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 3),
              Text(
                '이번 달 러닝 km',
                style: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '08’47”',
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '12:06:56',
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '2358',
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
              ),
              SizedBox(height: 10),
              Line(),
              SizedBox(height: 10),
              Calendar(
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
              Line(),
              // 클릭 날짜
              if (selectedDate != null) ...[
                Row(
                  children: [
                    // SizedBox(width: 18),
                    // 날짜 불러오기
                    Text(
                      'TUE',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1EA6FC)),
                    ),
                    SizedBox(width: 10),
                    Text(
                      DateFormat('dd').format(selectedDate!),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1EA6FC)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 러닝 카드 들어갈 곳
                Obx(() {
                  if (_recordController.isLoading.value) {
                    return CircularProgressIndicator();
                  }
                  if (_recordController.records.isEmpty) {
                    return Text("기록 없어");
                  }
                  return Column(
                    children: _recordController.records
                        .map((record) => RunningCard(
                              courseName: record.courseName,
                              runningDistance: record.runningDistance,
                              score: record.score,
                            ))
                        .toList(),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    ));
  }
}
