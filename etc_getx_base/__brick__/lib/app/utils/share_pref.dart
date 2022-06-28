import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static SharedPreferences _prefs;
  static final SharePref sharePref = SharePref._();
  SharePref._();

  static const String _tokenKey = "AccessToken";
  static const String _userIdKey = "UserId";
  static const String _languageCodeKey = "LanguageCode";

  Future initialize() async {
    if (_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();

    log((_prefs == null)
        ? "Shared Preferences failed to initialize"
        : "Shared Preferences is initialized");
  }

  Future<bool> saveAccessToken(String token) async {
    return await _prefs.setString(_tokenKey, token) ?? false;
  }

  String get accessToken {
    return _prefs.getString(_tokenKey) ?? "";
  }

  String get fastAccessToken {
    return _prefs?.getString(_tokenKey) ?? "";
  }

  removeAccessToken() async {
    _prefs.remove(_tokenKey);
  }

  bool saveUserId(String userId) {
    return _prefs.setString(_userIdKey, userId) ?? false;
  }

  String get userId {
    return _prefs.getString(_userIdKey) ?? "";
  }

  Future<bool> saveLanguageCode(String code) {
    return _prefs.setString(_languageCodeKey, code) ?? false;
  }

  String get languageCode {
    return _prefs.getString(_languageCodeKey) ?? "en";
  }
}
