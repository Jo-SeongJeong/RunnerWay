import 'dart:developer'; // log 사용을 위해 추가
import 'package:flutter/material.dart';
import 'package:frontend/controllers/running_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class WriteMap extends StatefulWidget {
  const WriteMap({Key? key}) : super(key: key);

  @override
  State<WriteMap> createState() => _WriteMap();
}

class _WriteMap extends State<WriteMap> {
  final RunningController runningController = Get.find<RunningController>();
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    // RunningMapModel에서 마커와 폴리라인을 가져오기
    final polyline = runningController.value.value.polyline;

    // type이 자유이면 파란색 폴리라인만, 그렇지 않으면 모든 폴리라인을 표시
    final filteredPolyline = runningController.type == '자유'
        ? polyline.where((line) => line.color == Colors.blue).toSet()
        : polyline;

    // 폴리라인을 log로 출력해서 확인
    for (var line in filteredPolyline) {
      log('Polyline ID: ${line.polylineId.value}');
      log('Polyline Color: ${line.color}');
      log('Polyline Points: ${line.points}');
    }

    return Container(
      height: 300,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;

          // 지도 생성 후 경로를 화면에 맞추기
          if (runningController.value.value.pointOnMap.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setMapFitToBounds(runningController.value.value.pointOnMap);
            });
          }
        },
        polylines: filteredPolyline, // 필터링된 폴리라인만 표시
        myLocationButtonEnabled: true,
        markers: runningController.value.value.markers,
        zoomControlsEnabled: false,
        initialCameraPosition:
            runningController.value.value.myCurrentLocation != null
                ? CameraPosition(
                    target: runningController.value.value.myCurrentLocation!,
                    zoom: 15)
                : const CameraPosition(target: LatLng(0, 0)),
      ),
    );
  }

  void _setMapFitToBounds(List<LatLng> points) {
    LatLngBounds bounds;

    if (points.length == 1) {
      bounds = LatLngBounds(southwest: points.first, northeast: points.first);
    } else {
      bounds = _createBoundsFromLatLngList(points);
    }

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
}
