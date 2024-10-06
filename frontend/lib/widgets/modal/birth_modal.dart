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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    DateTime? tempPickedDate = DateTime.now();

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
                    child: Text('취소',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 15)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text('완료',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 15)),
                    onPressed: () => Navigator.of(context).pop(tempPickedDate),
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
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _controller.text = formattedDate;
      widget.onChanged(formattedDate);
    } else {
      // 사용자가 날짜를 선택하지 않고 완료 버튼을 누를 경우 현재 날짜 설정하지 않고 필드를 비워 둠
      _controller.clear();
      widget.onChanged("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: (value) {
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Color(0xFF72777A)),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Colors.black12)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Colors.blueAccent)),
        filled: true,
        fillColor: Color(0xFFE3E5E5).withOpacity(0.4),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}
