import 'package:flutter/material.dart';

class ReviewRecordItem extends StatelessWidget {
  final num value;
  final String label;

  const ReviewRecordItem({
    super.key,
    required this.value,
    required this.label,
  });

  // 단위를 추가하거나 시간을 포맷팅하는 메서드
  String _formatValue(num value, String label) {
    if (label == '운동 거리') {
      return '${value.toStringAsFixed(2)}km';
    } else if (label == '러닝 경사도') {
      return '$value%';
    } else if (label == '운동 시간') {
      // 시간을 hh:mm:ss 형식으로 변환
      int hours = value ~/ 3600;
      int minutes = (value % 3600) ~/ 60;
      int seconds = value.toInt() % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (label == '소모 칼로리') {
      return '${value}kcal';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _formatValue(value, label),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff1EA6FC),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xffA0A0A0),
          ),
        ),
      ],
    );
  }
}
