import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/util/constants.dart';

class UserApi {
  final client = http.Client();

  Future<List<String>?> getPermissions(String token) async {
    final response = await client.get(Uri.http(Constants.API_URL, 'user/permissions'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final permissions = (jsonDecode(response.body) as List).map((e) => e.toString()).toList();
    print(permissions);
    return permissions;
  }
}
