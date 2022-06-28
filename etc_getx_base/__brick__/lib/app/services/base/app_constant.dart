import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AppConstant {
  static final AppConstant _app = AppConstant._();
  factory AppConstant() => _app;
  AppConstant._();

  var baseUrl = "";

  var version = '';
  var deviceId = '';
  var platform = '';
  var osVersion = '';
  var deviceModel = '';
  Directory dir;
  String downloadPath;

  RxString languageCode = "en".obs;
}
