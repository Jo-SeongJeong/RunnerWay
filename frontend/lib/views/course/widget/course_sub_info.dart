import 'package:flutter/material.dart';
import 'package:frontend/widgets/course/level_badge.dart';

import '../../../models/course_image.dart';
import 'course_map.dart';

class CourseSubInfo extends StatelessWidget {
  final int level;
  final double? averageSlope;
  final double? averageCalorie;
  final double courseLength;
  final String? averageTime;
  final CourseImage? courseImage;

  CourseSubInfo({
    required this.level,
    double? this.averageSlope,
    required this.courseLength,
    double? this.averageCalorie,
    String? this.averageTime,
    CourseImage? this.courseImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 코스 상세 정보
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            '코스 상세 정보',
            style: TextStyle(fontSize: 16),
          ),
        ),

        // 코스 보여주기
        CourseMap(
          height: 300,
        ),

        // 기타 상세 코스 정보
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 난이도, 경사도, 거리 등의 글씨 정보
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 난이도 뱃지
                  LevelBadge(level: level),
                  SizedBox(
                    height: 15,
                  ),

                  // 경사도 정보
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/scope.png',
                        height: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${averageSlope} %',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 코스 거리
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/road.png',
                        height: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        // 소수점 한자리까지 반올림
                        '${(courseLength * 10).round() / 10} km',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 예상 시간
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/calorie.png',
                        height: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        // 반올림
                        '${averageCalorie?.round()} kcal ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 코스 예상 소요 시간
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/clock.png',
                        height: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        // TODO: 시간 데이터 수정 필요
                        '${averageTime?.substring(11)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),

              //  코스 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: courseImage?.url != null && courseImage!.url.isNotEmpty
                    ? Image.network(
                        courseImage!.url,
                        errorBuilder: (context, error, stackTree) {
                          // 이미지 로드 중 에러 발생 시 기본 이미지 표시
                          return Image.asset(
                            'assets/images/main/course_default.png',
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/main/course_default.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
