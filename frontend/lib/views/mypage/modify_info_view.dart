import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/base_view.dart';
import 'package:get/get.dart';
import '../../widgets/line.dart';
import '../../widgets/modal/birth_modal.dart';
import '../auth/widget/signup_input.dart';
import 'package:intl/intl.dart';

class ModifyInfoView extends StatelessWidget {
  const ModifyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.put(AuthController());
    final double screenWidth = MediaQuery.of(context).size.width;
    _authController.fetchUserInfo();

    final TextEditingController nicknameController = TextEditingController(
      text: _authController.nickname.value,
    );

    nicknameController.addListener(
        () => {_authController.nickname.value = nicknameController.text});

    String formatDate(String date) {
      if (date.isEmpty) return 'YYYY-MM-DD';
      DateTime dateTime = DateTime.parse(date);

      log('dateTime 출력 : $dateTime');
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        await _authController.pickImage();
                      },
                      child: Container(
                        height: 119,
                        width: 119,
                        decoration: BoxDecoration(
                          color: Color(0xFFE4E4E4),
                          border:
                              Border.all(color: Color(0xFFE4E4E4), width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _authController.selectedImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _authController.selectedImage.value!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (_authController
                                        .memberImage.value?.url?.isNotEmpty ==
                                    true)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      _authController.memberImage.value!.url!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Image.asset(
                                            'assets/images/auth/default_profile.png',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Image.asset(
                                      'assets/images/auth/default_profile.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                      ),
                    ),
                    SizedBox(height: 30),
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
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: nicknameController,
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
                            hintText: _authController.nickname.value,
                            hintStyle: TextStyle(
                              color: Color(0xFF72777A),
                            ),
                            fillColor: Color(0xFFE3E5E5).withOpacity(0.4),
                          ),
                          cursorColor: Colors.blueAccent,
                          cursorErrorColor: Colors.red,
                        ))
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
                        _authController.birthDate.value =
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(selectedDate));
                      },
                      hintText: _authController.birthDate.value != null
                          ? formatDate(_authController.birthDate.value)
                          : 'YYYY-MM-DD',
                    ),
                    Row(
                      children: [
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
                    SizedBox(height: screenWidth * 0.2),
                    ElevatedButton(
                      onPressed: () {
                        // 모든 값 초기화 및 추가
                        Map<String, dynamic> updateInfo = {
                          'nickname': _authController.nickname.value.isNotEmpty
                              ? _authController.nickname.value
                              : "",
                          'birth': _authController.birthDate.value.isNotEmpty
                              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                  _authController.birthDate.value))
                              : "",
                          'height': _authController.height.value.isNotEmpty
                              ? _authController.height.value
                              : "",
                          'weight': _authController.weight.value.isNotEmpty
                              ? _authController.weight.value
                              : "",
                        };

                        log('Updated Info: $updateInfo');
                        _authController.patchUserInfo(updateInfo);
                      },
                      child: const Text('회원정보 수정'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
