import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButtonLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool complusoryIndicator;
  final bool enabled;
  final Function(String) onChanged;
  final TextInputType inputType;
  final Function onSubmmited;

  const CustomButtonLabel(
    this.label,
    this.controller, {
    this.complusoryIndicator = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmmited,
    this.inputType = TextInputType.number,
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
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(6),
                  // ],
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
                ),
              ),
              InkWell(
                onTap: () {
                  if (onSubmmited != null) {
                    onSubmmited();
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: colorBlack)),
                  child: const Center(
                      child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: colorBlack,
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
