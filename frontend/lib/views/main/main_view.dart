import 'package:flutter/material.dart';
import 'package:frontend/controllers/location_controller.dart';
import 'package:frontend/widgets/button/scroll_to_top_button.dart';
import 'package:frontend/widgets/course/course_card.dart';
import 'package:frontend/widgets/empty.dart';
import 'package:frontend/widgets/filter_condition.dart';
import 'package:frontend/widgets/search/search_read_only.dart';
import 'package:get/get.dart';
import '../../controllers/filter_controller.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/under_bar_controller.dart';
import '../base_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // filtercontroller 먼저 등록
  final LocationController locationController = Get.find<LocationController>();
  final FilterController filterController = Get.put(FilterController());
  final MainController mainController = Get.put(MainController());
  final UnderBarController underBarController = Get.find<UnderBarController>();

  ScrollController _scrollController = ScrollController();
  bool _isBannerVisible = true;
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 언더바 인덱스 업데이트
    Future.microtask(() => underBarController.changeTabIndex(0));

    // 메인 view에서 필터 타겟을 main으로 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterController.setFilterTarget('main');
    });

    // ScrollController의 리스너 설정
    _scrollController.addListener(() {
      // 스크롤 위치가 150을 넘으면 배너 숨기기
      if (_scrollController.position.pixels > 150) {
        if (_isBannerVisible) {
          setState(() {
            _isBannerVisible = false;
          });
        }
      } else {
        if (!_isBannerVisible) {
          setState(() {
            _isBannerVisible = true;
          });
        }
      }

      // 스크롤이 어느 정도 내려가면 '맨 위로 가기' 버튼 보이기
      if (_scrollController.position.pixels > 300) {
        if (!_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = true;
          });
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = mainController.filteredCourses;

    return Scaffold(
      body: BaseView(
        child: Column(
          children: [
            // SearchBar
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SearchReadOnly(),
                  SizedBox(height: 5),
                ],
              ),
            ),

            // Runner들의 Pick 배너
            if (_isBannerVisible)
              Container(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/runner-pick');
                  },
                  child: Stack(
                    children: [
                      // 클릭시 러너픽 페이지로 이동
                      Positioned(
                        child: Image.asset(
                          'assets/images/main/running.png',
                        ),
                      ),

                      Positioned(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '러너들의 ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Pick ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'playball',
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '우리 동네 러너들에게',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '인기있는 코스를 즐겨보세요 !',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            // 오늘의 추천 코스 container
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_isBannerVisible)
                      SizedBox(
                        height: 20,
                      ),
                    // title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '러너웨이 공식 ',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 22),
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

                    // 검색 조건 위젯
                    SizedBox(height: 15),
                    // TODO 여기 부분 픽셀 넘어감
                    FilterCondition(),

                    // 메인 화면 추천 코스 리스트
                    SizedBox(height: 25),
                    Expanded(
                      child: Obx(
                        () {
                          if (mainController.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (mainController.courses.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Empty(
                                  mainContent: '추천 코스가 없어요',
                                ),
                                SizedBox(
                                  height: 110,
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: results.length + 1,
                            itemBuilder: (context, index) {
                              if (index == results.length) {
                                return SizedBox(
                                  height: 100,
                                );
                              }
                              return CourseCard(course: results[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 스크롤 시 '맨 위로' 버튼 표시
      floatingActionButton: ScrollToTopButton(
        scrollController: _scrollController,
        showScrollToTopButton: _showScrollToTopButton,
      ),
    );
  }
}
