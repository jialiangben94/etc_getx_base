import 'package:{{project_route}}/app/ui/common_widget/custom_app_bar.dart';
import 'package:{{project_route}}/app/ui/loading/loading_controller.dart';
import 'package:{{project_route}}/app/ui/base/base_page.dart';
import 'package:{{project_route}}/app/ui/common_widget/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingPage extends BasePage<LoadingController> {
  @override
  // TODO: implement routeName
  String get routeName => "/loading";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScaffold(
      enableSafeArea: false,
      body: Center(
        child: Text(
          "LOADING PAGE",
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
