import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lab_availability_checker/api/auth_api.dart';

class TokenProvider extends ChangeNotifier {
  String? token;
  String? email;
  final storage =
      const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  TokenProvider() {
    getThemeFromStorage();
  }

  setToken(String _token, String _email) async {
    token = _token;
    email = _email;
    await storage.write(key: "auth-token", value: token);
    await storage.write(key: "email", value: email);
    notifyListeners();
  }

  getThemeFromStorage() async {
    token = await storage.read(key: "auth-token");
    email = await storage.read(key: "email");
  }

  Future<bool> logout() async {
    if (await AuthApi().logout(token!)) {
      token = null;
      email = null;
      await storage.write(key: "auth-token", value: null);
      await storage.write(key: "email", value: null);
      notifyListeners();
      return true;
    }
    return false;
  }
}
