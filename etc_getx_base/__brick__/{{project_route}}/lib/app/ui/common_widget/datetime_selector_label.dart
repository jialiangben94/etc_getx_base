import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:{{project_route}}/app/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_picker_widget/time_picker_widget.dart' as timerPicker;

class DateTimeSelectorLabel extends StatelessWidget {
  final BuildContext context;
  final String label;
  final TextEditingController controller;
  final bool complusoryIndicator;
  final bool enabled;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Duration initialSelectableTime;
  final bool isHourAfter;
  DateTime currentDate;

  DateTimeSelectorLabel(
    this.context,
    this.label,
    this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate, {
    this.complusoryIndicator = false,
    this.enabled = true,
    this.currentDate,
    this.initialSelectableTime = const Duration(hours: 12),
    this.isHourAfter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        (complusoryIndicator)
            ? Text.rich(TextSpan(
                text: label,
                style: const TextStyle(color: colorBlack, fontSize: 14),
                children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: colorBlack),
                    ),
                  ]))
            : Text(
                label,
                style: const TextStyle(color: colorBlack, fontSize: 14),
              ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            var initial = initialDate.add(initialSelectableTime);
            var date = await showDatePicker(
              context: context,
              initialDate: isHourAfter ? initial : initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              currentDate: (currentDate == null) ? initialDate : currentDate,
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(primary: colorBlack),
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  child: child,
                );
              },
            );

            var restrictTime = false;
            if (isHourAfter) {
              restrictTime = isSameDay(date, initial);
            }

            var time = await timerPicker.showCustomTimePicker(
              context: context,
              initialTime: restrictTime
                  ? TimeOfDay.fromDateTime(initial)
                  : TimeOfDay.now(),
              // initialEntryMode: timerPicker.TimePickerEntryMode.input,
              selectableTimePredicate: (time) {
                if (restrictTime) {
                  return time.hour > initial.hour ||
                      (time.hour == initial.hour &&
                          time.minute >= initial.minute);
                } else {
                  return true;
                }
              },
              onFailValidation: (context) =>
                  showConfirmation("Unavailable Selection"),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(primary: colorBlack),
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  child: child,
                );
              },
            );

            if (date == null || time == null) return;
            var combineDate = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
            controller.text =
                DateFormat("dd MMM yyyy h:mm a").format(combineDate);
          },
          child: SizedBox(
            height: 50,
            child: TextField(
              enabled: false,
              controller: controller,
              decoration: InputDecoration(
                fillColor: colorBlack,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                suffixIcon: const Icon(
                  Icons.calendar_today_rounded,
                  color: colorBlack,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25)),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25)),
              ),
              style: const TextStyle(
                color: colorBlack,
                fontSize: 16,
              ),
              onChanged: (value) {},
              onSubmitted: (value) {},
            ),
          ),
        ),
      ],
    );
  }
}
