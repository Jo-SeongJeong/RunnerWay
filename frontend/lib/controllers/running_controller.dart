import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/course_controller.dart';
import 'package:frontend/models/ranking.dart';
import 'package:frontend/models/ranking_upload_model.dart';
import 'package:frontend/services/course_service.dart';
import 'package:frontend/utils/s3_image_upload.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/models/running_map_model.dart';
import 'package:frontend/models/running_record_model.dart';
import 'package:frontend/services/running_service.dart';
import 'package:frontend/services/file_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flowery_tts/flowery_tts.dart';

class RunningController extends GetxController {
  late final RunningService _runningService;
  late final CourseService _courseService = CourseService();
  late final FileService _fileService;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;
  DateTime? startTime;
  var isLoading = true.obs;
  final value = RunningMapModel().obs;
  GoogleMapController? _mapController;

  // tts를 위한 flowery 추가
  final Flowery tts = const Flowery();
  final AudioPlayer audioPlayer = AudioPlayer();

  var isOfficialRun = false.obs;
  var isCompetitionMode = false.obs;
  var isRun = true.obs;
  var isCanStart = true.obs;
  List<RunningRecord> competitionRecords = [];
  int competitionRecordIndex = 0;
  Timer? competitionTimer;

  RunningRecord? _lastCompetitionRecord;

  RunningRecord? _currentRecord;
  RunningRecord? _nextRecord;
  int _currentRecordIndex = 0;

  String? type;
  String? courseid;
  String? varid; // type이 free이고 대결 시 recordid이고 나머지 경우 rankid
  final typeKorean = ''.obs;

  LatLng? _departurePoint; // 시작지점 좌표를 저장하는 변수
  LatLng? _destinationPoint; // 도착지점 좌표를 저장하는 변수
  LatLng startPoint = LatLng(0.0, 0.0); // 시작 위치

  var ranking = <Ranking>[].obs;
  var isModalShown = false.obs;

  LatLng? _lastTtsPosition; // 마지막으로 TTS 알림이 발생한 위치
  final int ttsDistanceThreshold = 50;

  RunningController() {
    _runningService = RunningService();
    _fileService = FileService();
  }

  @override
  void onInit() {
    print('여기냐?');
    super.onInit();

    // route에서 파라미터 가져오기
    type = Get.parameters['type'];
    courseid = Get.parameters['courseid'];
    varid = Get.parameters['varid'];

    value.update((val) {
      val?.myCurrentLocation = LatLng(0.0, 0.0); // 초기값으로 설정
      val?.mapCenter = LatLng(0.0, 0.0); // 초기 중심 좌표 설정
      val?.currentSpeed = 0.0; // 초기 속도 설정
      val?.currentPace = '0:00'; // 초기 페이스 설정
      val?.totalDistance = 0.0; // 초기 총 거리 설정
      val?.elapsedTime = Duration.zero; // 경과 시간 초기화
      val?.pointOnMap = []; // 지도상의 경로 초기화
      val?.polyline.clear(); // 폴리라인 초기화
      val?.markers = {}; // 마커 초기화
    });

    initialize();
  }

  Future<void> initialize() async {
    print('아니면 여기?');
    dev.log('초기화 시작');
    await _fileService.resetJson();
    if (varid != '0') {
      isCompetitionMode.value = true;
      dev.log('대결 상대: $varid');
    }

    await setStartPoint();

    if (type == 'free') {
      dev.log('Free running mode initialized.');
    } else if (type == 'official') {
      isOfficialRun.value = true;
      await loadSavedPath();
      await _checkIfStartLocationIsValid(); // 경로의 시작 위치 확인
      dev.log('Official running mode initialized with courseid: $courseid');
    } else if (type == 'user') {
      isOfficialRun.value = true;
      await loadSavedPath();
      await _checkIfStartLocationIsValid(); // 경로의 시작 위치 확인
      dev.log('User running mode initialized with courseid: $courseid');
    }

    dev.log('type: ${type}, courseid: ${courseid}, varid: ${varid}');

    isLoading(true);
    await _setInitialLocation();
    getRunTypeText();
    isLoading(false);
  }

  // TODO main인 running_view에서 사용하지 않고 예전 코드임
  Future<void> startRun(
      {bool isOfficial = false, bool isCompetition = false}) async {
    isOfficialRun.value = isOfficial;
    isCompetitionMode.value = isCompetition;
    if (isCompetitionMode.value) {
      await loadCompetitionRecords();
      startCompetitionMode();
    }
    _startLocationUpdates();
    _startTimer();
  }

