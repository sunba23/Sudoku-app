import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme;
  final String key = "theme";

  ThemeNotifier() : _currentTheme = lightTheme {
    _loadFromPrefs();
  }

  _initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await _initPrefs();
    _currentTheme = (prefs.getBool(key) ?? false) ? darkTheme : lightTheme;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await _initPrefs();
    prefs.setBool(key, _currentTheme == darkTheme);
  }

  getTheme() => _currentTheme;
  isDarkMode() => _currentTheme == darkTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == darkTheme ? lightTheme : darkTheme;
    _saveToPrefs();
    notifyListeners();
  }
}