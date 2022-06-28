import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final List<DateTime> eventList;
  final DateTime initialDate;
  final Function(DateTime) onSelectedDate;
  const CustomCalendar(this.onSelectedDate,
      {this.initialDate, this.eventList, Key key})
      : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<DateTime> _eventList = [];
  bool isInitialSelect = false;

  @override
  void initState() {
    super.initState();
    _eventList = (widget.eventList == null) ? [] : widget.eventList;
    _focusDay =
        (widget.initialDate == null) ? DateTime.now() : widget.initialDate;
    isInitialSelect = (widget.initialDate == null) ? false : true;
  }

  Widget _header() {
    return Row(
      children: [
        Text(
          DateFormat("MMMM yyyy").format(_focusDay),
          style: const TextStyle(color: colorBlack, fontSize: 18),
        ),
        const Spacer(),
        InkWell(
          onTap: () => _changeMonth(-1),
          child: const Icon(
            Icons.chevron_left,
            size: 30,
            color: colorBlack,
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () => _changeMonth(1),
          child: const Icon(
            Icons.chevron_right,
            size: 30,
            color: colorBlack,
          ),
        ),
      ],
    );
  }

  _changeMonth(int num) {
    setState(() {
      _focusDay =
          DateTime(_focusDay.year, _focusDay.month + num, _focusDay.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: colorWhite,
          boxShadow: [
            BoxShadow(
                color: colorBlack.withOpacity(0.16),
                offset: const Offset(0, 4),
                blurRadius: 4)
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusDay,
            currentDay: _selectedDay,
            headerVisible: false,
            eventLoader: (day) => _eventList
                .where((event) =>
                    isSameDay(event, day) &&
                    (!isSameDay(event, _selectedDay) || !isInitialSelect))
                .toList(),
            daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: ((date, locale) {
                  return DateFormat("EE").format(date);
                }),
                weekdayStyle: const TextStyle(
                    color: colorBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                weekendStyle: const TextStyle(
                    color: colorBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
            calendarStyle: CalendarStyle(
              defaultTextStyle:
                  const TextStyle(fontSize: 14, color: colorBlack),
              weekendTextStyle:
                  const TextStyle(fontSize: 14, color: colorBlack),
              // selectedTextStyle: TextStyle(
              //     fontSize: 12, color: colorWhite, fontWeight: FontWeight.w700),
              todayTextStyle: TextStyle(
                  fontSize: 14,
                  color: isInitialSelect ? colorWhite : colorBlack,
                  fontWeight:
                      isInitialSelect ? FontWeight.w700 : FontWeight.normal),
              todayDecoration: BoxDecoration(
                  color: isInitialSelect ? colorBlack : colorTransparent,
                  shape: BoxShape.circle),
              markersMaxCount: 1,
              markerDecoration: const BoxDecoration(
                  color: colorBlack, shape: BoxShape.circle),
            ),
            onPageChanged: (date) {
              setState(() {
                _focusDay = date;
              });
            },
            onDaySelected: (previousDate, nextDate) {
              if (widget.onSelectedDate != null) {
                widget.onSelectedDate(nextDate);
              }
              setState(() {
                isInitialSelect = true;
                _selectedDay = nextDate;
              });
            },
          ),
        ],
      ),
    );
  }
}
