import 'package:frontend/models/personal_image.dart';
import 'package:intl/intl.dart';

class RunningReviewModel {
  final int courseId;
  final String score;
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
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
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
      'score': score,
      'runningDistance': runningDistance,
      'calorie': calorie,
      'averagePace': averagePace,
      'comment': comment,
      'startDate': formatDate(startDate),
      'finishDate': formatDate(finishDate),
      'personalImage': personalImage?.toJson(),
    };
  }

  @override
  String toString() {
    return 'RunningReviewModel(courseId: $courseId, score: $score, runningDistance: $runningDistance, calorie: $calorie, averagePace: $averagePace, comment: $comment, startDate: $startDate, finishDate: $finishDate, personalImage: $personalImage)';
  }
}
