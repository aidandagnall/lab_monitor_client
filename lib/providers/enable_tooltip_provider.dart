import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableTooltipProvider extends ChangeNotifier {
  bool enabled = true;
  SharedPreferences? _prefs;

  EnableTooltipProvider() {
    getThemeFromSP();
  }

  EnableTooltipProvider.initial(bool _enabled) {
    enabled = _enabled;
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  setEnabled(bool _enabled) async {
    enabled = _enabled;
    _updateSharedPrefs(enabled);
    notifyListeners();
  }

  void _updateSharedPrefs(bool value) async {
    await _initPrefs();
    _prefs!.setBool("settings/enabled-tooltips", value);
  }

  getThemeFromSP() async {
    await _initPrefs();
    enabled = _prefs!.getBool("settings/enabled-tooltips") ?? false;
  }
}
