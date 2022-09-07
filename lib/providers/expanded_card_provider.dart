import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpandedCardProvider extends ChangeNotifier {
  bool expanded = false;
  SharedPreferences? _prefs;

  ExpandedCardProvider() {
    getThemeFromSP();
  }

  ExpandedCardProvider.initial(bool _expanded) {
    expanded = _expanded;
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  setExpanded(bool _expanded) async {
    expanded = _expanded;
    _updateSharedPrefs(expanded);
    notifyListeners();
  }

  void _updateSharedPrefs(bool value) async {
    await _initPrefs();
    _prefs!.setBool("settings/expanded-cards", value);
  }

  getThemeFromSP() async {
    await _initPrefs();
    expanded = _prefs!.getBool("settings/expanded-cards") ?? false;
  }
}
