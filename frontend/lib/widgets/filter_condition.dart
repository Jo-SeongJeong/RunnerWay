import 'package:frontend/controllers/location_controller.dart';
import 'package:frontend/controllers/main_controller.dart';
import 'package:frontend/controllers/runner_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/filter_controller.dart';

class FilterCondition extends StatelessWidget {
  final FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: contraints.maxWidth),
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 정렬 기준 버튼
                  Obx(
                    () => DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xff1C1516),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: ButtonTheme(
                          // padding: EdgeInsets.symmetric(vertical: 0),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            value: controller.sortCondition.value,
                            items: <String>['추천순', '인기순', '거리순']
                                .map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Color(0xffE8E8E8), fontSize: 14),
                                  ),
                                );
                              },
                            ).toList(),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xffE8E8E8),
                            ),
                            onChanged: (String? newCondition) {
                              controller.updateSortCondition(newCondition!);
                            },
                            dropdownColor: Color(0xff1C1516),
                            underline: Container(),
                            focusColor: Color(0xff1C1516),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  // 난이도 필터 버튼
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConditionDialog(
                            controller: controller,
                            conditionType: 'difficulty',
                          );
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xffe8e8e8).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '난이도',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.black),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  // 코스 거리 필터 버튼
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConditionDialog(
                            controller: controller,
                            conditionType: 'distance',
                          );
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xffe8e8e8).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '코스 거리',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.black),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // 남은 공간 차지 부분 처리
                  Flexible(
                    child: Container(), // Flexible로 남은 공간 처리
                  ),

                  // 현위치 불러오기 버튼
                  IconButton(
                    onPressed: () async {
                      // 현위치로 위치 정보 갱신
                      if (Get.currentRoute == '/main') {
                        await Get.find<LocationController>()
                            .getCurrentLocation();
                        Get.find<MainController>().fetchOfficialCourses();
                      } else
                        await Get.find<RunnerController>()
                            .updateCurrentLocation();
                    },
                    icon: Image.asset(
                      'assets/images/main/gps.png',
                      width: 28,
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

class ConditionDialog extends StatelessWidget {
  final FilterController controller;
  final String conditionType;

  ConditionDialog({required this.controller, required this.conditionType});

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = conditionType == 'difficulty'
        ? controller.difficultyLabels.keys.toList()
        : controller.lengthLabels.keys.toList();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        conditionType == 'difficulty' ? "난이도 선택" : " 코스 거리 선택",
        style: TextStyle(fontSize: 16),
      ),
      content: Container(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            return Obx(() {
              return CheckboxListTile(
                activeColor: Color(0xff1EA6FC),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                title: Text(conditionType == 'difficulty'
                    ? controller.difficultyLabels[item]!
                    : controller.lengthLabels[item]!),
                // 정렬 기준에 따라서 현재 value 설정
                value: conditionType == 'difficulty'
                    ? controller.selectedDifficulty.contains(item)
                    : controller.selectedLength.contains(item), // 상태 변화 감지
                onChanged: (bool? isChecked) {
                  if (isChecked == true) {
                    // 리스트에 값이 없는 경우 선택 추가
                    if (conditionType == 'difficulty') {
                      if (!controller.selectedDifficulty.contains(item)) {
                        controller.selectedDifficulty.add(item);
                      }
                    } else {
                      if (!controller.selectedLength.contains(item)) {
                        controller.selectedLength.add(item);
                      }
                    }
                  } else {
                    // 선택되어 있는 경우 선택 해제
                    if (conditionType == 'difficulty') {
                      controller.selectedDifficulty.remove(item);
                    } else {
                      controller.selectedLength.remove(item);
                    }
                  }
                },
              );
            });
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: TextStyle(color: Color(0xff1C1516)),
          ),
          onPressed: () {
            // 확인 버튼 클릭 시 필터 조건 업데이트 및 팝업 닫기
            controller.updateFilterCondition();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
