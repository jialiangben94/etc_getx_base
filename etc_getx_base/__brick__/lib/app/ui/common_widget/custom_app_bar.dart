import 'package:auto_size_text/auto_size_text.dart';
import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isBackEnabled;
  final IconData trailingIcon;
  final String imageIcon;
  final Function onTap;
  final Function onTapTrailingIcon;
  const CustomAppBar(
      {Key key,
      this.title,
      this.isBackEnabled = true,
      this.onTap,
      this.trailingIcon,
      this.imageIcon,
      this.onTapTrailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: Get.mediaQuery.viewPadding.top),
      height: Get.mediaQuery.viewPadding.top + 60,
      child: Stack(
        children: [
          if (isBackEnabled)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    if (onTap == null) {
                      Get.back();
                    } else {
                      onTap();
                    }
                  },
                  child: const SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: colorWhite,
                    ),
                  ),
                ),
              ),
            ),
          if (trailingIcon != null || imageIcon != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    if (onTapTrailingIcon != null) {
                      onTapTrailingIcon();
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: (trailingIcon == null)
                        ? Center(
                            child: Image.asset(
                              "assets/icons/$imageIcon.png",
                              width: 30,
                              height: 30,
                              color: colorWhite,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Icon(
                            trailingIcon,
                            size: 30,
                            color: colorWhite,
                          ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 65),
            child: Center(
              child: AutoSizeText(
                title,
                style: const TextStyle(fontSize: 18, color: colorWhite),
                maxLines: 1,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
