import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;
  final bool showScrollToTopButton;

  ScrollToTopButton(
      {required this.scrollController, required this.showScrollToTopButton});

  @override
  Widget build(BuildContext context) {
    return showScrollToTopButton
        ? Padding(
            padding: EdgeInsets.only(bottom: 90),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Colors.white,
                ),
                elevation: WidgetStateProperty.all(8),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  EdgeInsets.all(20),
                ),
                shadowColor: WidgetStateProperty.all(
                  Colors.black26,
                ),
              ),
              onPressed: () {
                scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(
                Icons.arrow_upward,
                color: Color(0xff1EA6FC),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
