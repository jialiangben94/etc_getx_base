import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTimerLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool complusoryIndicator;
  final bool enabled;
  final bool resendEnabled;
  final int timer;
  final Function(String) onChanged;
  final Function(String) onSubmmited;
  final Function onResend;
  final TextInputType inputType;

  const CustomTimerLabel(
    this.label,
    this.controller, {
    this.complusoryIndicator = false,
    this.enabled = true,
    this.resendEnabled = true,
    this.timer = 0,
    this.onChanged,
    this.onSubmmited,
    this.onResend,
    this.inputType = TextInputType.number,
  });

  String convertIntToMinuteSecond(int value) {
    int m, s;

    m = value ~/ 60;

    s = value - (m * 60);

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    minuteLeft = (minuteLeft.length == 1) ? "0$minuteLeft" : minuteLeft;

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    secondsLeft = (secondsLeft.length == 1) ? "0$secondsLeft" : secondsLeft;

    String result = "$minuteLeft:$secondsLeft";

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null && label != '')
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
        Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: colorBlack),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: enabled,
                  controller: controller,
                  keyboardType: inputType,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    fillColor: colorTransparent,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                  onChanged: (value) {
                    if (onChanged != null) {
                      onChanged(value);
                    }
                  },
                  onSubmitted: (value) {
                    if (onSubmmited != null) {
                      onSubmmited(value);
                    }
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  if (onResend != null && resendEnabled) {
                    onResend();
                  }
                },
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: colorBlack)),
                  child: Center(
                      child: Text(
                    (resendEnabled)
                        ? "RESEND"
                        : "RESEND ${convertIntToMinuteSecond(timer)}",
                    style: TextStyle(
                        color: (resendEnabled) ? colorBlack : colorBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
