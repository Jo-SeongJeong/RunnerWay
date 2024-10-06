import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtController extends GetxController {
  final _storage = FlutterSecureStorage();

  var newToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTAsImVtYWlsIjoidGVzMnQyM3cyNEBleGFtcGxlLmNvbTIiLCJuaWNrbmFtZSI6InJ1bm4ydzMyNDIiLCJpYXQiOjE3MjU5NTc2ODMsImV4cCI6MTcyOTU1NzY4M30.64u_30Q6t3lXGYyNwLhSxfilMRtYgWKWSnqGP4XGG6k';

  var id = ''.obs;
  var email = ''.obs;
  var nickname = ''.obs;

  Future<void> loadDecodedData() async {
    // 'ACCESS_TOKEN' 읽기 시 비동기 처리를 위한 await 추가
    String? storedToken = await _storage.read(key: 'ACCESS_TOKEN');

    if (storedToken != null) {
      newToken = storedToken;
      await _storage.write(key: 'ACCESS_TOKEN', value: '${newToken}');
    }
    await _storage.write(key: 'ACCESS_TOKEN', value: '${newToken}');

    final token = newToken;
    // final token = newToken.substring(7);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    log('Decoded JWT: $decodedToken');

    await _storage.write(key: 'ID', value: decodedToken['id'].toString());
    await _storage.write(key: 'EMAIL', value: decodedToken['email']);
    await _storage.write(key: 'NICKNAME', value: decodedToken['nickname']);

    id.value = await _storage.read(key: 'ID') ?? 'No ID found';
    email.value = await _storage.read(key: 'EMAIL') ?? 'No Email found';
    nickname.value =
        await _storage.read(key: 'NICKNAME') ?? 'No Nickname found';

    final authController = Get.find<AuthController>();
    authController.isLoggedIn.value = true;
    log('${authController.isLoggedIn.value}');
  }
}