  Future<void> startRun2() async {
    value.update((val) {
      val?.myCurrentLocation = LatLng(0.0, 0.0); // 초기값으로 설정
      val?.mapCenter = LatLng(0.0, 0.0); // 초기 중심 좌표 설정
      val?.currentSpeed = 0.0; // 초기 속도 설정
      val?.currentPace = '0:00'; // 초기 페이스 설정
      val?.totalDistance = 0.0; // 초기 총 거리 설정
      val?.elapsedTime = Duration.zero; // 경과 시간 초기화
      val?.pointOnMap = []; // 지도상의 경로 초기화
      val?.polyline.clear(); // 폴리라인 초기화
      val?.markers = {}; // 마커 초기화
    });
    if (isOfficialRun.value) {
      await loadSavedPath();
    }
    if (isCompetitionMode.value) {
      if (type == 'official' || type == 'user') {
        await loadCompetitionRecords();
      } else {
        await loadCompetitionRecordsFromLocal();
      }
      startCompetitionMode();
    }
    _startLocationUpdates();
    _startTimer();
    if (isRun.value && !isModalShown.value)
      await _playTTS("러닝을 시작합니다. 출발해주세요.");
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

  Future<void> setStartPoint() async {
    Position currentPosition = await _runningService.getCurrentPosition();
    LatLng currentLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    startPoint = currentLocation;

    dev.log('현재 위치: ${startPoint}');
  }

  Future<void> _checkIfStartLocationIsValid() async {
    dev.log('시작 위치: ${_departurePoint}');

    if (_departurePoint != null) {
      LatLng startLocation = _departurePoint!;

      // 현재 위치와 경로 시작점의 거리 계산
      double distanceToStart =
          _runningService.calculateDistance(startPoint, startLocation);
      if (distanceToStart > 20.0) {
        // 10m 이내가 아닌 경우 사용자에게 알림 처리
        isCanStart.value = false;
      } else {
        isRun.value = true; // 10m 이내면 러닝을 시작할 수 있음
      }
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
          zoom: 19.5,
        ),
      ),
    );
    _logLocation(LatLng(position.latitude, position.longitude));
  }

  void _startTimer() {
    startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateElapsedTime();
    });
  }

  void _updateLocation(LatLng newLocation, double speed) {
    value.update((val) {
      if (val != null && val.pointOnMap.isNotEmpty) {
        double distance = (_runningService.calculateDistance(
                val.pointOnMap.last, newLocation)) /
            1000;

        dev.log('거리 차 : ${distance}');
        val.totalDistance += distance;
        dev.log('현재 간 거리: ${val.totalDistance}');
      }

      val?.currentSpeed = speed;
      val?.currentPace = _runningService.calculatePace(speed);

      val?.pointOnMap.add(newLocation);
      val?.mapCenter = newLocation;

      _updateRealTimePolyline();

      if (isCompetitionMode.value) {
        _checkAndNotifyDistanceToCompetitor(newLocation);
      }
    });

    _checkIfArrivedAtDestination(newLocation);
    _saveRunningRecord(newLocation);
  }

  void _updateElapsedTime() {
    if (startTime != null) {
      value.update((val) {
        val?.elapsedTime = _runningService.calculateElapsedTime(startTime!);
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

  // TODO view 시작 시 method 순서 변경해서 load하게 해야 함
  Future<void> loadSavedPath() async {
    // TODO 서비스로 이동 시켜야 함
    if (isOfficialRun.value) {
      // if (type == 'official') {
      List<LatLng> savedPath = await _courseService
          .getCoursePoints(int.tryParse(courseid ?? '') ?? 0);

      if (savedPath.isNotEmpty) {
        _departurePoint = savedPath.first; // 시작지점 설정
        _destinationPoint = savedPath.last; // 도착지점 설정
      }

      Polyline savedPathPolyline = Polyline(
        polylineId: PolylineId('savedPath'),
        color: Colors.red, // 저장된 경로는 빨간색으로 표시
        width: 5,
        points: savedPath,
      );
      value.update((val) {
        val?.polyline.add(savedPathPolyline);
      });
    }
    // if (isOfficialRun.value) {
    //   Polyline savedPathPolyline = await _runningService
    //       .createSavedPathPolyline('walking_log_noeun_yuseong_3_seconds');
    //   value.update((val) {
    //     val?.polyline.add(savedPathPolyline);
    //   });
    // }
  }

  Future<void> loadCompetitionRecords() async {
    // TODO 자유 코스에서 대결일 경우 내 로그에서 데이터 가져오게 해야 함

    competitionRecords = await _runningService
        .readSavedRunningRecordLog(int.parse(varid ?? '0'));

    dev.log('competitionrecords 결과값: ${competitionRecords}');

    competitionRecordIndex = 0;
  }

  Future<void> loadCompetitionRecordsFromLocal() async {
    competitionRecords =
        await _runningService.readSavedRunningLocalLog(int.parse(varid ?? '0'));

    dev.log('competitionrecords 결과값: ${competitionRecords}');

    competitionRecordIndex = 0;
  }

  void _checkIfArrivedAtDestination(LatLng currentLocation) {
    if (_destinationPoint != null) {
      // 도착지점과 현재 위치의 거리를 계산 (미터 단위)
      double distanceToDestination = _runningService.calculateDistance(
          currentLocation, _destinationPoint!);

      if (distanceToDestination <= 20.0) {
        // 10m 이내 도착 시 러닝 종료
        if (!isModalShown.value) _playTTS("러닝을 종료합니다.");
        endRunning2();
        isRun.value = false;
      }
    }
  }

  void startCompetitionMode() {
    competitionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentRecordIndex < competitionRecords.length - 1) {
        updateCompetitionMarker();
      } else {
        competitionTimer?.cancel();
      }
    });
  }

  void updateCompetitionMarker() {
    if (competitionRecords.isEmpty ||
        value.value.elapsedTime == Duration.zero) {
      return;
    }

    int currentTimeSeconds = value.value.elapsedTime.inSeconds;

    // 현재 시간에 해당하는 기록과 다음 기록을 찾음
    while (_currentRecordIndex < competitionRecords.length - 1 &&
        competitionRecords[_currentRecordIndex + 1].elapsedTime.inSeconds <=
            currentTimeSeconds) {
      _currentRecordIndex++;
    }

    _currentRecord = competitionRecords[_currentRecordIndex];
    _nextRecord = _currentRecordIndex < competitionRecords.length - 1
        ? competitionRecords[_currentRecordIndex + 1]
        : null;

    if (_nextRecord == null) {
      // 마지막 지점에 도달했으면 현재 위치로 설정
      return;
    }

    // 현재 시간과 다음 기록 시간 사이의 경과 시간 계산 (예: 3초)
    int segmentTime = _nextRecord!.elapsedTime.inSeconds -
        _currentRecord!.elapsedTime.inSeconds;
    int elapsedInSegment =
        currentTimeSeconds - _currentRecord!.elapsedTime.inSeconds;

    // 이동할 위치 계산
    double progress = elapsedInSegment / segmentTime; // 매 1초마다 비율을 계산
    progress = min(1.0, max(0.0, progress)); // progress가 0~1 사이로 보정

    // 보정된 위치 계산 (두 위치 사이를 progress 비율로 보정)
    LatLng interpolatedPosition = LatLng(
      _currentRecord!.latitude +
          (_nextRecord!.latitude - _currentRecord!.latitude) * progress,
      _currentRecord!.longitude +
          (_nextRecord!.longitude - _currentRecord!.longitude) * progress,
    );

    // 보정된 위치로 마커 업데이트
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
    if (startTime == null) return; // 시작 시간이 없으면 저장하지 않음

    RunningRecord record = RunningRecord(
      latitude: location.latitude,
      longitude: location.longitude,
      elapsedTime: DateTime.now().difference(startTime!),
    );
    _fileService.appendRunningRecord(record, 'tmp');
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
      // Get.snackbar('Error', 'Failed to end running session');
    }
  }

  Future<void> endRunning2() async {
    _positionSubscription?.cancel();
    _timer?.cancel();
    competitionTimer?.cancel();

    final score =
        value.value.elapsedTime.toString().split('.').first.padLeft(8, "0");

    dev.log('최종 시간: ${score}');

    // 랭킹 등록 가능여부 판단 해야 함
    if (courseid != '0') {
      final response = await _runningService.getRegistRanking(
          int.parse(courseid ?? '0'), score);
      dev.log('랭커 등록 여부: ${response}');

      if (response) {
        // s3에 업로드
        final directory = await getApplicationDocumentsDirectory();
        final File tmpFile = File('${directory.path}/tmp.json');
        final url = await S3ImageUpload().uploadRankingLog(tmpFile);
        dev.log('url: ${url}');
        RankingUploadModel model = RankingUploadModel(
            courseId: int.parse(courseid ?? '0'), score: score, logPath: url);
        // 랭킹 등록
        final response = await _runningService.registRanking(model);
        dev.log('랭킹 등록 결과값: ${response}');
      }
      final fetchedCourseRanking =
          await CourseService().getCourseRanking(int.parse(courseid ?? '0'));
      ranking.assignAll(fetchedCourseRanking);
      dev.log('${ranking}');

      // 공식 유저 코스 시
      if (varid != '0') {
        //대결에 따른 결과 페이지로 이동 시켜야 해
      }
    }

    if (!isModalShown.value) await _playTTS("러닝을 종료합니다.");
  }

  Future<void> endRunningByButton() async {
    _positionSubscription?.cancel();
    _timer?.cancel();
    competitionTimer?.cancel();

    dev.log('버튼으로 중지');
    try {
      // 자유코스로 변경 및 코스, 상대방 초기화
      type = '자유';
      typeKorean.value = '자유';
      courseid = '0';
      varid = '0';
    } catch (e) {
      dev.log('Error ending running session: $e');
      // Get.snackbar(
      //   'Error',
      //   'Failed to save running record',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: Duration(seconds: 3),
      // );
    }
    if (!isModalShown.value) await _playTTS("러닝을 종료합니다.");
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

  Future<void> _playTTS(String text) async {
    try {
      final audio = await tts.tts(
        text: text,
        voice: 'korean_voice_name',
        speed: 1.3,
        translate: false,
      );
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/tts_output.mp3');
      file.writeAsBytesSync(audio);

      // Use DeviceFileSource for local file playback
      await audioPlayer.play(DeviceFileSource(file.path));
      dev.log('음성 파일이 재생되었습니다.');
    } catch (e) {
      dev.log('TTS 재생 실패: $e');
    }
  }

  Future<void> _checkAndNotifyDistanceToCompetitor(
      LatLng currentLocation) async {
    if (_nextRecord != null) {
      // 현재 위치와 상대방 위치 간의 거리 계산
      double distanceToCompetitor = _runningService.calculateDistance(
          currentLocation,
          LatLng(_nextRecord!.latitude, _nextRecord!.longitude));

      // 상대방의 총 이동 거리를 기록 사이에서 계산
      double competitorTotalDistance = _calculateTotalDistanceForCompetitor();

      // 나의 총 이동 거리
      double myTotalDistance = value.value.totalDistance;

      dev.log('상대방과의 거리: ${distanceToCompetitor} m');
      dev.log('내가 이동한 거리: ${myTotalDistance} m');
      dev.log('상대방이 이동한 거리: ${competitorTotalDistance} m');

      // 상대방과 앞서거나 뒤처짐 판단
      String positionStatus;
      if (myTotalDistance > competitorTotalDistance) {
        positionStatus = '앞서고 있습니다';
      } else {
        positionStatus = '뒤처지고 있습니다. 힘내세요!';
      }

      // 100m 이상 이동했을 때 TTS 알림
      if (_lastTtsPosition == null ||
          _runningService.calculateDistance(
                  _lastTtsPosition!, currentLocation) >=
              ttsDistanceThreshold) {
        await _playTTS(
            "현재 상대방 보다 ${distanceToCompetitor.toStringAsFixed(0)}미터 ${positionStatus}.");
        _lastTtsPosition = currentLocation;
      }
    }
  }

// 상대방의 총 이동 거리를 계산하는 함수 추가
  double _calculateTotalDistanceForCompetitor() {
    double totalDistance = 0.0;

    for (int i = 0; i < competitionRecordIndex - 1; i++) {
      LatLng start = LatLng(
          competitionRecords[i].latitude, competitionRecords[i].longitude);
      LatLng end = LatLng(competitionRecords[i + 1].latitude,
          competitionRecords[i + 1].longitude);

      totalDistance += _runningService.calculateDistance(start, end);
    }

    return totalDistance;
  }
}
