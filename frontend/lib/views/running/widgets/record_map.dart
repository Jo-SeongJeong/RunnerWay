import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/record_controller.dart'; // RecordController 불러오기

class RecordMap extends StatefulWidget {
  final double height; // 높이 값을 받기 위한 파라미터

  const RecordMap({super.key, required this.height});

  @override
  State<RecordMap> createState() => _RecordMapState();
}

class _RecordMapState extends State<RecordMap> {
  Set<Marker> markers = {};
  var _polyline = <Polyline>{};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
  }

  // 지도 경계 설정하는 함수
  void _setMapFitToBounds(List<LatLng> points) {
    LatLngBounds bounds;
    if (points.length == 1) {
      bounds = LatLngBounds(southwest: points.first, northeast: points.first);
    } else {
      bounds = _createBoundsFromLatLngList(points);
    }
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  // LatLng 리스트를 이용해 경계 만들기
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
    final recordController =
        Get.find<RecordController>(); // RecordController 사용

    return Container(
      height: widget.height, // 전달받은 높이를 사용
      child: Obx(
        () {
          // 경로 데이터가 없을 때
          if (recordController.coursePoints.isEmpty) {
            return Container(
              color: Colors.black12.withOpacity(0.03),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/error.png',
                      width: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
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

          // 경로 데이터가 있을 때
          if (recordController.coursePoints.isNotEmpty) {
            LatLng startPoint = recordController.coursePoints.first;
            LatLng endPoint = recordController.coursePoints.last;

            // 시작점 마커
            markers.add(
              Marker(
                markerId: const MarkerId("start"),
                position: startPoint,
                infoWindow: const InfoWindow(
                  title: "Start Point",
                  snippet: "This is the start point.",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            );

            // 종료점 마커
            markers.add(
              Marker(
                markerId: const MarkerId("end"),
                position: endPoint,
                infoWindow: const InfoWindow(
                  title: "End Point",
                  snippet: "This is the end point.",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            );

            // 폴리라인(경로)
            _polyline = {
              Polyline(
                polylineId: const PolylineId("route"),
                points: recordController.coursePoints,
                color: Colors.blue,
                width: 5,
              ),
            };

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setMapFitToBounds(recordController.coursePoints);
            });
          }

          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              if (recordController.coursePoints.isNotEmpty) {
                _setMapFitToBounds(recordController.coursePoints);
              }
            },
            polylines: _polyline,
            myLocationButtonEnabled: true,
            markers: markers,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: recordController.coursePoints.first,
              zoom: 15,
            ),
          );
        },
      ),
    );
  }
}
