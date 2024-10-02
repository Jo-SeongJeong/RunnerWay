import 'package:flutter/material.dart';
import 'package:frontend/controllers/record_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  // 처음에 selectedDate는 오늘 날짜로 설정
  Calendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RecordController recordController = Get.find<RecordController>();

    // selectedDate는 오늘 날짜로 초기화하고, focusedMonth는 선택된 날짜의 달로 초기화
    DateTime selectedDate =
        recordController.selectedDate.value ?? DateTime.now();
    DateTime focusedMonth =
        recordController.focusedDate.value ?? DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 월 이동 버튼과 현재 보여주는 월 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                onPressed: () {
                  recordController.setFocusedDate(
                      DateTime(focusedMonth.year, focusedMonth.month - 1));
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('yyyy.MM').format(focusedMonth),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  recordController.setFocusedDate(
                      DateTime(focusedMonth.year, focusedMonth.month + 1));
                },
              ),
            ),
          ],
        ),

        // 달력 표시
        Obx(() {
          // 매번 선택된 날짜와 포커스된 달에 따라 달력을 다시 그리도록 함
          return TableCalendar(
            onDaySelected: (selectedDay, focusedDay) {
              // 날짜 선택 시 selectedDate 업데이트
              recordController.setSelectedDate(selectedDay);
              recordController.setFocusedDate(focusedDay); // 해당 월로 업데이트
            },
            selectedDayPredicate: (date) =>
                isSameDay(recordController.selectedDate.value, date),
            focusedDay: recordController.focusedDate.value ?? DateTime.now(),
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2025, 1, 31),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayTextStyle: TextStyle(
                color: null,
              ),
              todayDecoration: BoxDecoration(
                color: null,
              ),
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF1EA6FC),
              ),
              selectedDecoration: BoxDecoration(color: null),
            ),
            headerStyle: HeaderStyle(
              titleTextFormatter: (date, locale) => "",
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
              headerMargin: EdgeInsets.only(bottom: 1),
              titleTextStyle: TextStyle(fontSize: 0),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Color(0xFF6C7072).withOpacity(0.5),
                fontSize: 13,
              ),
              weekendStyle: TextStyle(
                color: Color(0xFF6C7072).withOpacity(0.5),
                fontSize: 13,
              ),
              dowTextFormatter: (date, locale) =>
                  DateFormat.E(locale).format(date)[0],
            ),
            daysOfWeekHeight: 44,
          );
        }),
      ],
    );
  }
}
