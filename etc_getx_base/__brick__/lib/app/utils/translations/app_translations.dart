import 'package:{{project_route}}/app/services/base/app_constant.dart';
import 'package:{{project_route}}/app/utils/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageModel {
  final String title;
  final String code;
  LanguageModel({
    this.title,
    this.code,
  });
}

class AppTranslation extends GetxController {
  Locale appLocale = const Locale(LANG_EN);

  static const String LANG_EN = 'en';
  static const String LANG_BM = 'bm';
  static const String LANG_CN = 'cn';
  static List<LanguageModel> LANG_LIST = [
    LanguageModel(title: "English", code: LANG_EN),
    LanguageModel(title: "简体中文", code: LANG_CN),
    LanguageModel(title: "Bahasa Malaysia", code: LANG_BM)
  ];
  final String KEY_LANGUAGE_CODE = 'language_code';

  Locale fetchLocale() {
    var code = SharePref.sharePref.languageCode;
    appLocale = Locale(code);
    return appLocale;
  }

  String fetchLanguageCode() {
    return SharePref.sharePref.languageCode;
  }

  void changeLanguage(String langCode) async {
    appLocale = Locale(langCode);
    await SharePref.sharePref.saveLanguageCode(langCode);
    AppConstant().languageCode.value = langCode;
    Get.updateLocale(appLocale);
  }
}
