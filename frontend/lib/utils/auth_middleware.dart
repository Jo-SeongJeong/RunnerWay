import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthController authController = Get.find<AuthController>();

  @override
  RouteSettings? redirect(String? route) {
    // 로그인 상태가 아니라면 리다이렉트
    if (!authController.isLoggedIn.value) {
      return RouteSettings(name: '/runningthings'); // 로그인 안 되어 있을 때 리다이렉트할 페이지
    }
    return null; // 로그인 되어 있으면 그대로 진행
  }
}
