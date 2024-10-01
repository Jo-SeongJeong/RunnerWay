import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/course_controller.dart';

class CourseMap extends StatefulWidget {
  const CourseMap({super.key});

  @override
  State<CourseMap> createState() => _CourseMap();
}

class _CourseMap extends State<CourseMap> {
  LatLng myCurrentLocation = LatLng(36.35665, 127.321678);

  Set<Marker> markers = {};
  var _polyline = <Polyline>{};

  @override
  void initState() {
    super.initState();

    // 초기 마커 설정 (시작 지점 및 종료 지점 마커 설정)
    markers.add(
      Marker(
        markerId: MarkerId("start"),
        position: myCurrentLocation, // 임의로 현재 위치를 시작점으로 설정
        infoWindow: const InfoWindow(
          title: "Start Point",
          snippet: "This is the start point.",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseController =
        Get.find<CourseController>(); // CourseController 인스턴스 가져오기

    return Container(
      child: Obx(
        () {
          // coursePoints가 변경될 때마다 화면을 업데이트
          if (courseController.coursePoints.isNotEmpty) {
            // 마지막 위치에 파란 마커 추가
            markers.add(
              Marker(
                markerId: MarkerId("end"),
                position: courseController.coursePoints.last,
                infoWindow: const InfoWindow(
                  title: "End Point",
                  snippet: "This is the end point.",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            );

            // 경로 폴리라인 업데이트
            _polyline = {
              Polyline(
                polylineId: const PolylineId("route"),
                points: courseController.coursePoints,
                color: Colors.blue,
                width: 5, // 폴리라인 두께
              ),
            };
          }

          return Container(
            height: 250,
            child:
                // Make the map take the available space
                GoogleMap(
              polylines: _polyline,
              myLocationButtonEnabled: true,
              markers: markers,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: myCurrentLocation,
                zoom: 13,
              ),
            ),
          );
        },
      ),
    );
  }
}
