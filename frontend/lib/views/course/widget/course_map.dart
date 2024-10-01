import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CourseMap extends StatefulWidget {
  const CourseMap({super.key});

  @override
  State<CourseMap> createState() => _ResultMap();
}

class _ResultMap extends State<CourseMap> {
  LatLng myCurrentLocation = const LatLng(36.35665, 127.321678);

  Set<Marker> markers = {};

  final Set<Polyline> _polyline = {};

  List<LatLng> pointOnMap = [
    // const LatLng(36.3, 127.3),
    const LatLng(36.3550, 127.2983),
    const LatLng(36.355157, 127.299944),
    const LatLng(36.353101, 127.299638),
    const LatLng(36.360392, 127.305689),
    const LatLng(36.359053, 127.309948),
    const LatLng(36.359426, 127.327270),
    const LatLng(36.357811, 127.331798),
    const LatLng(36.356515, 127.331304),
    const LatLng(36.353789, 127.341561),
    const LatLng(36.357314, 127.342929),
    const LatLng(36.357102, 127.344523),
    const LatLng(36.358300, 127.345056),
  ];

  @override
  void initState() {
    super.initState();

    // 첫 번째 위치에 빨간 마커 추가
    markers.add(
      Marker(
        markerId: MarkerId("start"),
        position: pointOnMap.first,
        infoWindow: const InfoWindow(
          title: "Start Point",
          snippet: "This is the start point.",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // 마지막 위치에 마커 파란 추가
    markers.add(
      Marker(
        markerId: MarkerId("end"),
        position: pointOnMap.last,
        infoWindow: const InfoWindow(
          title: "End Point",
          snippet: "This is the end point.",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // 경로 폴리라인 추가
    setState(() {
      _polyline.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: pointOnMap,
          color: Colors.blue,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        polylines: _polyline,
        myLocationButtonEnabled: false,
        markers: markers,
        // 확대 축소 버튼 삭제
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 13,
        ),
      ),
    );
  }
}
