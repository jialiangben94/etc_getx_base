import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_route}}/app/ui/base/base_controller.dart';

abstract class BasePage<T extends BaseController> extends GetView<T>
    with WidgetsBindingObserver {
  String get routeName;
}
