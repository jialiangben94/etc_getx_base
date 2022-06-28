import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:{{project_route}}/app/utils/pro_base_state.dart';

abstract class BaseController extends FullLifeCycleController
    with FullLifeCycleMixin {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    setStatusBarColor(null);
  }

  @override
  void onClose() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        ProBaseState.statusBarTextWhiteColor);
    super.onClose();
  }

  @override
  void onDetached() {
    log('$runtimeType - onDetached called');
  }

  @override
  void onInactive() {
    log('$runtimeType - onInactive called');
  }

  @override
  void onPaused() {
    log('$runtimeType - onPaused called');
  }

  @override
  void onResumed() {
    log('$runtimeType - onResumed called');
  }

  Future<void> setStatusBarColor(bool isWhite) async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(
        isWhite ?? ProBaseState.statusBarTextWhiteColor);
  }

  bool onFailed(int code, String message, dynamic data) {
    if (ProBaseState.onFailed == null) return false;
    return ProBaseState.onFailed(Get.context, code, message);
  }
}
