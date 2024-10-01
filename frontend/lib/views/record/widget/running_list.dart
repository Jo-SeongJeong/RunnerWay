import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/line.dart';

class RunningCard extends StatelessWidget {
  final String courseName;
  final double runningDistance;
  final String score;

  const RunningCard(
      {super.key,
      required this.courseName,
      required this.runningDistance,
      required this.score});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO 러닝 상세 기록 페이지 이동
        Get.toNamed('');
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 18),
        color: Colors.white,
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          courseName,
                          // '유성천 옆 산책로',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            // LevelBadge(level: course.level),
                            Text('level1'),
                            SizedBox(width: 10),
                            // if (course.courseType == 'user')
                            Row(
                              children: [
                                Text(
                                  '$score / ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$runningDistance km',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Icon(Icons.chevron_right_rounded)],
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '01:06:56 / ',
                      style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 14),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          '10km / ',
                          style:
                              TextStyle(color: Color(0xFFA0A0A0), fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          '6.22',
                          style:
                              TextStyle(color: Color(0xFFA0A0A0), fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
                Line(),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
