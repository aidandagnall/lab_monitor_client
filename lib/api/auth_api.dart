import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/util/constants.dart';

class AuthApi {
  final client = http.Client();

  Future<String?> submitEmail(String email) async {
    final response =
        await client.post(Uri.https(Constants.AUTHORITY, Constants.PATH + 'auth/email'), headers: {
      "Accept": "*/*",
      "content-type": "application/x-www-form-urlencoded",
    }, body: {
      "email": email
    });

    if (response.statusCode == 202) {
      return response.body;
    }
    return null;
  }

  Future<bool> submitCode(String verificationCode, String token) async {
    final response =
        await client.post(Uri.https(Constants.AUTHORITY, Constants.PATH + 'auth/code'), headers: {
      "content-type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer $token"
    }, body: {
      "code": verificationCode,
    });

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> logout(String token) async {
    final response = await client
        .post(Uri.https(Constants.AUTHORITY, Constants.PATH + 'auth/logout'), headers: {
      "content-type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 202) {
      return true;
    }
    return false;
  }
}
