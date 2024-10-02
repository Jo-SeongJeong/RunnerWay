import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningCard extends StatelessWidget {
  final int courseId;
  final String courseName;
  final double runningDistance;
  final String score;
  final double averageFace;

  const RunningCard(
      {super.key,
      required this.courseId,
      required this.courseName,
      required this.runningDistance,
      required this.score,
      required this.averageFace});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 러닝 상세 기록 페이지 이동
        Get.toNamed('/record/detail/${courseId}');
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseName,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${score} / ',
                                  style: TextStyle(
                                      color: Color(0xFFA0A0A0), fontSize: 14),
                                ),
                                Text(
                                  '${runningDistance}km / ',
                                  style: TextStyle(
                                      color: Color(0xFFA0A0A0), fontSize: 14),
                                ),
                                Text(
                                  '${averageFace.truncate()}\' ${((averageFace ?? 0) * 100 % 100).toInt()}\"',
                                  style: TextStyle(
                                    color: Color(0xFFA0A0A0),
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xffF1F1F1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
