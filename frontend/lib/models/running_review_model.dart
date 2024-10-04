import 'package:frontend/models/personal_image.dart';
import 'package:intl/intl.dart';

class RunningReviewModel {
  final int courseId;
  final int score;
  final double runningDistance;
  final double calorie;
  final double averagePace;
  final String comment;
  final DateTime startDate;
  final DateTime finishDate;
  final PersonalImage? personalImage;

  RunningReviewModel({
    required this.courseId,
    required this.score,
    required this.runningDistance,
    required this.calorie,
    required this.averagePace,
    required this.comment,
    required this.startDate,
    required this.finishDate,
    this.personalImage,
  });

  String formatDate(DateTime date) {
    final DateTime dateWithoutMilliseconds = date.copyWith(
      millisecond: 0,
      microsecond: 0,
    );
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateWithoutMilliseconds);
  }

  String formatScore(int scoreInSeconds) {
    int hours = scoreInSeconds ~/ 3600;
    int minutes = (scoreInSeconds % 3600) ~/ 60;
    int seconds = scoreInSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  factory RunningReviewModel.fromJson(Map<String, dynamic> json) {
    return RunningReviewModel(
      courseId: json['courseId'],
      score: json['score'],
      runningDistance: json['runningDistance'].toDouble(),
      calorie: json['calorie'].toDouble(),
      averagePace: json['averagePace'].toDouble(),
      comment: json['comment'],
      startDate: DateTime.parse(json['startDate']),
      finishDate: DateTime.parse(json['finishDate']),
      personalImage: json['personalImage'] != null
          ? PersonalImage.fromJson(json['personalImage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'score': formatScore(score),
      'runningDistance': runningDistance,
      'calorie': calorie,
      'averagePace': averagePace,
      'comment': comment,
      'startDate': formatDate(startDate),
      'finishDate': formatDate(finishDate),
      'personalImage': personalImage != null
          ? {'url': personalImage?.url ?? '', 'path': personalImage?.path ?? ''}
          : null,
    };
  }

  @override
  String toString() {
    return 'RunningReviewModel(courseId: $courseId, score: $score, runningDistance: $runningDistance, calorie: $calorie, averagePace: $averagePace, comment: $comment, startDate: $startDate, finishDate: $finishDate, personalImage: $personalImage)';
  }

  RunningReviewModel copyWith({
    int? courseId,
    int? score,
    double? runningDistance,
    double? calorie,
    double? averagePace,
    String? comment,
    DateTime? startDate,
    DateTime? finishDate,
    PersonalImage? personalImage,
  }) {
    return RunningReviewModel(
      courseId: courseId ?? this.courseId,
      score: score ?? this.score,
      runningDistance: runningDistance ?? this.runningDistance,
      calorie: calorie ?? this.calorie,
      averagePace: averagePace ?? this.averagePace,
      comment: comment ?? this.comment,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      personalImage: personalImage ?? this.personalImage,
    );
  }
}
