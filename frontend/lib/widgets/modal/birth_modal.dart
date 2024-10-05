import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BirthModal extends StatefulWidget {
  final bool enabled;
  final Function(String) onChanged;
  final String hintText;

  const BirthModal({
    Key? key,
    this.enabled = true,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _BirthModalState createState() => _BirthModalState();
}

class _BirthModalState extends State<BirthModal> {
  // TextEditingController로 TextField를 제어합니다.
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 초기 힌트 텍스트를 controller에 설정합니다.
    // _controller.text = widget.hintText;
  }

  void _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    DateTime? tempPickedDate = DateTime.now();

    // 하단 달력
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text(
                      '완료',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedDate);
                    },
                  ),
                ],
              ),
              Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                  },
                  minimumYear: 1930,
                  maximumYear: DateTime.now().year,
                  maximumDate: DateTime.now(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null) {
      log('pickedDate : $pickedDate');
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(pickedDate); // 날짜 형식 설정
      widget.onChanged(formattedDate);

      // 선택한 날짜를 TextField에 반영합니다.
      _controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller, // controller 연결
      onChanged: (value) {
        log('value : $value');
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Color(0xFF72777A),
        ),
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
        fillColor: Color(0xFFE3E5E5).withOpacity(0.4),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}
