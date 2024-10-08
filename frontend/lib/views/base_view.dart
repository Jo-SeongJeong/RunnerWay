import 'package:flutter/material.dart';
import 'package:frontend/widgets/under_bar.dart';

class BaseView extends StatelessWidget {
  final Widget child; // 각 화면에서 전달할 위젯

  BaseView({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: child,
          ),

          // 하단바 (UnderBar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: UnderBar(),
          ),
        ],
      ),
    );
  }
}
