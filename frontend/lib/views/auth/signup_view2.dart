import 'package:flutter/material.dart';
import 'package:frontend/widgets/button/wide_button.dart';
import 'package:frontend/views/auth/widget/favorite_tag.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'dart:developer';

class SignUpView2 extends StatefulWidget {
  const SignUpView2({super.key});

  @override
  _SignUpView2State createState() => _SignUpView2State();
}

class _SignUpView2State extends State<SignUpView2> {
  final AuthController _authController = Get.put(AuthController());
  List<bool> selectedTags = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> favoriteTag = [];
  bool isAnyTagSelected = false;

  void handleTagTapped(int index, String tagName) {
    setState(() {
      selectedTags[index] = !selectedTags[index];

      if (selectedTags[index]) {
        favoriteTag.add(tagName);
      } else {
        favoriteTag.remove(tagName);
      }
      isAnyTagSelected = favoriteTag.isNotEmpty;
      log('태그: $tagName, 선택 상태: ${selectedTags[index]}');
      log('선택된 태그 리스트: $favoriteTag');
    });
  }

  Future<void> submitFavoriteTags() async {
    try {
      await _authController.sendFavoriteTag(favoriteTag);
    } catch (e) {
      log('태그 전송 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 106),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.asset('assets/images/auth/signup_course.png'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '평소에 선호하는',
                    style: TextStyle(
                      color: Color(0xFF1C1516),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '러닝 코스 태그를 골라주세요',
                    style: TextStyle(
                      color: Color(0xFF1C1516),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '러너분께 맞는 러닝 코스를 추천해드려요',
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // FavoriteTag 들어가자
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FavoriteCourses(
                            text: '오르막길이 많은',
                            imagePath: 'assets/images/auth/uphill.png',
                            onItemTapped: (text) {
                              handleTagTapped(0, text);
                            },
                          ),
                          SizedBox(width: 10),
                          FavoriteCourses(
                            text: '내리막길이 많은',
                            imagePath: 'assets/images/auth/downhill.png',
                            onItemTapped: (text) {
                              handleTagTapped(1, text);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FavoriteCourses(
                            text: '평지 중심 코스',
                            imagePath: 'assets/images/auth/road.png',
                            onItemTapped: (text) {
                              handleTagTapped(2, text);
                            },
                          ),
                          SizedBox(width: 10),
                          FavoriteCourses(
                            text: '강가 근처 코스',
                            imagePath: 'assets/images/auth/creek.png',
                            onItemTapped: (text) {
                              handleTagTapped(3, text);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FavoriteCourses(
                            text: '접근성이 좋은',
                            imagePath: 'assets/images/auth/city.png',
                            onItemTapped: (text) {
                              handleTagTapped(4, text);
                            },
                          ),
                          SizedBox(width: 10),
                          FavoriteCourses(
                            text: '해안가 근처 코스',
                            imagePath: 'assets/images/auth/beach.png',
                            onItemTapped: (text) {
                              handleTagTapped(5, text);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FavoriteCourses(
                            text: '자전거 도로와 함께하는',
                            imagePath: 'assets/images/auth/bicycle.png',
                            onItemTapped: (text) {
                              handleTagTapped(6, text);
                            },
                          ),
                          SizedBox(width: 10),
                          FavoriteCourses(
                            text: '사람 적은',
                            imagePath: 'assets/images/auth/less.png',
                            onItemTapped: (text) {
                              handleTagTapped(7, text);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: WideButton(
          text: '확인',
          isActive: isAnyTagSelected,
          onTap: isAnyTagSelected
              ? () async {
                  await submitFavoriteTags(); // 태그 전송 함수 호출
                }
              : null,
        ),
      ),
    );
  }
}
