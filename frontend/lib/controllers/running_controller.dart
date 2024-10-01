import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/models/running_map_model.dart';
import 'package:frontend/models/running_record_model.dart';
import 'package:frontend/services/running_service.dart';
import 'package:frontend/services/file_service.dart';

class RunningController extends GetxController {
  late final RunningService _runningService;
  late final FileService _fileService;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;
  DateTime? _startTime;
  var isLoading = true.obs;
  final value = RunningMapModel().obs;
  GoogleMapController? _mapController;

  var isOfficialRun = false.obs;
  var isCompetitionMode = false.obs;
  List<RunningRecord> competitionRecords = [];
  int competitionRecordIndex = 0;
  Timer? competitionTimer;

  RunningRecord? _lastCompetitionRecord;

  RunningRecord? _currentRecord;
  RunningRecord? _nextRecord;
  int _currentRecordIndex = 0;

  String? type;
  String? courseid;
  String? opponentid;
  final typeKorean = ''.obs;

  RunningController() {
    _runningService = RunningService();
    _fileService = FileService();
  }

  @override
  void onInit() {
    super.onInit();

    // route에서 파라미터 가져오기
    type = Get.parameters['type'];
    courseid = Get.parameters['courseid'];
    opponentid = Get.parameters['opponentid'];

    initialize();
  }

  Future<void> initialize() async {
    dev.log('초기화 시작');
    if (opponentid != '0') {
      isCompetitionMode.value = true;
      dev.log('대결 상대: $opponentid');
    }

    if (type == 'free') {
      dev.log('Free running mode initialized.');
    } else if (type == 'official') {
      isOfficialRun.value = true;
      dev.log('Official running mode initialized with courseid: $courseid');
    } else if (type == 'user') {
      dev.log('User running mode initialized with courseid: $courseid');
    }

    dev.log('type: ${type}, courseid: ${courseid}, opponentid: ${opponentid}');

    isLoading(true);
    await _setInitialLocation();
    getRunTypeText();
    isLoading(false);
  }

  // TODO
  Future<void> startRun(
      {bool isOfficial = false, bool isCompetition = false}) async {
    isOfficialRun.value = isOfficial;
    isCompetitionMode.value = isCompetition;
    if (isOfficialRun.value) {
      await loadSavedPath();
    }
    if (isCompetitionMode.value) {
      await loadCompetitionRecords();
      startCompetitionMode();
    }
    _startLocationUpdates();
    _startTimer();
  }

  Future<void> startRun2() async {
    if (isOfficialRun.value) {
      await loadSavedPath();
    }
    if (isCompetitionMode.value) {
      await loadCompetitionRecords();
      startCompetitionMode();
    }
    _startLocationUpdates();
    _startTimer();
  }

  void getRunTypeText() {
    if (type == 'free') {
      typeKorean.value = '자유';
    } else if (type == 'official') {
      typeKorean.value = '공식';
    } else if (type == 'user') {
      typeKorean.value = '유저';
    } else {
      typeKorean.value = '자유';
    }
  }

  Future<void> _setInitialLocation() async {
    Position position = await _runningService.getCurrentPosition();
    LatLng initialLocation = LatLng(position.latitude, position.longitude);
    value.update((val) {
      val?.myCurrentLocation = initialLocation;
      val?.mapCenter = initialLocation;
    });
  }

  void _startLocationUpdates() {
    _positionSubscription =
        _runningService.getPositionStream().listen((Position position) {
      _updateLocation(
          LatLng(position.latitude, position.longitude), position.speed);
      _moveCameraToPosition(position);
    });
  }

