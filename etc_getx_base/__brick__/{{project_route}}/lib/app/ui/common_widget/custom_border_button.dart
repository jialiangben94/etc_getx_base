import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBorderButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final double height;
  final Function onTap;
  const CustomBorderButton(this.title, this.onTap,
      {this.height = 50, this.titleColor = colorBlack, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(color: titleColor),
          boxShadow: [
            BoxShadow(
                color: colorBlack.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4)
          ]),
      child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Text(
            title,
            style: TextStyle(color: titleColor, fontSize: 16),
          )),
    );
  }
}
