import 'package:flutter/material.dart';
import 'package:frontend/widgets/modal/custom_modal.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/controllers/running_controller.dart';

class RunningView extends StatelessWidget {
  const RunningView({super.key});

  @override
  Widget build(BuildContext context) {
    final RunningController controller = Get.put(RunningController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        // isCanStart가 false일 때 다이얼로그 호출
        if (!controller.isCanStart.value) {
          Future.delayed(Duration.zero, () {
            _showStopLocationModal(context);
          });
          return const Scaffold();
        } else {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GoogleMap(
                        polylines: controller.value.value.polyline,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController mapController) {
                          controller.onMapCreated(mapController);
                        },
                        initialCameraPosition: CameraPosition(
                          target:
                              controller.value.value.mapCenter ?? LatLng(0, 0),
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
                              child: _buildRunStatus(controller), // 대결 상태 표시
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(() => _buildSingleTimer(controller)),
                          const SizedBox(height: 10),
                          _buildDistanceAndPace(controller),
                          const SizedBox(height: 10),
                          _buildLegend(controller),
                          const SizedBox(height: 20),
                          _buildEndRunningButton(controller),
                        ],
                      ),
                    ),
                  ],
                ),
                OverlayWidget(controller: controller),
                Obx(() {
                  if (!controller.isRun.value) {
                    Future.delayed(Duration.zero, () {
                      _showCustomModalWhenArrive(context);
                    });
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          );
        }
      }
    });
  }

  Widget _buildSingleTimer(RunningController controller) {
    return Column(
      children: [
        const Text(
          '시간',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          '${controller.value.value.elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(controller.value.value.elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerColumn(String label, Color color, Duration time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color),
        ),
        Text(
          '${time.inMinutes.toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRunStatus(RunningController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${controller.typeKorean.value} 코스',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (controller.varid != '0')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '대결 중',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildDistanceAndPace(RunningController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text(
              '이동 거리',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Obx(() => Text(
                  '${(controller.value.value.totalDistance).toStringAsFixed(2)} km',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        Column(
          children: [
            const Text(
              '페이스',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Obx(() => Text(
                  '${controller.value.value.currentPace}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(RunningController controller) {
    return Obx(() {
      if (controller.isOfficialRun.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.flag, color: Colors.red),
            SizedBox(width: 5),
            Text(
              '공식 코스',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            Icon(Icons.directions_run, color: Colors.blue),
            SizedBox(width: 5),
            Text(
              '현재 경로',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else if (controller.isCompetitionMode.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person, color: Colors.blue),
            SizedBox(width: 5),
            Text(
              '현재 위치',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            Icon(Icons.flag, color: Colors.red),
            SizedBox(width: 5),
            Text(
              '상대 위치',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildEndRunningButton(RunningController controller) {
    return ElevatedButton(
      onPressed: () async {
        await _showCustomModal(Get.context!);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        '러닝 종료',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Future<void> _showCustomModal(BuildContext context) async {
    final RunningController controller = Get.find<RunningController>();

    String title = '';
    String content = '';
    if (controller.isCompetitionMode.value) {
      title = '${controller.typeKorean.value} 대결 러닝';
      content = '${controller.typeKorean.value} 대결 러닝을 중지하셨습니다';
    } else {
      title = '${controller.typeKorean.value} 러닝';
      content = '${controller.typeKorean.value} 러닝을 중지하셨습니다';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: title,
          content: content,
          onConfirm: () {
            Navigator.of(context).pop(); // 모달 닫기
            controller.endRunningByButton();
            Get.toNamed('/writereview');
          },
        );
      },
    );
  }

  void _showStopLocationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: '출발지 이동',
          content: '시작 지점 10m 이내로 이동해주세요',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      },
    );
  }

  Future<void> _showCustomModalWhenArrive(BuildContext context) async {
    final RunningController controller = Get.find<RunningController>();

    String title = '';
    String content = '';
    if (controller.isCompetitionMode.value) {
      title = '${controller.typeKorean.value} 대결 러닝';
      if (controller.value.value.elapsedTime <
          controller.competitionRecords.last.elapsedTime) {
        content = '${controller.typeKorean.value} 대결 러닝을 승리하셨습니다';
      } else {
        content = '${controller.typeKorean.value} 대결 러닝을 패배하셨습니다';
      }
    } else {
      title = '${controller.typeKorean.value} 러닝';
      content = '${controller.typeKorean.value} 러닝을 완료하셨습니다';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: title,
          content: content,
          onConfirm: () {
            Navigator.of(context).pop(); // 모달 닫기
            controller.endRunning2();
            Get.toNamed('/writereview');
          },
        );
      },
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
    if (widget.controller.isCanStart.value) widget.controller.startRun2();
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
