import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/user.dart';
import 'package:lab_availability_checker/models/user_permissions.dart';
import 'package:lab_availability_checker/util/constants.dart';

class UserApi {
  final client = http.Client();

  Future<User?> getUser(String token, String userId) async {
    final response = await client.get(
        Uri.https(Constants.AUTHORITY, Constants.PATH + 'user/$userId'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  }

  Future<bool> removeUserPermission(String token, String userId, String permission) async {
    final response = await client.post(
        Uri.https(
            Constants.AUTHORITY, Constants.PATH + 'user/$userId/remove-permission/$permission'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 202) {
      return false;
    }

    return true;
  }

  Future<bool> addUserPermission(String token, String userId, String permission) async {
    final response = await client.post(
        Uri.https(Constants.AUTHORITY, Constants.PATH + 'user/$userId/add-permission/$permission'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 202) {
      return false;
    }

    return true;
  }

  Future<UserPermissions?> getPermissions(String token) async {
    final response = await client.get(
        Uri.https(Constants.AUTHORITY, Constants.PATH + 'user/permissions'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final permissions = UserPermissions.fromJson(jsonDecode(response.body));
    return permissions;
  }
}
