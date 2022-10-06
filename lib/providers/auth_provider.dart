import 'dart:io' show Platform;
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:lab_availability_checker/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginType { user, admin }

class AuthProvider extends ChangeNotifier {
  Credentials? credentials;
  late Auth0 auth0;
  SharedPreferences? _prefs;

  AuthProvider(LoginType type) {
    if (type == LoginType.user) {
      auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    } else if (type == LoginType.admin) {
      auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_ADMIN_CLIENT_ID']!);
    }
    getPrefs();
  }

  getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  login() async {
    final _credentials = await auth0
        .webAuthentication(scheme: Platform.isAndroid ? "lab-monitor" : null)
        .login(audience: Constants.API_URL);
    credentials = _credentials;
    _prefs!.setBool("login/is-admin", false);
    notifyListeners();
  }

  changeLoginType(LoginType type) async {
    if (type == LoginType.user) {
      auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    } else if (type == LoginType.admin) {
      auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_ADMIN_CLIENT_ID']!);
    }
  }

  loginWithPassword() async {
    changeLoginType(LoginType.admin);
    final _credentials = await auth0
        .webAuthentication(scheme: Platform.isAndroid ? "lab-monitor" : null)
        .login(audience: Constants.API_URL);
    credentials = _credentials;
    _prefs!.setBool("login/is-admin", true);

    notifyListeners();
  }

  setLoginType() async {}
  updateCredentials() async {
    if (credentials!.expiresAt.compareTo(DateTime.now()) == -1) {
      credentials = await auth0.credentialsManager.credentials();
    }
  }

  Future<Credentials?> getStoredCredentials() async {
    final isLoggedIn = await auth0.credentialsManager.hasValidCredentials();
    if (isLoggedIn) {
      credentials = await auth0.credentialsManager.credentials();
    } else {
      credentials = null;
    }
    notifyListeners();
    return credentials;
  }

  logout() async {
    await auth0.webAuthentication(scheme: Platform.isAndroid ? "lab-monitor" : null).logout();
    await auth0.credentialsManager.clearCredentials();
    credentials = null;
    _prefs!.remove("login/is-admin");
    notifyListeners();
  }
}
