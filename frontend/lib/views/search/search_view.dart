import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/controllers/under_bar_controller.dart';
import 'package:frontend/views/main/widget/auto_complete.dart';
import 'package:frontend/views/search/widget/search_bar.dart';
import 'package:frontend/views/search/widget/search_prompt.dart';
import 'package:frontend/views/search/widget/search_result.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/search_controller.dart';
import '../base_view.dart';

class SearchView extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  final UnderBarController underBarController = Get.find<UnderBarController>();

  @override
  Widget build(BuildContext context) {
    // 검색 뷰 빌드 후 메인 언더바 탭 활성화
    Future.microtask(() => underBarController.changeTabIndex(0));

    final searchController = Get.put(SearchBarController());

    // 쿼리 파라미터 가져오기
    final searchQuery = Get.parameters['query'];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // 빌드가 완료된 후에 검색 결과 API 요청
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchController.fetchSearchResults(searchQuery);
      });
    }

    // 검색 화면에 맞는 위젯을 child로 설정
    Widget searchContent = Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 검색바
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  log('뒤로가기 버튼');
                  searchController.clearSearch();
                  Get.toNamed('/main');
                },
                child: Image.asset(
                  'assets/icons/back2.png',
                  width: 14,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: CourseSearchBar(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          // 검색 쿼리 인식 전 (사용자가 검색 중인 상태)
          searchQuery == null || searchQuery.isEmpty
              ? Obx(
                  () => searchController.searchText.isEmpty
                      // 검색어 입력 전
                      ? SearchPrompt()
                      // 검색어가 있는 경우, 검색어 자동 완성 리스트
                      : searchController.suggestions.isNotEmpty
                          ? AutoCompleteList()
                          : Container(),
                )
              // 검색 결과 화면
              : SearchResult(),
        ],
      ),
    );

    // 검색 결과 화면일 때만 하단바 있는 BaseView 사용
    return searchQuery != null && searchQuery.isNotEmpty
        ? BaseView(child: searchContent) // 검색 결과 화면일 경우 BaseView로 감싸서 하단바 표시
        : Scaffold(body: searchContent); // 그 외의 경우는 그냥 Scaffold로 표시
  }
}
