import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart'; // app_settings 패키지 추가

class NetworkController {
  static final Connectivity _connectivity = Connectivity();

  var isConnected = Rxn<bool>();
  var isLoading = false.obs;

  // 네트워크 상태를 처음에 한 번만 확인하는 함수
  Future<void> checkInitialConnectivity(BuildContext context) async {
    isLoading.value = true;
    try {
      final List<ConnectivityResult> result =
          await _connectivity.checkConnectivity();
      _handleConnectionStatus(result, context);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // log 출력
  void _handleConnectionStatus(
      List<ConnectivityResult> result, BuildContext context) {
    if (result.contains(ConnectivityResult.wifi)) {
      log('Wi-Fi에 연결되었습니다.');
      isConnected.value = true;
    } else if (result.contains(ConnectivityResult.mobile)) {
      log('모바일 네트워크에 연결되었습니다.');
      isConnected.value = true;
    } else {
      log('연결 없어요~~');
      isConnected.value = false;
    }
  }

  // 네트워크 설정 열기
  void openNetworkSettings() {
    // app_settings 패키지를 사용해 네트워크 설정 열기
    AppSettings.openAppSettings(type: AppSettingsType.wireless);
    log('네트워크 설정 화면으로 이동했습니다.');
  }
}
