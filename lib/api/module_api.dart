import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/api/api.dart';
import 'package:lab_availability_checker/models/module.dart';

class ModuleApi {
  final client = http.Client();

  Future<List<Module>?> getModules(String token) async {
    final response = await client.get(UriFactory.getRoute('module'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final modules = (jsonDecode(response.body) as List).map((e) => Module.fromJson(e));
    return modules.toList();
  }
}
