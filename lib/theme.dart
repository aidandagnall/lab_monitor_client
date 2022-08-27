import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode selectedMode = ThemeMode.system;
  SharedPreferences? _prefs;

  ThemeProvider() {
    getThemeFromSP();
  }

  ThemeProvider.initial(ThemeMode mode) {
    selectedMode = mode;
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  setSelectedThemeMode(ThemeMode _themeMode) async {
    selectedMode = _themeMode;
    _updateSharedPrefs(_themeMode == ThemeMode.dark);
    notifyListeners();
  }

  void _updateSharedPrefs(bool value) async {
    await _initPrefs();
    _prefs!.setBool("settings/dark-mode", value);
  }

  getThemeFromSP() async {
    await _initPrefs();
    selectedMode =
        (_prefs!.getBool("settings/dark-mode") ?? false) ? ThemeMode.dark : ThemeMode.light;
  }
}
