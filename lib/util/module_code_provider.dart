import 'package:flutter/material.dart';
import 'package:lab_availability_checker/models/module_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleCodeStyleProvider with ChangeNotifier {
  ModuleCodeStyle style = ModuleCodeStyle.modern;
  SharedPreferences? _prefs;

  ModuleCodeStyleProvider() {
    getThemeFromSP();
  }

  ModuleCodeStyleProvider.initial(ModuleCodeStyle _style) {
    style = _style;
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  setSelectedStyle(ModuleCodeStyle _style) async {
    style = _style;
    _updateSharedPrefs(_style.index);
    notifyListeners();
  }

  void _updateSharedPrefs(int value) async {
    await _initPrefs();
    _prefs!.setInt("settings/module-code-style", value);
  }

  getThemeFromSP() async {
    await _initPrefs();
    style = ModuleCodeStyle.values[_prefs!.getInt("settings/module-code-style") ?? 0];
  }
}
