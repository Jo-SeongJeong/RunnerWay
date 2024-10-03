import 'package:flutter/material.dart';
import 'package:frontend/controllers/course_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:frontend/views/course/widget/course_main_info.dart';
import 'package:frontend/views/course/widget/course_sub_info.dart';
import 'package:frontend/widgets/empty.dart';
import 'package:frontend/widgets/line.dart';
import 'package:frontend/widgets/ranking_card.dart';
import 'package:get/get.dart';

import '../../widgets/button/back_button.dart';

class CourseDetailView extends StatelessWidget {
  const CourseDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController courseController = Get.put(CourseController());
    courseController.onInit();

    return BaseView(
      child: SingleChildScrollView(
        // 뷰의 내용이 하단바에 가리지 않도록 padding 설정
        padding: EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Padding(
              padding: EdgeInsets.all(10),
              child: CustomBackButton(),
            ),

            // Course 상태에 따른 렌더링
            Obx(
              () {
                if (courseController.isDetailLoading.value ||
                    courseController.isRankingLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1C1516),
                    ),
                  );
                } else if (courseController.course.value != null) {
                  // API 데이터를 받아 위젯에 정보 표시
                  final course = courseController.course.value!;
                  final rankingList = courseController.ranking;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 코스 메인 정보 위젯
                      CourseMainInfo(
                        name: course.name,
                        content: course.content ?? '설명이 없는 코스입니다.',
                        address: course.address,
                        count: course.count,
                        type: course.courseType!,
                        nickName: course.memberNickname,
                      ),

                      // 구분선
                      Line(),

                      // 코스 랭킹 위젯
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Column(
                          children: [
                            Text(
                              '코스 랭킹 TOP 5',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      // 코스 랭킹 카드 List
                      // 랭킹이 있는지 여부에 따른 처리
                      rankingList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: rankingList.length,
                              itemBuilder: (context, index) {
                                final ranking = rankingList[index];
                                return RankingCard(
                                  name: ranking.member.nickname,
                                  time: ranking.score,
                                  imageUrl: ranking.member.memberImage?.url,
                                  rank: index + 1,
                                  isActive: true,
                                );
                              },
                            )
                          : Container(
                              padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                              child: Empty(mainContent: '등록된 랭킹이 없어요'),
                            ),

                      // 코스 상세 정보 위젯
                      CourseSubInfo(
                        level: course.level,
                        averageSlope: course.averageSlope,
                        courseLength: course.courseLength,
                        averageCalorie: course.averageCalorie,
                        averageTime: course.averageTime,
                        courseImage: course.courseImage,
                      ),
                    ],
                  );
                } else {
                  // 예외 상황 처리
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Empty(mainContent: '코스 정보를 불러올 수 없어요'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
