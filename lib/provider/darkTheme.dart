import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class DarkThem with ChangeNotifier {
  static const THEME_SETTING = "THEMESETTING";
  bool _darkTheme = false;

  setThemePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_SETTING, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(THEME_SETTING) ?? false;
    return _darkTheme;
  }

  bool isDark() {
    if (_darkTheme == true) return true;
    return false;
  }

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    setThemePref(value);
    notifyListeners();
  }

  AppPreference() {
    getTheme().then((value) {
      print('value read from storage: ' + value.toString());
      notifyListeners();
    });
  }
}
