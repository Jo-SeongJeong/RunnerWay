import 'package:flutter/material.dart';
import 'package:frontend/widgets/course/level_badge.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/line.dart';

class RunningCard extends StatelessWidget {
  final String courseName;
  final double runningDistance;
  final String score;
  final double averageFace;

  const RunningCard(
      {super.key,
      required this.courseName,
      required this.runningDistance,
      required this.score,
      required this.averageFace});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO 러닝 상세 기록 페이지 이동
        Get.toNamed('');
      },
      child: Card(
        // margin: EdgeInsets.only(bottom: 18),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            courseName,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Icon(Icons.chevron_right_rounded)],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        '${score} / ',
                        style:
                            TextStyle(color: Color(0xFFA0A0A0), fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text(
                            '${runningDistance}km / ',
                            style: TextStyle(
                                color: Color(0xFFA0A0A0), fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${averageFace.truncate()}\' ${((averageFace ?? 0) * 100 % 100).toInt()}\"',
                            style: TextStyle(
                                color: Color(0xFFA0A0A0), fontSize: 14),
                          )
                        ],
                      ),
                    ],
                  ),
                  Line(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
