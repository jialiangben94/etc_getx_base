import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomImageStack extends StatelessWidget {
  final List<String> imageList;
  final double imageRadius;
  final Color backgroundColor;
  final ImageSource imageSource;

  const CustomImageStack({
    Key key,
    this.imageList,
    this.imageRadius = 25,
    this.imageSource = ImageSource.Asset,
    this.backgroundColor = colorWhite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgetList = imageList
        .sublist(0, imageList.length)
        .asMap()
        .map((index, value) => MapEntry(
            index,
            Padding(
              padding: EdgeInsets.only(left: 0.7 * imageRadius * index),
              child: circularImage(value),
            )))
        .values
        .toList()
        .reversed
        .toList();

    return Container(
      child: widgetList.isNotEmpty
          ? Stack(
              clipBehavior: Clip.none,
              children: widgetList,
            )
          : const SizedBox(),
    );
  }

  Widget circularImage(String imageUrl) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  imageProvider(imageUrl) {
    if (imageSource == ImageSource.Asset) {
      return AssetImage("assets/images/$imageUrl.png");
    } else if (imageSource == ImageSource.File) {
      return FileImage(imageUrl);
    }
    return NetworkImage(imageUrl);
  }
}

enum ImageSource { Asset, Network, File }
