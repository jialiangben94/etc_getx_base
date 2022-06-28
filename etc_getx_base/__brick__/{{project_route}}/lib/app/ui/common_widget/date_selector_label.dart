import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectorLabel extends StatelessWidget {
  final BuildContext context;
  final String label;
  final TextEditingController controller;
  final bool complusoryIndicator;
  final bool enabled;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  DateTime currentDate;
  bool showAsterisk;

  DateSelectorLabel(
    this.context,
    this.label,
    this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate, {
    this.complusoryIndicator = false,
    this.enabled = true,
    this.currentDate,
    this.showAsterisk = false,
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
                children: [
                    TextSpan(
                      text: showAsterisk ? '*' : '',
                      style: const TextStyle(color: colorBlack),
                    ),
                  ]))
            : Text(
                label,
                style: const TextStyle(color: colorBlack, fontSize: 14),
              ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            var date = await showDatePicker(
              context: context,
              initialDate: initialDate,
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

            if (date == null) return;
            controller.text = DateFormat("dd MMM yyyy").format(date);
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
