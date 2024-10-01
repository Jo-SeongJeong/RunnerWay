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
  Set<Marker> markers = {};
  var _polyline = <Polyline>{};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
  }

  void _setMapFitToBounds(List<LatLng> points) {
    // 모든 경로 좌표를 포함하는 LatLngBounds 생성
    LatLngBounds bounds;
    if (points.length == 1) {
      bounds = LatLngBounds(southwest: points.first, northeast: points.first);
    } else {
      bounds = _createBoundsFromLatLngList(points);
    }

    // LatLngBounds에 맞게 카메라를 이동
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _createBoundsFromLatLngList(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseController =
        Get.find<CourseController>(); // CourseController 인스턴스 가져오기

    return Container(
      child: Obx(
        () {
          // 경로 데이터가 없거나 비어 있을 경우 처리
          if (courseController.coursePoints.isEmpty) {
            return Container(
              color: Colors.black12.withOpacity(0.03),
              padding: EdgeInsets.symmetric(
                vertical: 80,
              ),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icons/error.png',
                      width: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '코스 경로 데이터가 없어요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffF44237),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (courseController.coursePoints.isNotEmpty) {
            // 경로의 시작점과 끝점 설정
            LatLng startPoint = courseController.coursePoints.first;
            LatLng endPoint = courseController.coursePoints.last;

            // 마커 추가
            markers.add(
              Marker(
                markerId: MarkerId("start"),
                position: startPoint,
                infoWindow: const InfoWindow(
                  title: "Start Point",
                  snippet: "This is the start point.",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            );

            markers.add(
              Marker(
                markerId: MarkerId("end"),
                position: endPoint,
                infoWindow: const InfoWindow(
                  title: "End Point",
                  snippet: "This is the end point.",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            );

            // 경로 폴리라인 설정
            _polyline = {
              Polyline(
                polylineId: const PolylineId("route"),
                points: courseController.coursePoints,
                color: Colors.blue,
                width: 5, // 폴리라인 두께
              ),
            };

            // 지도가 준비된 후 경로 전체를 보여주는 함수 호출
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setMapFitToBounds(courseController.coursePoints);
            });
          }

          return Container(
            height: 300,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if (courseController.coursePoints.isNotEmpty) {
                  _setMapFitToBounds(courseController.coursePoints);
                }
              },
              polylines: _polyline,
              myLocationButtonEnabled: true,
              markers: markers,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: courseController.coursePoints.first,
              ),
            ),
          );
        },
      ),
    );
  }
}
