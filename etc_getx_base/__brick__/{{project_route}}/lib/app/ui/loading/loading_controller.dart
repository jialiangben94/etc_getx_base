import 'dart:convert';
import 'dart:developer';

import 'package:{{project_route}}/app/services/base/app_constant.dart';
import 'package:{{project_route}}/app/ui/base/base_controller.dart';
import 'package:{{project_route}}/app/utils/app_util.dart';
import 'package:{{project_route}}/app/utils/custom_getx.dart';
import 'package:{{project_route}}/app/utils/share_pref.dart';
import 'package:{{project_route}}/app/utils/translations/app_translations.dart';
import 'package:{{project_route}}/app/utils/translations/label_util.dart';

class LoadingController extends BaseController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  bool onFailed(int code, String message, data) {
    isLoading.value = false;
    if (!super.onFailed(code, message, data)) {
      showConfirmation(message);
      return false;
    }
    return true;
  }
}
