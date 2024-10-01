import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningMapModel {
  LatLng? myCurrentLocation;
  LatLng? mapCenter;

  Set<Marker> markers = {};
  final Set<Polyline> polyline = {};

  List<LatLng> pointOnMap = [];

  double totalDistance = 0.0; // 총 거리
  double currentSpeed = 0.0; // 현재 속도
  Duration elapsedTime = Duration.zero; // 경과 시간
  String currentPace = '0:00'; // 현재 페이스 (분/km)

  RunningMapModel();
}
