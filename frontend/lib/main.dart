import 'package:frontend/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/location_controller.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'controllers/under_bar_controller.dart';
import 'controllers/network_controller.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:frontend/utils/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeAppKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 앱 시작 시 전역 상태로 UnderBarController 등록
    Get.put(UnderBarController());
    final AuthController authController = Get.put(AuthController());
    final NetworkController networkController = Get.put(NetworkController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      networkController.checkInitialConnectivity(context);
    });

    Get.put(UnderBarController());
    return SafeArea(
      child: GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, // 모든 페이지의 배경색을 흰색으로 설정
          colorSchemeSeed: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        getPages: AppRoutes.routes,
        scrollBehavior: NoBounceScrollBehavior(), // 커스텀 스크롤 동작 적용
      ),
    );
  }
}

// 바운스 효과를 제거하는 커스텀 ScrollBehavior
class NoBounceScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // 바운스 효과를 제거
  }

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child; // 기본 Chrome 유지
  }
}
