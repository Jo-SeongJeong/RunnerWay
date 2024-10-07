import 'dart:developer';

import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class SignUpController extends GetxController {
  var nickname = ''.obs;
  var birthDate = ''.obs;
  var height = 0.0.obs;
  var weight = 0.0.obs;
  var selectedGender = ''.obs;
  var isLoggedIn = false.obs;

  // 카카오톡 로그인
  Future<void> loginWithKakao() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        // 카카오톡이 설치되어 있지 않을 때
        await UserApi.instance.loginWithKakaoAccount();
      }

      // 로그인 성공 시 사용자 정보 가져오기
      await _getUserInfo();
    } catch (e) {
      print("카카오톡 로그인 실패: $e");
      // Get.snackbar('오류', '카카오톡 로그인에 실패했습니다.');
    }
  }

  // 사용자 정보 가져오기
  Future<void> _getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      nickname.value = user.kakaoAccount?.profile?.nickname ?? "Unknown";
      selectedGender.value =
          user.kakaoAccount?.gender == Gender.male ? "male" : "female";
      isLoggedIn.value = true; // 로그인 성공
      print("카카오톡 로그인 성공, 닉네임: ${nickname.value}, 성별: ${selectedGender.value}");
    } catch (e) {
      print("사용자 정보 가져오기 실패: $e");
      // Get.snackbar('오류', '사용자 정보를 가져오지 못했습니다.');
    }
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      isLoggedIn.value = false;
      log("로그아웃 성공");
    } catch (e) {
      print("로그아웃 실패: $e");
    }
  }
}
