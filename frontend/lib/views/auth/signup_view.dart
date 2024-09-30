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
      resizeToAvoidBottomInset: false,
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
        padding: const EdgeInsets.all(20), // 화면 전체 margin 20
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              // 회원가입 유저 이미지
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/auth/default_profile.png',
                      width: 90,
                      height: 90,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              // 회원가입 폼 시작
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
                      controller: _authController.nicknameController,
                      // 닉네임 글자 수 제한
                      onChanged: (text) {
                        if (text.characters.length > 8) {
                          _authController.nicknameController.text =
                              text.characters.take(8).toString(); // 8자로 자르기
                          // 커서 뒤로 이동
                          _authController.nicknameController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _authController
                                      .nicknameController.text.length));
                        }
                        _authController.onNicknameChanged(text);
                      },
                      decoration: InputDecoration(
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
                        hintText: '  닉네임 (2~8자)',
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
              BirthModal(birthController: _authController.dateController),
              // 키 몸무게 input
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth / 6),
                    child: SignupInput(
                        inputType: 'height',
                        controller: _authController.heightController),
                  ),
                  SignupInput(
                      inputType: 'weight',
                      controller: _authController.weightController),
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
                      .checkNickname(_authController.nicknameController.text);
                  if (isNicknameCheck) {
                    Get.snackbar('오류', '이미 사용중인 닉네임입니다');
                  } else {
                    int? height = _authController
                            .heightController.text.isNotEmpty
                        ? int.tryParse(_authController.heightController.text)
                        : null;
                    int? weight = _authController
                            .weightController.text.isNotEmpty
                        ? int.tryParse(_authController.weightController.text)
                        : null;
                    await _authController.signup(
                      Auth(
                        email: this.email,
                        nickname: _authController.nicknameController.text,
                        birth: DateTime.tryParse(
                            _authController.dateController.text),
                        height: height,
                        weight: weight,
                        gender: _authController.selectedGender.value == 'man'
                            ? 1
                            : 0,
                        joinType: 'kakao',
                        memberImage: MemberImage(
                          memberId: null,
                          url: "",
                          path: "",
                        ),
                      ),
                    );

                    Get.toNamed('/signup2');
                  }
                }
              : null,
        ),
      ),
    );
  }
}
