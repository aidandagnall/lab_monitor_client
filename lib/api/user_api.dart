import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/models/user.dart';
import 'package:lab_availability_checker/models/user_permissions.dart';
import 'package:lab_availability_checker/util/constants.dart';

class UserApi {
  final client = http.Client();

  Future<User?> getUser(String token, String userId) async {
    final response = await client.get(Uri.http(Constants.API_URL, 'user/$userId'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  }

  Future<bool> removeUserPermission(String token, String userId, String permission) async {
    final response = await client.post(
        Uri.http(Constants.API_URL, 'user/$userId/remove-permission/$permission'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 202) {
      return false;
    }

    return true;
  }

  Future<bool> addUserPermission(String token, String userId, String permission) async {
    final response = await client.post(
        Uri.http(Constants.API_URL, 'user/$userId/add-permission/$permission'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 202) {
      return false;
    }

    return true;
  }

  Future<UserPermissions?> getPermissions(String token) async {
    final response = await client.get(Uri.http(Constants.API_URL, 'user/permissions'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final permissions = UserPermissions.fromJson(jsonDecode(response.body));
    return permissions;
  }
}
