import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/auth/signup_view.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:get/get.dart';
import '../models/auth.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var isLoggedIn = false.obs;

  TextEditingController nicknameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final _storage = FlutterSecureStorage(); // 토큰 저장
  final AuthService _authService = AuthService();
  // 선택된 성별 및 버튼 활성화 상태
  var selectedGender = ''.obs;
  var isButtonActive = false.obs;
  RxBool isEditable = false.obs;
  // 닉네임 변경 감지 함수
  void onNicknameChanged(String nickname) {
    isButtonActive.value = nicknameController.text.trim().length > 1;
  }

  // 카카오톡 로그인
  Future<void> loginWithKakao() async {
    try {
      // 기본 카카오 로그인
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      log('카카오 로그인 성공: ${token.accessToken}');
      // 토큰을 스토리지에 저장
      await _saveToken(token.accessToken);

      // 저장된 토큰을 바로 불러와서 확인
      String? accessToken = await _storage.read(key: 'ACCESS_TOKEN');
      if (accessToken != null) {
        log('카카오톡으로 로그인 성공 controller: ${token.accessToken}');
      } else {
        log('토큰 저장 실패: 불러올 수 없습니다.');
      }
      // 사용자 정보 요청
      await requestUserInfo();

      // 로그인 성공 상태
      isLoggedIn.value = true;
    } catch (error) {
      log('카카오톡 로그인 실패: $error');
      Get.snackbar('오류', '카카오톡 로그인에 실패했습니다.');
    }
  }

  // 카카오 사용자 정보 가져오기
  Future<void> requestUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      email.value = user.kakaoAccount?.email ?? "Unknown";
      log('사용자 정보 요청 성공_controller: ${email.value}');
      await checkUserEmailOnServer(email.value);
    } catch (error) {
      log('사용자 정보 요청 실패_controller: $error');
      Get.snackbar('오류', '사용자 정보를 가져오지 못했습니다.');
    }
  }

// 서버로 이메일을 보내 회원 여부 확인
  Future<void> checkUserEmailOnServer(String userEmail) async {
    try {
      final response = await _authService.getOuathKakao(userEmail);
      log('${response}');
      // 서버에서 받은 응답이 이메일인 경우(신규 회원)
      if (response == userEmail) {
        email.value = userEmail;
        Get.to(SignUpView(email: email.value));
        // TODO toNamed로 바꾸기
        // Get.toNamed('/signup', arguments: {'email': email.value}); //이렇게 두면 오류 남
      }

      // 서버에서 받은 응답이 accessToken인 경우(기존 회원)
      else if (response['token'] != null) {
        // accessToken 저장
        await _saveToken(response['token']);
        // 기존 회원이라면 선호 코스 등록 여부 확인 t / f

        checkFavoriteTag();
      } else {
        log('서버 응답에서 예상치 못한 값이 있습니다.');
      }
      log('${userEmail}');
    } catch (e) {
      log('회원 여부 확인 중 오류 발생 controller: $e');
      Get.snackbar('오류', '회원 여부 확인 중 오류가 발생했습니다.');
    }
  }

  // 사용자 정보 입력
  Future<void> signup(Auth authData) async {
    try {
      final accessToken = await _authService.signupKakao(authData);
      if (accessToken != null) {
        log('회원가입 성공 controller');
        await _saveToken(accessToken);
        Get.snackbar('성공', '선호태그 입력 페이지로 이동합니다.');
      } else {
        Get.snackbar('오류', '회원가입 중 오류가 발생했습니다.');
      }
    } catch (e) {
      log('회원가입 중 오류 발생 controller: $e');
      Get.snackbar('오류', '회원가입에 실패했습니다.');
    }
  }

  // 이메일 중복 체크
  Future<bool> checkNickname(String nickname) async {
    try {
      final isAvailable = await _authService.checkNicknameDuplicate(nickname);
      if (isAvailable) {
        Get.snackbar('오류', '이미 사용 중인 닉네임입니다.');
        return true;
      } else {
        Get.snackbar('성공', '사용 가능한 닉네임입니다.');
        return false;
      }
    } catch (e) {
      log('이메일 체크 controller: $e');
      return false;
    }
  }

// 토큰 저장
  Future<void> _saveToken(String? accessToken) async {
    log('저장할 accessToken _ controller: ${accessToken}');
    if (accessToken != null) {
      await _storage.write(key: 'ACCESS_TOKEN', value: accessToken);
      final accessToken1 = await _storage.read(key: 'ACCESS_TOKEN');
      log('${accessToken1}');
      log('토큰 저장 성공');
    } else {
      log('토큰 저장 실패 controller: accessToken이 없습니다.');
    }
  }

// 선호 태그 등록 여부 확인
  Future<void> checkFavoriteTag() async {
    try {
      final isTagRegistered = await _authService.checkFavoriteTag();
      if (isTagRegistered) {
        Get.toNamed('main');
      } else {
        Get.toNamed('signup2');
      }
    } catch (e) {
      log('선호 태그 확인 중 오류 발생 controller: $e');
    }
  }

  // 선호 태그 전송
  Future<void> sendFavoriteTag(List<String> favoriteTags) async {
    try {
      Map<String, dynamic> requestBody = {
        "favoriteCourses": favoriteTags.map((tag) => {"tagName": tag}).toList()
      };
      await _authService.sendFavoriteTag(requestBody);
      Get.toNamed('/main');
    } catch (e) {
      Get.snackbar('오류', '선호 태그 등록 중 오류가 발생했습니다.');
    }
  }

  // 로그아웃 함수
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      await _storage.deleteAll(); // 저장된 토큰 삭제
      isLoggedIn.value = false;
      email.value = '';
      log('로그아웃 성공');
    } catch (error) {
      log('로그아웃 실패 controller: $error');
      Get.snackbar('오류', '로그아웃에 실패했습니다.');
    }
  }

  // 사용자 정보 불러오기
  Future<void> fetchUserInfo() async {
    // Map<String, dynamic> userInfoMap = await _authService.getUserInfo();
    try {
      // TODO
      // 서버에서 Map<String, dynamic> 데이터를 받음
      Map<String, dynamic> userInfoMap = await _authService.getUserInfo();
      log('${userInfoMap}');
      Auth userInfo = Auth.fromJson(userInfoMap);

      // 받아온 데이터를 직접 TextEditingController에 설정
      nicknameController.text = 'ㅇㅇㅇㅇ';
      // nicknameController.text = userInfo.nickname ?? '';
      dateController.text = userInfo.birth?.toString() ?? '';
      heightController.text = userInfo.height?.toString() ?? '';
      weightController.text = userInfo.weight?.toString() ?? '';
      selectedGender.value = userInfo.gender == 1 ? 'man' : 'woman';

      log('회원 정보 불러오기 성공: $userInfoMap');
    } catch (e) {
      log('회원 정보 불러오기controller: $e');
      Get.snackbar('오류', '회원 정보를 가져오는 데 실패했습니다.');
    }
  }
}
