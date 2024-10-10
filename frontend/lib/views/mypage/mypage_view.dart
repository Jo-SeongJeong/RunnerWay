import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/jwt_controller.dart';
import 'package:frontend/controllers/user_course_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:frontend/widgets/line.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/modal/custom_modal.dart';

class MypageView extends StatelessWidget {
  MypageView({Key? key}) : super(key: key);
  final AuthController _authController = Get.put(AuthController());
  final JwtController jwtController = Get.put(JwtController());
  final UserCourseController _userCourseController =
      Get.put(UserCourseController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    _authController.fetchUserInfo();

    return BaseView(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          '마이페이지',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Obx(() {
                    String? profileImageUrl =
                        _authController.memberImage.value?.url;
                    return Container(
                      height: 119,
                      width: 119,
                      decoration: BoxDecoration(
                        color: Color(0xFFE4E4E4),
                        border: Border.all(color: Color(0xFFE4E4E4), width: 2),
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : AssetImage(
                                      'assets/images/auth/default_profile.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Obx(() => Text(
                    '${_authController.nickname.value}',
                    style: const TextStyle(
                      color: Color(0xFF1C1516),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ),
            SizedBox(height: 7),
            Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Color((0xFFA0A0A0)),
                      side: BorderSide(color: Color(0xFFA0A0A0)),
                      minimumSize: Size(screenWidth * 0.23, 32),
                      maximumSize: Size(screenWidth * 0.4, 40),
                      padding: EdgeInsets.only(left: 15, right: 15)),
                  onPressed: () {
                    _authController.logout();
                  },
                  child: Text(
                    "로그아웃",
                    style: TextStyle(fontSize: 13),
                  )),
            ),
            Line(),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '개인 상세 정보',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1EA6FC)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '생년월일',
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '키',
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '몸무게',
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '성별',
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        String formattedBirthDate = '';

                        if (_authController.birthDate.value != null &&
                            _authController.birthDate.value.isNotEmpty) {
                          try {
                            formattedBirthDate =
                                DateTime.parse(_authController.birthDate.value)
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                          } catch (e) {
                            formattedBirthDate = 'Invalid Date';
                          }
                        } else {
                          formattedBirthDate = '-';
                        }

                        return Text(
                          formattedBirthDate,
                          style: const TextStyle(
                            color: Color(0xFFA0A0A0),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                      SizedBox(height: 10),
                      Obx(() => Text(
                            _authController.height.value.isEmpty
                                ? '- cm'
                                : '${_authController.height.value} cm',
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      SizedBox(height: 10),
                      Obx(() => Text(
                            _authController.weight.value.isEmpty
                                ? '- kg'
                                : '${_authController.weight.value} kg',
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      SizedBox(height: 10),
                      Obx(() {
                        if (_authController.selectedGender.value == 0) {
                          return Text(
                            '여성',
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else if (_authController.selectedGender.value == 1) {
                          return Text(
                            '남성',
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else {
                          return Text('-');
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ));
  }
}
