import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/button/wide_button.dart';
import 'package:frontend/widgets/modal/birth_modal.dart';
import 'package:frontend/views/auth/widget/signup_input.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/models/auth.dart';

class SignUpView extends StatelessWidget {
  final String email;

  const SignUpView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find<AuthController>();
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          '회원가입',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 56,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              // 회원가입 유저 이미지
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _authController.pickImage,
                    child: Obx(
                      () => ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: _authController.selectedImage.value != null
                            ? Image.file(
                                _authController.selectedImage.value!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/auth/default_profile.png',
                                width: 90,
                                height: 90,
                              ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '닉네임',
                    style: TextStyle(
                      color: Color(0xFF1C1516),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        if (text.characters.length > 8) {
                          _authController.nickname.value =
                              text.characters.take(8).toString();
                        } else {
                          _authController.nickname.value = text;
                        }
                        _authController
                            .onNicknameChanged(_authController.nickname.value);
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        filled: true,
                        hintText: '닉네임 (2~8자)',
                        hintStyle: TextStyle(
                          color: Color(0xFF72777A),
                        ),
                        fillColor: Color(0xFFE3E5E5).withOpacity(0.4),
                      ),
                      cursorColor: Colors.blueAccent,
                      cursorErrorColor: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    '생년월일',
                    style: TextStyle(
                      color: Color(0xFF1C1516),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              BirthModal(
                onChanged: (selectedDate) {
                  log('선택된 날짜 : $selectedDate');
                  _authController.birthDate.value = selectedDate;
                },
                hintText: 'YYYY-MM-DD',
              ),
              // 키, 몸무게 입력
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth / 6),
                    child: SignupInput(
                      inputType: 'height',
                      hintText: '키',
                      onChanged: (value) {
                        _authController.height.value = value;
                      },
                    ),
                  ),
                  SignupInput(
                    inputType: 'weight',
                    hintText: '몸무게',
                    onChanged: (value) {
                      _authController.weight.value = value;
                    },
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    '성별',
                    style: TextStyle(
                      color: Color(0xFF1C1516),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              SizedBox(height: 7),
              // 성별 선택 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _authController.selectedGender.value = 'woman';
                    },
                    child: Obx(() => Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color:
                                _authController.selectedGender.value == 'woman'
                                    ? Color(0xFF1EA6FC).withOpacity(0.1)
                                    : Color(0xFFE3E5E5).withOpacity(0.3),
                            border: Border.all(
                              color: _authController.selectedGender.value ==
                                      'woman'
                                  ? Color(0xFF1EA6FC)
                                  : Color(0xFFE3E5E5).withOpacity(0.8),
                              width: _authController.selectedGender.value ==
                                      'woman'
                                  ? 4.0
                                  : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            _authController.selectedGender.value == 'woman'
                                ? 'assets/images/auth/woman_ok.png'
                                : 'assets/images/auth/woman_no.png',
                            width: 85,
                            height: 85,
                          ),
                        )),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      _authController.selectedGender.value = 'man';
                    },
                    child: Obx(() => Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _authController.selectedGender.value == 'man'
                                ? Color(0xFF1EA6FC).withOpacity(0.1)
                                : Color(0xFFE3E5E5).withOpacity(0.3),
                            border: Border.all(
                              color:
                                  _authController.selectedGender.value == 'man'
                                      ? Color(0xFF1EA6FC)
                                      : Color(0xFFE3E5E5).withOpacity(0.8),
                              width:
                                  _authController.selectedGender.value == 'man'
                                      ? 4.0
                                      : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            _authController.selectedGender.value == 'man'
                                ? 'assets/images/auth/man_ok.png'
                                : 'assets/images/auth/man_no.png',
                            width: 85,
                            height: 85,
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: WideButton(
          text: '다음',
          isActive: _authController.isButtonActive.value,
          onTap: _authController.isButtonActive.value
              ? () async {
                  bool isNicknameCheck = await _authController
                      .checkNickname(_authController.nickname.value);
                  if (isNicknameCheck) {
                    Get.snackbar('죄송', '이미 사용중인 닉네임입니다');
                  } else {
                    int? height = _authController.height.value.isNotEmpty
                        ? int.tryParse(_authController.height.value)
                        : null;
                    int? weight = _authController.weight.value.isNotEmpty
                        ? int.tryParse(_authController.weight.value)
                        : null;
                    log('${_authController.email.value}');
                    await _authController.signup(
                      Auth(
                        email: _authController.email.value,
                        nickname: _authController.nickname.value,
                        birth:
                            DateTime.tryParse(_authController.birthDate.value),
                        height: height,
                        weight: weight,
                        gender: _authController.selectedGender.value == 'man'
                            ? 1
                            : 0,
                        joinType: 'kakao',
                        memberImage: _authController.memberImage.value,
                      ),
                    );
                    if (_authController.signUpSuccess.value) {
                      Get.toNamed('/signup2');
                    }
                  }
                }
              : null,
        ),
      ),
    );
  }
}