  void _moveCameraToPosition(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        ),
      ),
    );
    _logLocation(LatLng(position.latitude, position.longitude));
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateElapsedTime();
    });
  }

  void _updateLocation(LatLng newLocation, double speed) {
    value.update((val) {
      if (val != null && val.pointOnMap.isNotEmpty) {
        double distance =
            _runningService.calculateDistance(val.pointOnMap.last, newLocation);
        val.totalDistance += distance;
      }

      val?.currentSpeed = speed;
      val?.currentPace = _runningService.calculatePace(speed);

      val?.pointOnMap.add(newLocation);
      val?.mapCenter = newLocation;

      _updateRealTimePolyline();
    });

    _saveRunningRecord(newLocation);
  }

  void _updateElapsedTime() {
    if (_startTime != null) {
      value.update((val) {
        val?.elapsedTime = _runningService.calculateElapsedTime(_startTime!);
      });
    }
  }

  void _logLocation(LatLng location) {
    value.update((val) {
      String logs = '위도: ${location.latitude}, 경도: ${location.longitude}, '
          '시간: ${val?.elapsedTime.inSeconds}초, '
          '총 거리: ${val?.totalDistance.toStringAsFixed(2)} m, '
          '페이스: ${val?.currentPace} '
          '속도: ${val?.currentSpeed}';
      dev.log(logs);
    });
  }

  void _updateRealTimePolyline() {
    value.update((val) {
      Polyline realTimePolyline =
          _runningService.createRealTimePolyline(val?.pointOnMap ?? []);
      val?.polyline.removeWhere(
          (polyline) => polyline.polylineId.value == 'realTimePath');
      val?.polyline.add(realTimePolyline);
    });
  }

  Future<void> loadSavedPath() async {
    if (isOfficialRun.value) {
      Polyline savedPathPolyline = await _runningService
          .createSavedPathPolyline('walking_log_noeun_yuseong_3_seconds');
      value.update((val) {
        val?.polyline.add(savedPathPolyline);
      });
    }
  }

  Future<void> loadCompetitionRecords() async {
    competitionRecords = await _fileService
        .readSavedRunningRecords('walking_log_noeun_yuseong_3_seconds');
    competitionRecordIndex = 0;
  }

  void startCompetitionMode() {
    competitionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (competitionRecordIndex < competitionRecords.length) {
        updateCompetitionMarker();
        competitionRecordIndex++;
      } else {
        competitionTimer?.cancel();
      }
    });
  }

  void updateCompetitionMarker() {
    if (competitionRecords.isEmpty || value.value.elapsedTime == Duration.zero)
      return;

    int currentTimeSeconds = value.value.elapsedTime.inSeconds;

    // Find the current and next records
    while (_currentRecordIndex < competitionRecords.length - 1 &&
        competitionRecords[_currentRecordIndex + 1].elapsedTime.inSeconds <=
            currentTimeSeconds) {
      _currentRecordIndex++;
    }

    _currentRecord = competitionRecords[_currentRecordIndex];
    _nextRecord = _currentRecordIndex < competitionRecords.length - 1
        ? competitionRecords[_currentRecordIndex + 1]
        : null;

    LatLng interpolatedPosition;
    if (_nextRecord != null) {
      double progress =
          (currentTimeSeconds - _currentRecord!.elapsedTime.inSeconds) /
              (_nextRecord!.elapsedTime.inSeconds -
                  _currentRecord!.elapsedTime.inSeconds);
      progress =
          min(1.0, max(0.0, progress)); // Ensure progress is between 0 and 1

      interpolatedPosition = LatLng(
        _currentRecord!.latitude +
            (_nextRecord!.latitude - _currentRecord!.latitude) * progress,
        _currentRecord!.longitude +
            (_nextRecord!.longitude - _currentRecord!.longitude) * progress,
      );
    } else {
      interpolatedPosition =
          LatLng(_currentRecord!.latitude, _currentRecord!.longitude);
    }

    value.update((val) {
      val?.markers
          .removeWhere((marker) => marker.markerId.value == 'competition');
      val?.markers.add(
        Marker(
          markerId: MarkerId('competition'),
          position: interpolatedPosition,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    });
  }

  void _saveRunningRecord(LatLng location) {
    if (_startTime == null) return; // 시작 시간이 없으면 저장하지 않음

    RunningRecord record = RunningRecord(
      latitude: location.latitude,
      longitude: location.longitude,
      elapsedTime: DateTime.now().difference(_startTime!),
    );
    _fileService.appendRunningRecord(record, 'currentRun');
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> endRunning() async {
    _positionSubscription?.cancel();
    _timer?.cancel();
    competitionTimer?.cancel();

    try {
      final recordId = await _runningService.endRunningSession();
      Get.toNamed('/running-result', arguments: recordId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to end running session');
    }
  }

  Future<void> endRunning2() async {
    _positionSubscription?.cancel();
    _timer?.cancel();
    competitionTimer?.cancel();

    try {
      final tempRecordId = 'tmp_${DateTime.now().millisecondsSinceEpoch}';
      await _fileService.renameFile2(tempRecordId);

      dev.log('Running session ended. Data saved as: $tempRecordId.json');
    } catch (e) {
      print('Error ending running session: $e');
      Get.snackbar(
        'Error',
        'Failed to save running record',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }

  Duration get currentCompetitionTime {
    return _lastCompetitionRecord?.elapsedTime ?? Duration.zero;
  }

  @override
  void onClose() {
    _positionSubscription?.cancel();
    _timer?.cancel();
    competitionTimer?.cancel();
    _mapController?.dispose();
    super.onClose();
  }
}
