import 'package:flutter/material.dart';
import 'package:frontend/controllers/filter_controller.dart';
import 'package:frontend/controllers/runner_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:frontend/widgets/empty.dart';
import 'package:frontend/widgets/filter_condition.dart';
import 'package:frontend/widgets/search/search_read_only.dart';
import 'package:get/get.dart';

import '../../widgets/course/course_card.dart';

class RunnerView extends StatelessWidget {
  // 컨트롤러 인스턴스 생성
  final RunnerController runnerController = Get.put(RunnerController());
  final FilterController filterController = Get.find<FilterController>();
  final ScrollController _scrollController = ScrollController();

  RunnerView() {
    // filterTarget을 'runner'로 설정
    filterController.setFilterTarget('runner');

    _scrollController.addListener(() {
      // 스크롤 끝에 도달하면 데이터를 로드
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // 스크롤 끝에 도달했을 때 추가 데이터를 로드
        if (!runnerController.isLoading.value) {
          runnerController.loadMoreData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // 검색바
            SearchReadOnly(),
            SizedBox(height: 20),

            // '러너들의 추천 코스' 제목
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  '러너들의 ',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                Text(
                  '추천코스',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // 필터
            // TODO 픽셀 값 넘어감
            FilterCondition(),
            SizedBox(height: 25),

            // 러너 코스 리스트
            Expanded(
              child: Obx(
                () {
                  if (runnerController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!runnerController.isLoading.value &&
                      runnerController.runnerCourses.isEmpty) {
                    return Empty(mainContent: '러너 코스가 없어요');
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: runnerController.runnerCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(
                        course: runnerController.runnerCourses[index],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
