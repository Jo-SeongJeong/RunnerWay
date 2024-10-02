import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DioClient {
  late final Dio _dio;
  final _storage = FlutterSecureStorage();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://j11b304.p.ssafy.io/api/',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        followRedirects: false,
        validateStatus: (status) {
          return status! < 400;
        },
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _handleRequest,
        onResponse: _handleResponse,
        onError: _handleError,
      ),
    );
  }

  Dio get dio => _dio;

  Future<void> _handleRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log('Request[${options.method}] => PATH: ${options.path}');

    // TODO
    // 설명
    // 토큰 필요한 부분은 자동으로 header에 토큰 주입
    // token이 발행이 안 되어 있다면 토큰 로직이 완성이 안돼서 token이 필요한 경우 임의로 주입
    // 나중에 주석부분 주석 해제 후 그 위 if문 삭제
    final accessToken = await _getAccessToken();
    // if (!_isAuthorizationExcluded(options.path)) {
    if (!_isAuthorizationExcluded(options.path) && accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${accessToken}';
      log('${accessToken}');
      // 여기 아래 코드는 추후 삭제 요망
      // if (accessToken != null) {
      //   options.headers['Authorization'] = 'Bearer $accessToken';
      // } else {
      //   options.headers['Authorization'] =
      //       'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTAsImVtYWlsIjoidGVzMnQyM3cyNEBleGFtcGxlLmNvbTIiLCJuaWNrbmFtZSI6InJ1bm4ydzMyNDIiLCJpYXQiOjE3MjU5NTc2ODMsImV4cCI6MTcyOTU1NzY4M30.64u_30Q6t3lXGYyNwLhSxfilMRtYgWKWSnqGP4XGG6k';
      // }
      // 여까지
    } else if (!_isAuthorizationExcluded(options.path) && accessToken == null) {
      log('초비상!! 토큰 있는 상태로 요청 보내야 하는데 토큰 없음');
    }

    handler.next(options);
  }

  void _handleResponse(Response response, ResponseInterceptorHandler handler) {
    log('Response[${response.statusCode}] => DATA: ${response.data}');

    if (response.headers['authorization'] != null) {
      String? newToken = response.headers['authorization']?.first;
      _saveToken(newToken);
      _decodeToken(newToken);
    }

    if (response.requestOptions.path.startsWith('members') &&
        response.requestOptions.method.toUpperCase() == 'PATCH') {
      String? newToken = response.headers['authorization']?.first;
      _saveToken(newToken);
      _decodeToken(newToken);
    }

    handler.next(response);
  }

  void _handleError(DioException e, ErrorInterceptorHandler handler) {
    log('Error[${e.response?.statusCode}] => MESSAGE: ${e.message}');
    handler.next(e);
  }

  Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'ACCESS_TOKEN');
  }

  Future<void> _saveToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      await _storage.write(key: 'ACCESS_TOKEN', value: token);

      log('토큰 저장: $token');
    }
  }

  Future<void> _decodeToken(String? newToken) async {
    if (newToken != null && newToken.startsWith('Bearer ')) {
      // "Bearer " 부분을 제거
      final token = newToken.substring(7);

      // JWT 디코딩
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      log('Decoded JWT: $decodedToken');

      // await _storage.write(key: 'ACCESS_TOKEN', value: token);
      await _storage.write(key: 'ID', value: decodedToken['id'].toString());
      await _storage.write(key: 'EMAIL', value: decodedToken['email']);
      await _storage.write(key: 'NICKNAME', value: decodedToken['nickname']);

      // JWT의 만료 여부 확인
      bool isTokenExpired = JwtDecoder.isExpired(token);
      log('Is token expired? $isTokenExpired');
    }
  }

  bool _isAuthorizationExcluded(String path) {
    const excludedPaths = [
      'oauth/kakao',
      'members/sign-up',
      'members/duplication-nickname'
    ];
    return excludedPaths.any((excluded) => path.startsWith(excluded));
  }
}
