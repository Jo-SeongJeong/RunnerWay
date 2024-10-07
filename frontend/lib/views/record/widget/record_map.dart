// import 'dart:developer'; // log 사용을 위해 추가
// import 'package:flutter/material.dart';
// import 'package:frontend/controllers/record_controller.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:get/get.dart';
//
// class RecordMap extends StatefulWidget {
//   const RecordMap({Key? key}) : super(key: key);
//
//   @override
//   State<RecordMap> createState() => _RecordMap();
// }
//
// class _RecordMap extends State<RecordMap> {
//   final RecordController recordController = Get.find<RecordController>();
//   GoogleMapController? _mapController;
//
//   @override
//   Widget build(BuildContext context) {
//     // RecordMapModel에서 마커와 폴리라인을 가져오기
//     final polyline = recordController.polyline;
//
//     // type이 자유이면 파란색 폴리라인만, 그렇지 않으면 모든 폴리라인을 표시
//     final filteredPolyline = polyline;
//
//     // 폴리라인을 log로 출력해서 확인
//     for (var line in filteredPolyline) {
//       log('Polyline ID: ${line.polylineId.value}');
//       log('Polyline Color: ${line.color}');
//       log('Polyline Points: ${line.points}');
//     }
//
//     return Container(
//       height: 300,
//       child: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//
//           // 지도 생성 후 경로를 화면에 맞추기
//           if (recordController.value.value.pointOnMap.isNotEmpty) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _setMapFitToBounds(recordController.value.value.pointOnMap);
//             });
//           }
//         },
//         polylines: filteredPolyline, // 필터링된 폴리라인만 표시
//         myLocationButtonEnabled: true,
//         markers: recordController.value.value.markers,
//         zoomControlsEnabled: false,
//         initialCameraPosition:
//             recordController.value.value.myCurrentLocation != null
//                 ? CameraPosition(
//                     target: recordController.value.value.myCurrentLocation!,
//                     zoom: 15)
//                 : const CameraPosition(target: LatLng(0, 0)),
//       ),
//     );
//   }
//
//   void _setMapFitToBounds(List<LatLng> points) {
//     LatLngBounds bounds;
//
//     if (points.length == 1) {
//       bounds = LatLngBounds(southwest: points.first, northeast: points.first);
//     } else {
//       bounds = _createBoundsFromLatLngList(points);
//     }
//
//     _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//   }
//
//   LatLngBounds _createBoundsFromLatLngList(List<LatLng> points) {
//     double minLat = points.first.latitude;
//     double maxLat = points.first.latitude;
//     double minLng = points.first.longitude;
//     double maxLng = points.first.longitude;
//
//     for (var point in points) {
//       if (point.latitude < minLat) minLat = point.latitude;
//       if (point.latitude > maxLat) maxLat = point.latitude;
//       if (point.longitude < minLng) minLng = point.longitude;
//       if (point.longitude > maxLng) maxLng = point.longitude;
//     }
//
//     return LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );
//   }
// }
