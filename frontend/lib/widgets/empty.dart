import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String mainContent;
  final String? subContent;

  Empty({
    Key? key,
    required this.mainContent,
    this.subContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/empty.png',
            height: 40,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            mainContent,
            style: TextStyle(
                color: Color(0xffB9B9B9), fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
