import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth.dart';
import 'package:frontend/utils/dio_client.dart';

class AuthProvider {
  Dio dio = Dio();
  final _storage = FlutterSecureStorage();
  final DioClient _dioClient = DioClient();

  // 사용자 회원 여부 확인 _ 이메일로 확인
  Future<dynamic> fetchOauthKakao(String email) async {
    try {
      final response = await _dioClient.dio.post('oauth/kakao/${email}');
      // final response = await dio.post(
      //     'https://j11b304.p.ssafy.io/api/oauth/kakao/${Uri.encodeComponent(email)}',
      //     options: Options(
      //         followRedirects: false,
      //         validateStatus: (status) {
      //           return status! < 500;
      //         }));
      log('사용자 이메일 조회 provider: ${response.data}');

      if (response.statusCode == 200) {
        return response.data['email']; // 서버에서 반환한 이메일 데이터
      } else if (response.statusCode == 303) {
        return response.data;
      } else {
        throw Exception('회원가입 실패: 서버 응답 오류 (${response.statusCode})');
      }
    } catch (e) {
      log('카카오 회원가입 중 오류 발생 provider: $e');
      throw e;
    }
  }

  // 회원가입
  Future<Map<String, dynamic>> fetchSignupkakao(Auth authData) async {
    try {
      log('autoData: ${authData.toJson()}');
      final response = await _dioClient.dio
          .post('/members/sign-up', data: authData.toJson());
      // final response = await dio.post(
      //   'https://j11b304.p.ssafy.io/api/members/sign-up',
      //   data: authData.toJson(),
      // );
      log('서버 응답 provider: ${response.data}');

      if (response.statusCode == 200) {
        log('회원가입 성공 provider: ${response.data}');
        return {'accessToken': response.data};
      } else {
        // 500에러
        throw Exception('회원가입 실패 provider: 서버 응답 오류 (${response.statusCode})');
      }
    } on DioException catch (e) {
      log('회원가입 중 오류 발생 provider: ${e}');
      throw Exception('회원가입 중 오류 발생 provider: ${e}');
    }
  }

  // 닉네임 중복 체크
  Future<bool> nickNameCheck(String nickname) async {
    try {
      final response =
          await _dioClient.dio.get('/members/duplication-nickname/${nickname}');
      // final response = await dio.get(
      //   'https://j11b304.p.ssafy.io/api/members/duplication-nickname/${Uri.encodeComponent(nickname)}',
      // );

      if (response.statusCode == 200) {
        return response.data['duplicateResult']; // 서버 응답에서 중복 여부 반환
      } else {
        throw Exception('닉네임 중복 확인 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('닉네임 중복 확인 중 오류 발생 provider: $e');
    }
  }

  // 선호 태그 등록 여부 조회
  Future<bool> checkFavoriteTag() async {
    // TODO
    // final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
    try {
      // final response = await dio.get(
      //   'https://j11b304.p.ssafy.io/api/members/tags',
      //   options: Options(
      //     headers: {
      //       'Authorization': 'Bearer ${accessToken}',
      //       'Content-Type': 'application/json',
      //     },
      //   ),
      // );
      final response = await _dioClient.dio.get('/members/tags');

      if (response.statusCode == 200) {
        return response.data['isRegist'];
      } else {
        throw Exception('선호 태그 조회 실패: 서버 오류 (${response.statusCode})');
      }
    } catch (e) {
      log('선호 태그 조회 중 오류 발생 provider: $e');
      throw e;
    }
  }

  // 선호 태그 등록
  Future<void> sendFavoriteTag(Map<String, dynamic> requestBody) async {
    final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
    log('${accessToken}');

    try {
      final response = await _dioClient.dio.post(
        '/members/tags',
        data: requestBody,
      );
      // final response =
      //     await dio.post('https://j11b304.p.ssafy.io/api/members/tags',
      //         options: Options(
      //           headers: {
      //             'Authorization': 'Bearer ${accessToken}',
      //             'Content-Type': 'application/json',
      //           },
      //         ),
      //         data: requestBody);
      if (response.statusCode == 200) {
        log('선호 태그 등록 성공');
      } else {
        throw Exception('선호 태그 등록 실패: 서버 오류 (${response.statusCode})');
      }
    } catch (e) {
      log('선호 태그 등록 중 오류 발생 provider: $e');
      throw e;
    }
  }

// 개인정보 조회
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
      log('개인정보조회 provider: ${accessToken}');
      final response = await _dioClient.dio.get('/members');
      if (response.statusCode == 200) {
        log('$response');
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw Exception('서버에서 잘못된 형식의 데이터를 반환했습니다.');
        }
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException 발생: ${e.message}');
      throw Exception('개인 정보 조회 중 오류 발생: $e');
    } catch (e) {
      throw Exception('예상치 못한 오류 발생: $e');
    }
  }
}
