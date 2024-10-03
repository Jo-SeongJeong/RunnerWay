import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/course_controller.dart';

class CourseMap extends StatefulWidget {
  final double height; // 높이 값을 double 타입으로 명시

  const CourseMap({super.key, required this.height});

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
    final courseController = Get.find<CourseController>();

    return Container(
      height: widget.height, // 높이를 widget.height로 설정
      child: Obx(
        () {
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
            LatLng startPoint = courseController.coursePoints.first;
            LatLng endPoint = courseController.coursePoints.last;

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

            _polyline = {
              Polyline(
                polylineId: const PolylineId("route"),
                points: courseController.coursePoints,
                color: Colors.blue,
                width: 5,
              ),
            };

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setMapFitToBounds(courseController.coursePoints);
            });
          }

          return GoogleMap(
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
          );
        },
      ),
    );
  }
}
