import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputAreaLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool complusoryIndicator;
  final bool enabled;
  final String hint;
  final Color backgroundColor;
  final int maxLines;
  final int maxCharacter;
  final Function(String) onChanged;
  final Function(String) onSubmmited;

  const InputAreaLabel(
    this.label,
    this.controller, {
    this.complusoryIndicator = false,
    this.enabled = true,
    this.maxLines = 5,
    this.maxCharacter,
    this.backgroundColor = colorBlack,
    this.hint = "",
    this.onChanged,
    this.onSubmmited,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label.isNotEmpty)
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
        if (label.isNotEmpty) const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLength: maxCharacter,
          // ma
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: colorBlack,
              fontSize: 16,
            ),
            fillColor: backgroundColor,
            filled: true,
            contentPadding: const EdgeInsets.all(10),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: colorBlack),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: colorBlack),
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: colorBlack),
                borderRadius: BorderRadius.circular(10)),
          ),
          controller: controller,
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
      ],
    );
  }
}
