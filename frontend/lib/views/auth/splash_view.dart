import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/controllers/location_controller.dart';
import 'package:frontend/controllers/network_controller.dart';
import 'package:frontend/widgets/modal/custom_modal.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashView extends StatelessWidget {
  final NetworkController networkController = Get.find<NetworkController>();
  final LocationController locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Obx(
          () {
            // 네트워크 상태 확인 중
            if (networkController.isConnected.value == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // CircularProgressIndicator(),
                  SizedBox(height: 10),
                  // Text(
                  //   '네트워크 상태를 확인하는 중',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                ],
              );
            }
            if (locationController.hasPositioned.value == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    width: screenWidth / 2,
                  ),
                  // CircularProgressIndicator(),
                  SizedBox(height: 30),
                  Container(
                    width: 100,
                    child: LoadingIndicator(
                      indicatorType: Indicator.orbit,
                      colors: [Color(0xff1C1516), Color(0xff1EA6FC)],
                      strokeWidth: 1,
                    ),
                  )
                ],
              );
            }

            // 네트워크 연결이 없을 때
            else if (networkController.isConnected.value == false) {
              log('연결 안됨');
              Future.delayed(Duration.zero, () => _showNoNetworkModal(context));
              return Container();
            } else if (locationController.hasPositioned.value == false) {
              log('위치 설정 꺼짐');
              Future.delayed(
                  Duration.zero, () => _showNoPositionModal(context));
              return Container();
            }

            // 네트워크와 위치가 모두 true일 때만 이동
            else if (networkController.isConnected.value == true &&
                locationController.hasPositioned.value == true &&
                Get.currentRoute == '/splash') {
              Future.delayed(Duration.zero, () => _navigateToMain());
              return const SizedBox.shrink();
            } else {
              return const SizedBox.shrink(); // 기본 반환값 추가
            }
          },
        ),
      ),
    );
  }

  void _showNoNetworkModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomModal(
          title: '네크워크 연결 없음',
          content: '네트워크 연결을 확인하세요',
          confirmText: '설정 열기',
          onConfirm: () {
            // 네트워크 설정 열기
            Get.find<NetworkController>().openNetworkSettings();
          },
        );
      },
    );
  }

  void _showNoPositionModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomModal(
          title: '위치 정보 없음',
          content: '위치 정보를 확인하세요',
          confirmText: '설정 열기',
          onConfirm: () {
            // 네트워크 설정 열기
            locationController.openLocationSettings();
          },
        );
      },
    );
  }

  void _navigateToMain() {
    Get.offNamed('/main'); // 네트워크 연결 시 메인 화면으로 이동
  }
}
