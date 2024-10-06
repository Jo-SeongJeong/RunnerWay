import 'package:flutter/material.dart';

class SignupInput extends StatelessWidget {
  final String inputType;
  final bool enabled;
  final Function(String) onChanged;
  final String hintText;

  const SignupInput({
    Key? key,
    required this.inputType,
    required this.onChanged,
    this.enabled = true,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    String suffixText;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (inputType == 'height') {
      text = '키';
      suffixText = 'cm';
    } else if (inputType == 'weight') {
      text = '몸무게';
      suffixText = 'kg';
    } else {
      text = '';
      suffixText = '';
    }

    return Container(
      width: (screenWidth - 150) / 2,
      padding: EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF1C1516),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  enabled: enabled,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    filled: true,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Color(0xFF72777A),
                    ),
                    fillColor: Color(0xFFE3E5E5).withOpacity(0.4),
                  ),
                  cursorColor: Colors.blueAccent,
                  onTap: () {
                    Scrollable.ensureVisible(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  suffixText,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
