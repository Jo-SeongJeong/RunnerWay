import 'package:frontend/providers/auth_provider.dart';
import 'dart:developer';
import 'package:frontend/models/auth.dart';

class AuthRepository {
  final AuthProvider _provider = AuthProvider();

  // 사용자 로그인
  Future<dynamic> getOuathKakao(String email) async {
    final response = await _provider.fetchOauthKakao(email);
    log('사용자 로그인 : $response');
    return response;
  }

  // 회원가입 처리 (access token 반환)
  Future<String> signupKakao(Auth authData) async {
    try {
      final response = await _provider.fetchSignupkakao(authData);
      // final accessToken = response['accessToken'];
      log('회원가입 성공 repo: $response');
      return response['accessToken'];
    } catch (e) {
      log('회원가입 중 오류 발생 repo: $e');
      throw e;
    }
  }

  // 닉네임 중복 체크
  Future<bool> nickNameCheck(String nickname) async {
    try {
      return await _provider.nickNameCheck(nickname); // 중복 여부 반환
    } catch (e) {
      throw Exception('닉네임 중복 확인 중 오류 발생 repository: $e');
    }
  }

  // 선호 태그 등록 여부 확인
  Future<bool> checkFavoriteTag() async {
    try {
      return await _provider.checkFavoriteTag();
    } catch (e) {
      log('선호 태그 확인 중 오류 발생 repo: $e');
      throw e;
    }
  }

  // 선호 태그 전송
  Future<void> sendFavoriteTag(Map<String, dynamic> requestBody) async {
    try {
      await _provider.sendFavoriteTag(requestBody);
      log('선호 태그 전송 성공');
    } catch (e) {
      log('선호 태그 전송 중 오류 발생 repo: $e');
      throw e;
    }
  }

// 사용자 정보 불러오기
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = _provider.getUserInfo();
      log('repo사용자정보: ${response}');
      return await response;
    } catch (e) {
      rethrow;
    }
  }

  // 회원정보 수정
  Future<dynamic> patchUserInfo(Map<String, dynamic> updateInfo) async {
    try {
      final response = await _provider.patchUserInfo(updateInfo);
      log('repo 정보수정: ${response}');
    } catch (e) {
      throw Exception('회원수정 repo: $e');
    }
  }
}
