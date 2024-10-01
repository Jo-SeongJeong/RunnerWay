import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  // 현재 위치 정보를 관리
  var currentPosition = Rxn<Position>();
  var hasPositioned = Rxn<bool>();

  @override
  void onInit() {
    super.onInit();

    // 현재 위치 정보 불러오기
    log('location controller');
    getCurrentLocation();

    // currentPosition이 변경될 때마다 로그를 출력
    ever(currentPosition, (Position? pos) {
      if (pos != null) {
        log("Current Position: Latitude ${pos.latitude}, Longitude ${pos.longitude}");
      } else {
        log("Position not available");
      }
    });
  }

  // 위치 정보를 가져오는 함수
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      // 위치 서비스가 꺼져있는 경우 예외처리
      if (!serviceEnabled) {
        print('위치 정보를 가져올 수 없습니다');
        hasPositioned.value = false;
        return;
      }

      // 위치 정보 요청이 거절된 경우 예외 처리 (사용자가 위치 권한을 거부)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        hasPositioned.value = false;
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          hasPositioned.value = false;
          return;
        }
      }

      // 위치 정보 요청이 영구적으로 거절된 경우 예외 처리:
      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        hasPositioned.value = false;
        return;
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );

      log('현재 위치 : $position');
      // 현재 위치 업데이트
      currentPosition.value = position;
      hasPositioned.value = true;
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // gps 설정 열기
  void openLocationSettings() {
    // app_settings 패키지를 사용해 네트워크 설정 열기
    AppSettings.openAppSettings(type: AppSettingsType.location);
    log('위치 설정 화면으로 이동했습니다.');
  }
}
