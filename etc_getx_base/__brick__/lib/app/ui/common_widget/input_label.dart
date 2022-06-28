import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputLabel extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;
  final IconData prefixIcon;
  final bool complusoryIndicator;
  final bool enabled;
  final bool password;
  final bool showPassword;

  final Function onTapShowPassword;
  final Function(String) onChanged;
  final List<TextInputFormatter> inputFormatters;

  const InputLabel(
    this.label,
    this.controller, {
    this.hintText,
    this.inputType = TextInputType.text,
    this.prefixIcon,
    this.complusoryIndicator = false,
    this.enabled = true,
    this.password = false,
    this.showPassword = false,
    this.onTapShowPassword,
    this.onChanged,
    this.inputFormatters,
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
        SizedBox(
          height: 50,
          child: TextFormField(
            keyboardType: inputType,
            enabled: enabled,
            inputFormatters: (inputFormatters == null) ? [] : inputFormatters,
            decoration: InputDecoration(
                prefixIcon: (prefixIcon != null) ? Icon(prefixIcon) : null,
                fillColor: colorBlack,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                suffixIcon: (password)
                    ? InkWell(
                        onTap: onTapShowPassword,
                        child: SizedBox(
                          child: Icon((!showPassword)
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ))
                    : null,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25)),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25)),
                hintText: hintText,
                hintStyle: const TextStyle(color: colorBlack, fontSize: 16)),
            obscureText: password && !showPassword,
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
          ),
        ),
      ],
    );
  }
}
