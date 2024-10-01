import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/controllers/running_controller.dart';

class FreeCourseRunningView extends StatelessWidget {
  final RunningController controller = Get.put(RunningController());

  FreeCourseRunningView({super.key});

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
                    controller.startRun();
                  },
                  initialCameraPosition: CameraPosition(
                    target: controller.value.value.mapCenter ?? LatLng(0, 0),
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
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '시간',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              '${(controller.value.value.totalDistance / 1000).toStringAsFixed(2)} km',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '페이스',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              '${controller.value.value.currentPace}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
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
                        Get.back();
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
