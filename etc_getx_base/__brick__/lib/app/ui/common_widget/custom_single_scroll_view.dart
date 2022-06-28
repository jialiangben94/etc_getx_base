import 'package:flutter/material.dart';

class CustomSingleScrollView extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  final ScrollController controller;
  final Clip clipBehavior;
  final ScrollPhysics physics;
  const CustomSingleScrollView(
      {this.child,
      this.scrollDirection = Axis.vertical,
      this.padding = const EdgeInsets.all(0),
      this.clipBehavior = Clip.hardEdge,
      this.physics,
      this.controller,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: child,
        padding: padding,
        scrollDirection: scrollDirection,
        clipBehavior: clipBehavior,
        physics: physics ?? const ClampingScrollPhysics(),
        controller: controller,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
