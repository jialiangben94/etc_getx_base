import 'package:cached_network_image/cached_network_image.dart';
import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final int memCacheHeight;
  final int memCacheWidth;
  final BoxFit fit;
  const CustomCachedImage(this.imageUrl,
      {this.width,
      this.height,
      this.memCacheHeight,
      this.memCacheWidth,
      this.fit = BoxFit.cover,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) =>
          const Icon(Icons.image, size: 60, color: colorBlack),
      placeholder: (context, url) =>
          const Icon(Icons.image, size: 60, color: colorBlack),
    );
  }
}
