import 'package:flutter/material.dart';
import 'package:frontend/controllers/runner_pick_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:frontend/widgets/button/back_button.dart';
import 'package:frontend/widgets/empty.dart';
import 'package:get/get.dart';

import '../../widgets/course/course_card.dart';

class RunnerPickView extends StatelessWidget {
  const RunnerPickView({super.key});

  @override
  Widget build(BuildContext context) {
    final RunnerPickController runnerPickController =
        Get.put(RunnerPickController());

    return BaseView(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 러너들의 Pick AppBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 뒤로가기
                CustomBackButton(),

                // title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '러너들의 ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Pick',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'playball',
                      ),
                    )
                  ],
                ),

                // 현위치 불러오기 버튼
                IconButton(
                  onPressed: () async {
                    // 현위치로 위치 정보 갱신
                    runnerPickController.onInit();
                  },
                  icon: Image.asset(
                    'assets/images/main/gps.png',
                    width: 24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),

            // 러너픽 페이지 content
            // 가장 인기 많은 코스
            Text(
              '가장 인기 많은 코스',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              // 로딩 상태일 때
              if (runnerPickController.isMostPickLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              // 로딩이 완료되었으나 데이터가 없을 때
              if (runnerPickController.mostPickCourses.isEmpty &&
                  !runnerPickController.isMostPickLoading.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Empty(mainContent: '인기 코스가 없어요'),
                );
              }

              // 코스가 있을 때 ListView.builder로 출력
              return ListView.builder(
                shrinkWrap: true, // SingleChildScrollView 안에서 스크롤 설정
                physics: NeverScrollableScrollPhysics(), // 충돌 방지
                itemCount: runnerPickController.mostPickCourses.length,
                itemBuilder: (context, index) {
                  final course = runnerPickController.mostPickCourses[index];
                  return CourseCard(course: course); // CourseCard를 보여줌
                },
              );
            }),
            SizedBox(
              height: 20,
            ),

            // 최근 인기 많은 코스
            Text(
              '최근 인기 많은 코스',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              // 로딩 상태일 때
              if (runnerPickController.isRecentPickLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              // 로딩이 완료되었으나 데이터가 없을 때
              if (runnerPickController.mostPickCourses.isEmpty &&
                  !runnerPickController.isMostPickLoading.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Empty(mainContent: '최근 인기 코스가 없어요'),
                );
              }

              // 코스가 있을 때 ListView.builder로 출력
              return ListView.builder(
                shrinkWrap: true, // SingleChildScrollView 안에서 스크롤 설정
                physics: NeverScrollableScrollPhysics(), // 충돌 방지
                itemCount: runnerPickController.mostPickCourses.length,
                itemBuilder: (context, index) {
                  final course = runnerPickController.mostPickCourses[index];
                  return CourseCard(course: course); // CourseCard를 보여줌
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
