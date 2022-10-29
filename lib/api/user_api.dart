import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/api/api.dart';
import 'package:lab_availability_checker/models/user.dart';
import 'package:lab_availability_checker/models/user_permissions.dart';

class UserApi {
  final client = http.Client();

  Future<List<String>?> getAllPermissions() async {
    final response = await client.get(
      UriFactory.getRoute('user/permissions/all'),
    );

    if (response.statusCode != 200) {
      return null;
    }
    final perms = (jsonDecode(response.body) as List).map((e) => e.toString()).toList();
    return perms;
  }

  Future<User?> getUser(String token, String userId) async {
    final response = await client.get(UriFactory.getRoute('user/$userId'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  }

  Future<bool> removeUserPermission(String token, String userId, String permission) async {
    final response = await client.post(
        UriFactory.getRoute('user/$userId/remove-permission/$permission'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 202) {
      return false;
    }

    return true;
  }

  Future<bool> addUserPermission(String token, String userId, String permission) async {
    final response = await client.post(
        UriFactory.getRoute('user/$userId/add-permission/$permission'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 202) {
      return false;
    }

    return true;
  }

  Future<UserPermissions?> getPermissions(String token) async {
    final response = await client.get(UriFactory.getRoute('user/permissions'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final permissions = UserPermissions.fromJson(jsonDecode(response.body));
    return permissions;
  }
}
