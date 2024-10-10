import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/course_controller.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/widgets/course/level_badge.dart';
import 'package:get/get.dart';

import '../../views/course/widget/course_map.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context, Offset position, double screenWidth,
      double screenHeight) {
    // 팝업 크기 설정
    double popupWidth = screenWidth * 3 / 4;
    double popupHeight = 280; // 예시로 설정한 높이

    // 화면 경계를 넘지 않도록 조정
    double leftPosition = position.dx;
    double topPosition = position.dy;

    // 오른쪽으로 넘지 않도록 처리
    if (leftPosition + popupWidth > screenWidth) {
      leftPosition = screenWidth - popupWidth - 20; // 오른쪽 경계에서 20px 여유를 둠
    }

    // 아래쪽으로 넘지 않도록 처리
    if (topPosition + popupHeight > screenHeight) {
      topPosition = screenHeight - popupHeight - 40; // 아래쪽 경계에서 40px 여유를 둠
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // 조정된 position 값을 사용해 팝업 위치 설정
        top: topPosition,
        left: leftPosition,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffA8A8A8).withOpacity(0.25),
                  blurRadius: 12,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            width: popupWidth,
            height: popupHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'preview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CourseMap(
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final CourseController courseController = Get.put(CourseController());

    return GestureDetector(
      onTap: () {
        // 코스 카드 클릭 시 상세 페이지로 이동
        Get.toNamed('/course/${course.courseType}/${course.courseId}');
      },
      onLongPressStart: (LongPressStartDetails details) {
        // 길게 누르기 시작할 때 클릭 위치에 오버레이로 팝업 띄우기
        courseController.fetchCoursePoints(course.courseId);
        _showOverlay(
            context, details.globalPosition, screenWidth, screenHeight);
      },
      onLongPressEnd: (_) {
        // 길게 누르기를 끝낼 때 팝업 닫기
        _removeOverlay();
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 18),
        color: Colors.white,
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 코스 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: course.courseImage?.url != null &&
                      course.courseImage!.url.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: course.courseImage!.url,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ), // 로딩 중
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/main/course_default.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/main/course_default.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
            ),

            // 코스 이미지와 내용 사이 여백
            SizedBox(
              width: 15,
            ),

            // 코스 내용
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 코스 제목과 거리 정보
                  Row(
                    children: [
                      // 코스 제목
                      Text(
                        course.name,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      // 거리 정보
                      Text(
                        '${(course.courseLength * 10).round() / 10} km',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffA0A0A0),
                        ),
                      ),
                    ],
                  ),

                  // level 뱃지
                  Row(
                    children: [
                      LevelBadge(level: course.level),
                      SizedBox(
                        width: 10,
                      ),
                      if (course.courseType == 'user')
                        Row(
                          children: [
                            Text(
                              'course by. ',
                              style: TextStyle(
                                  fontFamily: 'playball', fontSize: 18),
                            ),
                            Text('${course.memberNickname}'),
                          ],
                        )
                    ],
                  ),

                  // 위치 정보 및 참여자수 정보
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/picker.png',
                              width: 14,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            // LayoutBuilder로 남은 너비 계산 후 주소 텍스트 표시
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // 주소 부분은 남은 공간만큼 사용하고 나머지는 줄임표(...) 처리
                                  return Text(
                                    '${course.address}',
                                    style: TextStyle(
                                      color: Color(0xffA0A0A0),
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // 너무 길면 "..."으로 표시
                                    maxLines: 1, // 한 줄로만 표시
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 6, // 주소와 참여자 수 사이의 여백을 5로 설정
                            ),
                          ],
                        ),
                      ),
                      // 참여자 수 부분은 고정된 크기로 처리
                      if (course.count > 0)
                        Text(
                          '${course.count}명 참여 중',
                          style: TextStyle(
                            color: Color(0xff1EA6FC),
                            fontSize: 14,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
