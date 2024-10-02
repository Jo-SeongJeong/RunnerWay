import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:frontend/views/auth/signup_view.dart';
import 'package:get/get.dart';
import '../../widgets/line.dart';
import '../../widgets/modal/birth_modal.dart';
import '../auth/widget/signup_input.dart';
import 'package:intl/intl.dart';

class ModifyInfoView extends StatelessWidget {
  const ModifyInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.put(AuthController());
    final double screenWidth = MediaQuery.of(context).size.width;
    _authController.fetchUserInfo();

    String formatDate(String date) {
      if (date.isEmpty) return '  YYYY-MM-DD';
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }

    return BaseView(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            '회원정보수정',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 56,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  height: 119,
                  width: 119,
                  decoration: BoxDecoration(
                      color: Color(0xFFE4E4E4),
                      border: Border.all(color: Color(0xFFE4E4E4), width: 2),
                      borderRadius: BorderRadius.circular(16)),
                ),
                SizedBox(height: 30),
                // TODO 유저 이름
                Line(),
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
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                              text: _authController.nickname.value),
                          // 닉네임 글자 수 제한
                          onChanged: (text) {
                            if (text.characters.length > 8) {
                              _authController.nickname.value =
                                  text.characters.take(8).toString();
                            } else {
                              _authController.nickname.value = text;
                            }
                            _authController.onNicknameChanged(
                                _authController.nickname.value);
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
                      )
                    ],
                  ),
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
                    _authController.birthDate.value = selectedDate;
                  },
                  hintText: _authController.birthDate.value != null &&
                          _authController.birthDate.value.isNotEmpty
                      ? formatDate(_authController.birthDate.value)
                      : '  YYYY-MM-DD',
                ),
                // 키 몸무게 input
                Row(
                  children: [
                    // "키" 입력 필드
                    Expanded(
                      child: Obx(
                        () => SignupInput(
                          inputType: 'height',
                          hintText: _authController.height.value != null &&
                                  _authController.height.value.isNotEmpty
                              ? '${_authController.height.value}'
                              : '키',
                          onChanged: (value) {
                            _authController.height.value = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 20),

                    Expanded(
                      child: Obx(
                        () => SignupInput(
                          inputType: 'weight',
                          hintText: _authController.weight.value != null &&
                                  _authController.weight.value.isNotEmpty
                              ? '${_authController.weight.value}'
                              : '몸무게',
                          onChanged: (value) {
                            _authController.weight.value = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 7),

                SizedBox(height: 25),
                // ElevatedButton(
                //   onPressed: () {
                //     _authController.isEditable.value =
                //         !_authController.isEditable.value;
                //   },
                //   child: Obx(() =>
                //       Text(_authController.isEditable.value ? '저장' : '수정')),
                // ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpView(
                                email: '',
                              )),
                    );
                  },
                  child: const Text('Go to Signup Page'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}