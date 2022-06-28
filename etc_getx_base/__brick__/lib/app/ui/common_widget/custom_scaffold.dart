import 'package:{{project_route}}/app/utils/app_colors.dart';
import 'package:{{project_route}}/app/utils/app_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {this.body,
      this.isClosable = true,
      this.closePopup = false,
      this.enableSafeArea = true,
      this.hideKeyboardWhenTappedAround = true,
      this.resizeToAvoidBottomInset = true,
      this.musicPopUp = true,
      this.appBar,
      this.drawer,
      this.drawerDragStartBehavior = DragStartBehavior.start,
      this.bottomNavigationBar,
      this.floatingActionButton,
      Key key})
      : super(key: key);

  final Widget body;
  final Drawer drawer;
  final Widget bottomNavigationBar;
  final bool isClosable;
  final bool closePopup;
  final bool enableSafeArea;
  final bool hideKeyboardWhenTappedAround;
  final bool musicPopUp;
  final AppBar appBar;
  final DragStartBehavior drawerDragStartBehavior;
  final bool resizeToAvoidBottomInset;
  final Color backgroundColor = colorWhite;
  final Widget floatingActionButton;
  Future<bool> defaultPop(BuildContext context) async {
    return true;
  }

  Future<bool> blockClose(BuildContext context) async {
    return closePopup ? showBlockClose() : false;
  }

  Widget _child() {
    return Container(
      color: backgroundColor,
      child: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (closePopup) {
          return blockClose(context);
        } else {
          return isClosable ? defaultPop(context) : blockClose(context);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          bool canTap = hideKeyboardWhenTappedAround;
          if (canTap != null && canTap) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        child: Scaffold(
          appBar: appBar,
          drawer: drawer,
          drawerDragStartBehavior: drawerDragStartBehavior,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: (enableSafeArea) ? SafeArea(child: _child()) : _child(),
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
