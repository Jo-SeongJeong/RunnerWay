import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/controllers/running_controller.dart';

class FreeCourseRunningView extends StatelessWidget {
  FreeCourseRunningView({super.key});

  @override
  Widget build(BuildContext context) {
    final RunningController controller = Get.put(RunningController());

    return PopScope(
      onPopInvokedWithResult: (popType, result) async {
        // 뷰가 사라질 때 컨트롤러 삭제
        Get.delete<RunningController>();
      },
      child: Obx(
        () {
          if (controller.isLoading.value) {
            // 로딩 상태에서 CircularProgressIndicator 표시
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // 로딩이 완료되면 3, 2, 1 카운트다운을 오버레이로 보여줌
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: GoogleMap(
                          polylines: controller.value.value.polyline,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController mapController) {
                            controller.onMapCreated(mapController);
                            // controller.startRun();
                          },
                          initialCameraPosition: CameraPosition(
                            target: controller.value.value.mapCenter ??
                                LatLng(0, 0),
                            zoom: 17,
                          ),
                          markers: controller.value.value.markers,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '자유 코스',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '시간',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              '${controller.value.value.elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(controller.value.value.elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '이동 거리',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      '${(controller.value.value.totalDistance / 1000).toStringAsFixed(2)} km',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '페이스',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      '${controller.value.value.currentPace}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await controller.endRunning2();
                                await Future.delayed(Duration(seconds: 6));
                                Get.toNamed('/writereview');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '러닝 종료',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  OverlayWidget(controller: controller),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class OverlayWidget extends StatefulWidget {
  final RunningController controller;

  const OverlayWidget({required this.controller, Key? key}) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 0; i--) {
      setState(() {
        _countdown = i;
      });
      await Future.delayed(Duration(seconds: 1));
    }
    // 카운트다운이 끝나면 러닝을 시작
    widget.controller.startRun();
  }

  @override
  Widget build(BuildContext context) {
    if (_countdown > 0) {
      return Container(
        color: Colors.black54, // 배경을 반투명하게
        alignment: Alignment.center,
        child: Text(
          '$_countdown',
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    return Container(); // 카운트다운이 끝나면 빈 컨테이너 반환
  }
}
