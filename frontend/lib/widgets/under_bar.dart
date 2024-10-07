import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/my_flutter_app.dart';
import '../controllers/under_bar_controller.dart';

class UnderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // UnderBarController 인스턴스를 찾음
    final UnderBarController controller = Get.find<UnderBarController>();

    // 기기 가로 길이 가져오기
    final double screenWidth = MediaQuery.of(context).size.width;

    return Obx(() => Container(
          width: screenWidth,
          height: 110,
          color: Colors.transparent,
          child: Stack(
            children: [
              // 네비게이션 바의 배경과 그림자
              Positioned(
                left: 0,
                top: 30,
                child: Container(
                  width: screenWidth,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white, // 투명 배경 처리
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14141414),
                        blurRadius: 8,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // 네비게이션 아이템들 배치
                      Positioned(
                        left: 5,
                        top: 7,
                        child: _buildNavItem(
                            0, '메인', Icons.home, screenWidth / 4, controller,
                            isLargeIcon: true),
                      ),
                      Positioned(
                        left: screenWidth / 5,
                        top: 7,
                        child: _buildNavItem(1, '러너', MyFlutterApp.road_1,
                            screenWidth / 4, controller,
                            hasSizedBox: true),
                      ),
                      Positioned(
                        left: 3 * screenWidth / 5 - 15,
                        top: 7,
                        child: _buildNavItem(
                            2,
                            '기록',
                            MyFlutterApp.calendar_empty,
                            screenWidth / 4,
                            controller,
                            hasSizedBox: true),
                      ),
                      Positioned(
                        left: 4 * screenWidth / 5 - 20,
                        top: 7,
                        child: _buildNavItem(
                            3, '마이', Icons.person, screenWidth / 4, controller,
                            isLargeIcon: true),
                      ),
                    ],
                  ),
                ),
              ),

              // 플로팅 액션 버튼(가운데 강조된 버튼)
              Positioned(
                  left: (screenWidth / 2) - 30, // 화면의 가운데에 배치
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      // 모달 띄우기
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return const ModalContent();
                        },
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Color(0xFF1EA6FC),
                        shape: OvalBorder(),
                        shadows: [
                          BoxShadow(
                            color: Color(0x961EA6FC),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                          child: Image.asset(
                        'assets/icons/shoe.png',
                        height: 32,
                      )),
                    ),
                  )),
              // 선택된 탭의 상단 바
              Obx(() => Positioned(
                    top: 30, // 바의 고정된 상단 위치
                    left: _getBarPosition(
                        screenWidth,
                        controller
                            .selectedIndex.value), // 선택된 탭에 따라 위치를 동적으로 설정
                    child: Container(
                      width: screenWidth / 5 - 5, // 각 탭의 너비에 맞추어 바의 폭 설정
                      height: 5,
                      color: const Color(0xFF1EA6FC), // 바의 색상
                    ),
                  )),
            ],
          ),
        ));
  }

  // 선택된 탭에 따라 상단 바의 위치를 반환하는 함수
  double _getBarPosition(double screenWidth, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 17; // '메인' 탭의 바 위치
      case 1:
        return 13 + screenWidth / 5; // '러너픽' 탭의 바 위치
      case 2:
        return 3 * screenWidth / 5; // '기록' 탭의 바 위치
      case 3:
        return 4 * screenWidth / 5 - 6; // '마이' 탭의 바 위치
      default:
        return 0;
    }
  }

  // 네비게이션 아이템을 생성하는 함수
  Widget _buildNavItem(int index, String label, IconData iconData,
      double itemWidth, UnderBarController controller,
      {bool isLargeIcon = false, bool hasSizedBox = false}) {
    return GestureDetector(
      onTap: () {
        controller.changeTabIndex(index);

        // 각 인덱스에 해당하는 라우트로 전환
        switch (index) {
          case 0:
            Get.toNamed('/main');
            break;
          case 1:
            Get.toNamed('/runner');
            break;
          case 2:
            Get.toNamed('/record');
            break;
          case 3:
            Get.toNamed('/mypage');
            break;
        }
      },
      child: Container(
        width: itemWidth,
        height: 56,
        color: Colors.transparent, // 네비게이션 아이템의 배경을 투명하게 설정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: isLargeIcon ? 32 : 22, // 메인과 마이의 아이콘은 크게, 나머지는 기본 크기
              color: controller.selectedIndex == index
                  ? Color(0xFF1EA6FC)
                  : Color(0xFF6C7072),
            ),
            if (hasSizedBox) SizedBox(height: 6), // 러너픽과 기록에만 추가되는 간격
            Text(
              label,
              style: TextStyle(
                color: controller.selectedIndex == index
                    ? Color(0xFF1EA6FC)
                    : Color(0xFF6C7072),
                fontSize: 10,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 나 혼자 뛰기 러닝 모달
class ModalContent extends StatelessWidget {
  const ModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: const Size(200, 100),
        ),
        Positioned(
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 취소 버튼
              GestureDetector(
                onTap: () => Get.back(),
                child: Column(
                  children: const [
                    Icon(Icons.arrow_back, size: 30, color: Colors.black),
                    Text('취소', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // 러닝 시작 버튼 -> RunningScreen으로 이동
              GestureDetector(
                onTap: () {
                  Get.back(); // 모달 닫기
                  Get.toNamed('/running/free/0/0', parameters: {'varid': '0'});
                },
                child: Column(
                  children: const [
                    Icon(Icons.directions_run, size: 30, color: Colors.blue),
                    Text('러닝 시작', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
