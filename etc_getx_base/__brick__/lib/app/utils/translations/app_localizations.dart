import 'dart:developer';

import 'package:{{project_route}}/app/model/api/label.dart';
import 'package:{{project_route}}/app/services/base/app_constant.dart';
import 'package:{{project_route}}/app/utils/translations/app_translations.dart';
import 'package:{{project_route}}/app/utils/translations/label_util.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  List<Label> _labels = [];

  Future<bool> load() async {
    log('load');
    // Load the language from file
    _labels = await LabelUtil().getLabels(AppConstant().languageCode.value);

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    try {
      String value;
      if (AppConstant().languageCode.value == 'en') {
        value = _labels.firstWhere((item) => item.key == key).enValue;
      } else if (AppConstant().languageCode.value == 'bm') {
        value = _labels.firstWhere((item) => item.key == key).bmValue;
      } else {
        value = _labels.firstWhere((item) => item.key == key).cnValue;
      }
      if (value.isEmpty) {
        return null;
      }
      return value.replaceAll('\\n', '\n');
    } catch (e) {
      return null;
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return [AppTranslation.LANG_EN].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
