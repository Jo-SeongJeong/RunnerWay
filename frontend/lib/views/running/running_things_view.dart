import 'package:flutter/material.dart';
import 'package:frontend/controllers/network_controller.dart';
import 'package:frontend/views/etc/jwt_decode_view.dart';
import 'package:frontend/views/running/competition_course_running_view.dart';
import 'package:frontend/views/running/free_course_running_view.dart';
import 'package:frontend/views/running/official_course_running_view.dart';
import 'package:frontend/widgets/map/running_map.dart';
import '../../widgets/map/location.dart'; // location.dart 파일을 import
import '../../widgets/map/geolocation.dart'; // geolocation.dart 파일을 import
import '../../widgets/map/map.dart'; // map.dart 파일을 import
import '../../widgets/map/line.dart'; // line.dart 파일을 import
import '../../widgets/map/result_map.dart'; // result_map.dart 파일을 import
import 'ranking_list_view.dart'; // result_map.dart 파일을 import
import 'record_detail_view.dart'; // result_map.dart 파일을 import
import 'review_write_view.dart'; // result_map.dart 파일을 import
import 'package:get/get.dart'; // result_map.dart 파일을 import

class RunningThingsView extends StatelessWidget {
  const RunningThingsView({super.key});

  // location.dart 파일의 GeolocatorWidget 페이지로 이동하는 메소드
  void _navigateToLocation() {
    Get.to(() => const LocationPage());
  }

  // geolocation.dart 파일의 GeolocatorWidget 페이지로 이동하는 메소드
  void _navigateToGeoLocation() {
    Get.to(() => const GeolocatorWidget());
  }

  // map.dart 파일의 MyMap 페이지로 이동하는 메소드
  // void _navigateToMap() {
  //   Get.to(() => const MyMap());
  // }

  // line.dart 파일의 MyLine 페이지로 이동하는 메소드
  void _navigateToLine() {
    Get.to(() => MyLine());
  }

  void _navigateToRusultMap() {
    Get.to(() => const ResultMap());
  }

  void _navigateToRunningMap() {
    Get.to(() => const RunningMap());
  }

  void _navigateToRankingListView() {
    Get.to(() => RankingListView());
  }

  void _navigateToReviewDetailView() {
    Get.to(() => RecordDetailView());
  }

  void _navigateToReviewWriteView() {
    Get.to(() => ReviewWriteView());
  }

  @override
  Widget build(BuildContext context) {
    // 네트워크 체크
    Get.find<NetworkController>().checkInitialConnectivity(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Running Screen'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToLocation(), // 위치 페이지로 이동
              child: const Text('Go to Location'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToGeoLocation(), // 위치 페이지로 이동
              child: const Text('Go to GeoLocation'),
            ),
            // ElevatedButton(
            //   onPressed: () => _navigateToMap(), // 맵 페이지로 이동
            //   child: const Text('Go to Map'),
            // ),
            ElevatedButton(
              onPressed: () => _navigateToLine(), // 라인 페이지로 이동
              child: const Text('Go to Line'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToRusultMap(),
              // Navigates to the Polyline page
              child: const Text('Go to ResultMap'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToRunningMap(),
              // Navigates to the Polyline page
              child: const Text('Go to RunningMap'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToRankingListView(),
              // Navigates to the RankingList page
              child: const Text('Go to RankingList'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToReviewDetailView(),
              // Navigates to the RunningDetail page
              child: const Text('Go to ReviewDetail'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToReviewWriteView(),
              // Navigates to the RunningDetail page
              child: const Text('Go to ReviewWrite'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => JwtDecodeView()),
              // Navigates to the RunningDetail page
              child: const Text('Go to JWTDecode'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => FreeCourseRunningView()),
              // Navigates to the RunningDetail page
              child: const Text('Go to Free Course Running'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => OfficialCourseRunningView()),
              // Navigates to the RunningDetail page
              child: const Text('Go to Official Course Running'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => CompetitionCourseRunningView()),
              // Navigates to the RunningDetail page
              child: const Text('Go to Competition Course Running'),
            ),
          ],
        ),
      ),
    );
  }
}
