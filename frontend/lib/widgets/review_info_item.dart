import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocationInfo extends StatelessWidget {
  final String title;
  final String address;
  final DateTime time;

  const LocationInfo({
    super.key,
    required this.title,
    required this.address,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Image.asset(
              'assets/icons/location.png',
              width: 20,
              height: 20,
            ),
            SizedBox(width: 5),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Text(
                  address,
                  style: TextStyle(color: Color(0xffA0A0A0)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              }),
            ),
            SizedBox(width: 8),
            Text(
              DateFormat('yyyy-MM-dd HH:mm:ss').format(time),
              style: TextStyle(
                fontSize: 16,
                color: Color(0xffA0A0A0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
