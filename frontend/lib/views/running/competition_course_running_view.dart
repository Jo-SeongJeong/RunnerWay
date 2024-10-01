import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/controllers/running_controller.dart';

class CompetitionCourseRunningView extends StatelessWidget {
  final RunningController controller = Get.put(RunningController());

  CompetitionCourseRunningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 500,
                child: GoogleMap(
                  polylines: controller.value.value.polyline,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController mapController) {
                    controller.onMapCreated(mapController);
                    controller.startRun(isOfficial: true, isCompetition: true);
                    // 더 자주 업데이트하도록 변경
                    Timer.periodic(Duration(milliseconds: 16), (_) {
                      // 약 60fps
                      controller.updateCompetitionMarker();
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                        controller.value.value.mapCenter ?? const LatLng(0, 0),
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          '대결 모드',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTimerColumn('현재 기록', Colors.blue,
                            controller.value.value.elapsedTime),
                        _buildTimerColumn('상대 기록', Colors.red,
                            controller.currentCompetitionTime),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoColumn('이동 거리',
                            '${(controller.value.value.totalDistance / 1000).toStringAsFixed(2)} km'),
                        _buildInfoColumn(
                            '페이스', controller.value.value.currentPace),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildLegend(),
                    const SizedBox(height: 20),
                    _buildEndRunningButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
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

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLegend() {
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
  }

  Widget _buildEndRunningButton() {
    return ElevatedButton(
      onPressed: () async {
        await controller.endRunning2();
        await Future.delayed(const Duration(seconds: 6));
        Get.back();
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
}
