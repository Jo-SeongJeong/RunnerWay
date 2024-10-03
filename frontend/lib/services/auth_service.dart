import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/auth.dart';
import '../repositories/auth_repository.dart';
import 'package:frontend/utils/dio_client.dart';

class AuthService {
  final AuthRepository _repository = AuthRepository();
  final DioClient _dioClient = DioClient();
  Dio dio = Dio();

  // 사용자 이메일 확인
  Future<dynamic> getOuathKakao(String email) async {
    final auth = await _repository.getOuathKakao(email);
    log('service: $auth');
    return auth;
  }

// 사용자 회원가입
  Future<String?> signupKakao(Auth authData) async {
    try {
      final response =
          await _dioClient.dio.post('members/sign-up', data: authData.toJson());
      log('회원가입 성공 service: ${response.data}');
      return response.data['accessToken'];
    } catch (e) {
      log('회원가입 중 오류 발생 service: $e');
      throw e;
    }
  }

// 닉네임 중복 체크 함수 추가
  Future<bool> checkNicknameDuplicate(String nickname) async {
    try {
      // return await _repository.nickNameCheck(nickname);
      final response = await _dioClient.dio.get('members/duplication-nickname',
          queryParameters: {'nickname': nickname});
      return response.data['isAvailable'];
    } catch (e) {
      throw Exception('닉네임 중복 확인 중 오류 발생 service: $e');
    }
  }

  // 선호 태그 전송
  Future<void> sendFavoriteTag(Map<String, dynamic> requestBody) async {
    try {
      // TODO
      final response =
          await _dioClient.dio.post('members/tags', data: requestBody);
    } catch (e) {
      throw Exception('선호 태그 전송 중 오류 발생 service: $e');
    }
  }

  // 선호 태그 등록 여부 확인
  Future<bool> checkFavoriteTag() async {
    try {
      // return await _repository.checkFavoriteTag();
      final response = await _dioClient.dio.get('members/tags');
      if (response.data != null && response.data['isRegist'] is bool) {
        return response.data['isRegist']; // bool 값을 반환
      } else {
        throw Exception('서버에서 예상치 못한 응답을 받았습니다.');
      }
    } catch (e) {
      throw Exception('선호 태그 확인 중 오류 발생: $e');
    }
  }

  // 사용자 정보 불러오기
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      log('service사용자정보: ${_repository.getUserInfo()}');
      // return await _repository.getUserInfo();
      final response = await _repository.getUserInfo();
      return response;
    } catch (e) {
      throw Exception('사용자 정보 불러오는 중 발생: $e');
    }
  }

  // 회원 탈퇴
  Future<void> removeMember() async {
    try {
      final response = await _dioClient.dio.delete('members');
      log('회원탈퇴 성공 service: ${response.data}');
    } catch (e) {
      log('회원탈퇴 중 오류 발생: $e');
      throw e;
    }
  }
}
