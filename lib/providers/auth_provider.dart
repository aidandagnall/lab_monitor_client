import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lab_availability_checker/util/constants.dart';

class AuthProvider extends ChangeNotifier {
  Credentials? credentials;
  final auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  AuthProvider() {
    getStoredCredentials();
  }

  login() async {
    final _credentials = await auth0.webAuthentication().login(audience: Constants.API_URL);
    credentials = _credentials;
    notifyListeners();
  }

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
    await auth0.webAuthentication().logout();
    await auth0.credentialsManager.clearCredentials();
    credentials = null;
    notifyListeners();
  }
}
